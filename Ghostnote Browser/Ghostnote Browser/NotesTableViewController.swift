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
    
    weak var notesTableView:NSTableView? {
        didSet {
            if let tv = notesTableView {
                tv.setDelegate(self)
                tv.setDataSource(self)
                tv.wantsLayer = true
                
                let buttonNib = NSNib(nibNamed: "ButtonTableCellView", bundle: nil)
                tv.registerNib(buttonNib, forIdentifier: "ButtonTableCellView")
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
            return view
        }
        
        
        let view = tableView.makeViewWithIdentifier("NoteCell", owner: nil) as? NoteCell
        
        view!.note = NoteManager.shared.notes[row - 1]
        return view
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        
        NSNotificationCenter.defaultCenter().postNotificationName("SelectedNoteChanged", object: notification.object)
    }
}
