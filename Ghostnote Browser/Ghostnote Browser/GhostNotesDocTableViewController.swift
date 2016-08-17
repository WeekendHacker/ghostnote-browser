//
//  GhostNotesNoteTableViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 6/4/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa
import SwiftyBeaver

protocol GhostNotesDocTableViewControllerObserver {
    func selectedNote(note:GhostNote)
    func selectedNothing()
}


class GhostNotesDocTableViewController: NSObject, NSTableViewDelegate, NSTableViewDataSource, DeleteRowDelegate {

    var observer:GhostNotesDocTableViewControllerObserver?
    
    var currentApp:App? {
        didSet {
            reload()
        }
    }
    let log = SwiftyBeaver.self
    
    var ghostnotes = Array<GhostNote>()
    
    @IBOutlet weak var docsTableView:DeletableTableView? {
        didSet {
            if let tv = docsTableView {
                tv.setDelegate(self)
                tv.setDataSource(self)
                tv.deleteDelegate = self

                tv.selectionHighlightStyle = .Regular
                tv.target = self
                tv.doubleAction = #selector(doubleClickedAction(_:))
                tv.wantsLayer = true

                if let nib =  NSNib(nibNamed: "DocCell",bundle: nil) {
                    tv.registerNib(nib, forIdentifier: "DocCell")
                }
                if let rowViewNib = NSNib(nibNamed: "CustomRowView", bundle: nil) {
                    tv.registerNib(rowViewNib, forIdentifier: "CustomRowView")
                }
                
                NSNotificationCenter.defaultCenter().addObserver(self,
                                                                 selector: #selector(reload),
                                                                 name: "GhostnoteDeleted",
                                                                 object: nil)
                let console = ConsoleDestination()  // log to Xcode Console
                let file = FileDestination()  // log to default swiftybeaver.log file
                log.addDestination(console)
                log.addDestination(file)
            }
        }
    }
    
    
    func doubleClickedAction(sender:AnyObject?) {
        log.info("")
        if let tv = sender as? NSTableView {
            let row = tv.selectedRow
            if row != NSNotFound {
                let ghostnote = ghostnotes[row]
                NoteSourceOpener.openSourceOf(ghostnote)

            }
        }
    }
    
    func reload() {
        log.info("")

        if let app = currentApp {
            ghostnotes = GhostNoteManager.shared.docNotesForApp(app.bundleID)
        }
        docsTableView?.reloadData()

    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        log.info("returning \(ghostnotes.count)")
        return ghostnotes.count
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 25.0
    }
    
    
    func tableView(tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        log.info("")
        if let rv = tableView.makeViewWithIdentifier("CustomRowView", owner: nil) as? CustomRowView {
            rv.forTasks = false
            log.info("returnng \(rv)")
            return rv
        }
        return nil
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if let view = docsTableView?.makeViewWithIdentifier("DocCell", owner: nil) as! DocCell? {
            view.doc =  Document(note: ghostnotes[row])
            return view
        }
        return nil
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
    
    // MARK DeleteRowDelegate
    
    func deleteRow(row: Int) {
        
        let noteToDelete = ghostnotes[row]
        
        if let cell = docsTableView?.viewAtColumn(0, row: row, makeIfNecessary: false) {
            let payload = ["noteToDelete" : noteToDelete,
                           "hostingCell" : cell]
            
            NSNotificationCenter.defaultCenter().postNotificationName("DeleteGhostnoteRequest",
                                                                      object: payload)
        }
       
    }
}
 