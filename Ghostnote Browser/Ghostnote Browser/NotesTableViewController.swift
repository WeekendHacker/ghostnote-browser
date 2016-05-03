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

class NotesTableViewController: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return NoteManager.shared.notes.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let view = tableView.makeViewWithIdentifier("NoteCell", owner: nil) as? NoteCell
        
        view!.note = NoteManager.shared.notes[row]
        return view
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        
        NSNotificationCenter.defaultCenter().postNotificationName("SelectedNoteChanged", object: notification.object)
    }
}
