//
//  NotesTableViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/24/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

extension NSTableView {
    func hasSelection() -> Bool {
        return (self.selectedRow > -1) && self.selectedRowIndexes.count > 0
    }
}

class NotesTableViewController: NSObject, NSTableViewDataSource, NSTableViewDelegate, DeleteRowDelegate {
    
    weak var notesTableView:DeletableTableView? {
        didSet {
            
            if let tv = notesTableView {
                
                tv.setDelegate(self)
                tv.setDataSource(self)
                tv.wantsLayer = true
                tv.deleteDelegate = self
                tv.selectionHighlightStyle = .Regular
                tv.allowsTypeSelect = true
                
                if let noteCellNib = NSNib(nibNamed: "NoteCell", bundle: nil) {
                    tv.registerNib(noteCellNib, forIdentifier: "NoteCell")
                }
                
                if let rowViewNib = NSNib(nibNamed: "CustomRowView", bundle: nil) {
                    tv.registerNib(rowViewNib, forIdentifier: "CustomRowView")
                }
                

                
                NSNotificationCenter.defaultCenter().addObserver(self,
                                                                 selector: #selector(handleNoteAdded(_:)),
                                                                 name: "NoteAdded",
                                                                 object: nil)
                
                NSNotificationCenter.defaultCenter().addObserver(self,
                                                                 selector: #selector(handleNoteDeleted),
                                                                 name: "NoteDeleted",
                                                                 object: nil)
            }
        }
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {

        return 25.0
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return NoteManager.shared.notes.count
    }

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let view = tableView.makeViewWithIdentifier("NoteCell", owner: nil) as? NoteCell
        
        view!.note = NoteManager.shared.notes.reverse()[row]
        return view
    }
    
    func beginEditingForNewNote(note:Note)   {
        
        // should maybe get to a protocol and extension
        // for this maybe a CRUD tv controller with the HasIDString on the comparision below
        
        
        if let tableView = notesTableView {
            
            tableView.enumerateAvailableRowViewsUsingBlock({ (rowView, row) in
                if let cell = rowView.viewAtColumn(0) as? NoteCell {
                    if let cellNote = cell.note {
                        if cellNote.id == note.id {
                            tableView.scrollRowToVisible(row)
                            cell.select(true)
                            cell.textField?.enterEditing()
                        }
                    }
                }
            })
        }
    }
    
    func tableView(tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let rowView = tableView.makeViewWithIdentifier("CustomRowView",
                                                       owner: nil) as? NSTableRowView
        return rowView
    }
    
    // Notifcation Handlers
    func tableViewSelectionDidChange(notification: NSNotification) {
        NSNotificationCenter.defaultCenter().postNotificationName("SelectedNoteChanged", object: nil)
    }

    func handleNoteAdded(notif:AnyObject) {
        notesTableView?.reloadData()
        
        performSelector(#selector(beginEditingForNewNote(_:)),
                        withObject: notif.object as! Note,
                        afterDelay: 0.3)
    }
    
    func handleNoteDeleted() {
        notesTableView?.reloadData()

    }
    
    // Actions
    func addNoteClicked(sender:AnyObject?) {
        NSNotificationCenter.defaultCenter().postNotificationName("NewNoteAction", object: nil)
    }
    
    // DeleteRowDelegate
    func deleteRow(row: Int) {

        let noteToDelete = NoteManager.shared.notes.reverse()[row]
        var userInfo = Dictionary<String, AnyObject>()
        userInfo["noteToDelete"] = noteToDelete
        userInfo["hostingNoteCell"] = notesTableView?.viewAtColumn(0, row: row, makeIfNecessary: false)
        
        NSNotificationCenter.defaultCenter().postNotificationName("DeleteNoteRequest",
                                                                  object: userInfo)
    }
}
