//
//  GhostNotesNoteTableViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 6/4/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

protocol GhostNotesDocTableViewControllerObserver {
    func selectedNote(note:GhostNote)
    func selectedNothing()
}


class GhostNotesDocTableViewController: NSObject, NSTableViewDelegate, NSTableViewDataSource {

    var observer:GhostNotesDocTableViewControllerObserver?
    
    var currentApp:App? {
        didSet {
            reload()
        }
    }
    
    var ghostnotes = Array<GhostNote>()
    
    @IBOutlet weak var docsTableView:NSTableView? {
        didSet {
            if let tv = docsTableView {
                tv.setDelegate(self)
                tv.setDataSource(self)
                
//                tv.selectionHighlightStyle = .None
                
                let nib =  NSNib(nibNamed: "DocCell",bundle: nil)
                tv.registerNib(nib, forIdentifier: "DocCell")
                tv.wantsLayer = true
                tv.backgroundColor = NSColor.clearColor()

            }
        }
    }
    
    func reload() {
        if let app = currentApp {
            ghostnotes = GhostNoteManager.shared.docNotesForApp(app.bundleID)
        }
        docsTableView?.reloadData()

    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return ghostnotes.count
    }
    
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let view = docsTableView?.makeViewWithIdentifier("DocCell", owner: nil) as! DocCell?
        let gn =  ghostnotes[row]
        view!.doc =  Document(note:gn)

        return view
    }
    
    //
    func tableViewSelectionDidChange(notification: NSNotification) {
        
        if let tv = notification.object as? NSTableView! {
            
            if tv.hasSelection() {
                let selectedNote = ghostnotes[tv.selectedRow]
                observer?.selectedNote(selectedNote)
            }else {
                observer?.selectedNothing()
            }
        }
    }
}
 