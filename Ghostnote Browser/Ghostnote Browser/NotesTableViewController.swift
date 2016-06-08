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
                
                let buttonNib = NSNib(nibNamed: "ButtonTableCellView", bundle: nil)
                tv.registerNib(buttonNib, forIdentifier: "ButtonTableCellView")
                let noteCellNib = NSNib(nibNamed: "NoteCell", bundle: nil)
                tv.registerNib(noteCellNib, forIdentifier: "NoteCell")
                
                tv.target = self
                tv.action = #selector(tvAction(_:))
                
            }
        }
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return NoteManager.shared.notes.count + 1
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        
        if row == 0 {
            
            let view = tableView.makeViewWithIdentifier("ButtonTableCellView", owner: nil) as? ButtonTableCellView
            let title = NSAttributedString(string: "+ Add New Note", attributes: [NSForegroundColorAttributeName : NSColor.blueColor()])
            view?.button?.attributedTitle = title
            view?.button?.target = self
            view?.button?.action = #selector(addNoteClicked(_:))
            
            return view
        }
        
        
        let view = tableView.makeViewWithIdentifier("NoteCell", owner: nil) as? NoteCell
        
        view!.note = NoteManager.shared.notes[row - 1]
        return view
    }
    
    // func
    func addNoteClicked(sender:AnyObject?) {
        NSNotificationCenter.defaultCenter().postNotificationName("AddNoteClicked", object: nil)
    }
    
    func tvAction(foo:AnyObject?) {
        NSNotificationCenter.defaultCenter().postNotificationName("SelectedNoteChanged", object: foo)
    }
    
    
    // DeleteRowDelegate
    
    func deleteRow(row: Int) {
        let noteToDelete = NoteManager.shared.notes[row - 1]
        NoteManager.shared.deleteNote(noteToDelete)
        notesTableView?.reloadData()
        NSNotificationCenter.defaultCenter().postNotificationName("DeletedNote", object: noteToDelete)
    }
}
