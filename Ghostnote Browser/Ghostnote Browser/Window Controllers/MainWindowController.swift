//
//  MainWindowController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/18/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NotesOutlineControllerObserver {

    @IBOutlet weak var notesOutlineView:NSOutlineView?
    @IBOutlet var noteTextView:NSTextView?
    
    
    var notesOutlineController = NotesOutlineController()
    
    
    override func windowDidLoad() {
        super.windowDidLoad()

        notesOutlineController.observer = self
        notesOutlineController.notesOutlineView = self.notesOutlineView
        notesOutlineController.reload()
    }
    
    // NotesOutlineControllerObserver
    
    func selectedNote(note: GNNote) {
        noteTextView?.string = ""
        noteTextView?.textStorage?.appendAttributedString(note.content as! NSAttributedString)
    }

}
