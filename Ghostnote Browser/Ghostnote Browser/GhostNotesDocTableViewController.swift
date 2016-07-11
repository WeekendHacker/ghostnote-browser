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
                
                tv.selectionHighlightStyle = .Regular
                
                if let nib =  NSNib(nibNamed: "DocCell",bundle: nil) {
                    tv.registerNib(nib, forIdentifier: "DocCell")
                }
                if let rowViewNib = NSNib(nibNamed: "CustomRowView", bundle: nil) {
                    tv.registerNib(rowViewNib, forIdentifier: "CustomRowView")
                }
                
                tv.wantsLayer = true

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
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 25.0
    }
    
    
    func tableView(tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        if let rv = tableView.makeViewWithIdentifier("CustomRowView", owner: nil) as? CustomRowView {
            rv.forTasks = false
            return rv
        }
        return nil
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
            
//            tv.enumerateAvailableRowViewsUsingBlock({ (rowView, row) in
//                
//                if let cell = tv.viewAtColumn(0, row: row, makeIfNecessary: false) as? SelectableCell {
//                    cell.select(rowView.selected)
//                }
//                
//            })
        }
    }
}
 