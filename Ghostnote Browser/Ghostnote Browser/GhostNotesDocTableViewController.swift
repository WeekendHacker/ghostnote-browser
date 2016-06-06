//
//  GhostNotesNoteTableViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 6/4/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class GhostNotesDocTableViewController: NSObject, NSTableViewDelegate, NSTableViewDataSource {

    var currentApp:App? {
        didSet {
            docsTableView?.reloadData()
        }
    }
    
    var ghostnotes = Array<GhostNote>()
    
    @IBOutlet weak var docsTableView:NSTableView? {
        didSet {
            if let tv = docsTableView {
                tv.setDelegate(self)
                tv.setDataSource(self)
                
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
}
 