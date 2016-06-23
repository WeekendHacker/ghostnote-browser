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
                tv.selectionHighlightStyle = .None
                
                if let buttonNib = NSNib(nibNamed: "ButtonTableCellView", bundle: nil) {
                    tv.registerNib(buttonNib, forIdentifier: "ButtonTableCellView")
                }
                
                if let noteCellNib = NSNib(nibNamed: "NoteCell", bundle: nil) {
                    tv.registerNib(noteCellNib, forIdentifier: "NoteCell")
                }
                
                tv.target = self
                tv.action = #selector(tvAction(_:))
                
                NSNotificationCenter.defaultCenter().addObserver(self,
                                                                 selector: #selector(handleNoteAdded(_:)),
                                                                 name: "NoteAdded",
                                                                 object: nil)
            }
        }
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {

        if row == 0 {
            return 50.0
        }
        return 30.0
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return NoteManager.shared.notes.count + 1
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if row == 0 {
            
            let view = tableView.makeViewWithIdentifier("ButtonTableCellView", owner: nil) as? ButtonTableCellView
            let buttonColor = NSColor(netHex: 0x3C75B8)
            let title = NSAttributedString(string: "Add New Note", attributes: [NSForegroundColorAttributeName : buttonColor])
            view?.button?.attributedTitle = title
            view?.button?.target = self
            view?.button?.action = #selector(addNoteClicked(_:))
            
            return view
        }
        
        let view = tableView.makeViewWithIdentifier("NoteCell", owner: nil) as? NoteCell
        
        view!.note = NoteManager.shared.notes.reverse()[row - 1]
        return view
    }
    
    func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if row == 0 {
            return false
        }
        return true
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        tvAction(notesTableView!)
    }

    func beginEditingForNewNote(note:Note)   {
        
        // should maybe get to a protocol and extension
        // for this maybe a CRUD tv controller with the HasIDString on the comparision below
        
        
        if let tableView = notesTableView {
            
            tableView.enumerateAvailableRowViewsUsingBlock({ (rowView, row) in
                if row != 0 {
                    if let cell = rowView.viewAtColumn(0) as? NoteCell {
                        if let cellNote = cell.note {
                            if cellNote.id == note.id {
                                tableView.scrollRowToVisible(row)
                                cell.select(true)
                                cell.textField?.enterEditing()
                            }
                        }
                    }
                }
            })
        }

    }
    
    
    // Notifcation Handlers
    
    func handleNoteAdded(notif:AnyObject) {
        notesTableView?.reloadData()
        
        performSelector(#selector(beginEditingForNewNote(_:)),
                        withObject: notif.object as! Note,
                        afterDelay: 0.3)
    }
    
    
    // Actions
    func addNoteClicked(sender:AnyObject?) {
        NSNotificationCenter.defaultCenter().postNotificationName("NewNoteAction", object: nil)
    }
    
    func tvAction(tv:AnyObject?) {
        if let tableView = tv as? DeletableTableView {

                tableView.enumerateAvailableRowViewsUsingBlock({ (rowView, row) in
                    if row != 0 {
                        if let selectedCell = rowView.viewAtColumn(0) as? SelectableCell {
                            selectedCell.select(rowView.selected)
                        }
                    }
                })
                NSNotificationCenter.defaultCenter().postNotificationName("SelectedNoteChanged", object: nil)
        }

        
    }
    
    // DeleteRowDelegate
    func deleteRow(row: Int) {
        let noteToDelete = NoteManager.shared.notes.reverse()[row - 1]
        NoteManager.shared.deleteNote(noteToDelete)
        notesTableView?.reloadData()
        NSNotificationCenter.defaultCenter().postNotificationName("DeletedNote", object: noteToDelete)
    }
}
