//
//  MainWindowController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/18/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    @IBOutlet weak var notesOutlineView:NSOutlineView?
    @IBOutlet var noteTextView:NSTextView?
    
    
    var notesOutlineController = NotesOutlineController()
    
    
    override func windowDidLoad() {
        super.windowDidLoad()
        notesOutlineController.notesOutlineView = self.notesOutlineView
        notesOutlineController.reload()
    }
    
}
