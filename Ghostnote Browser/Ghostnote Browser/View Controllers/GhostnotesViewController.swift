//
//  GhostnotesViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/19/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class GhostnotesViewController: NSViewController, ButtonNavigable, GhostnotesOutlineControllerObserver {

    var notesOutlineController = GhostnotesOutlineController()
    var noteTextViewController = GhostNoteTextViewController()
    
    @IBOutlet var noteTextView:NSTextView? {
        didSet {
            if let tv = noteTextView {
                noteTextViewController.noteTextView = tv
            }
        }
    }
    
    @IBOutlet var notesOutlineView:NSOutlineView? { didSet {
            if let ov = notesOutlineView {
                notesOutlineController.notesOutlineView = ov
                notesOutlineController.observer = self
                ov.wantsLayer = true
            }
        }
    }
    
    @IBOutlet weak var addNoteButton:NSButton?
    @IBOutlet weak var deleteNoteButton:NSButton?
    @IBOutlet weak var searchField:NSSearchField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.autoresizingMask = [.ViewWidthSizable, .ViewHeightSizable]
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        sizeForContainer()
        notesOutlineController.reload()
        noteTextView?.usesInspectorBar = true
        
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        noteTextView?.usesInspectorBar = false
    }
    
    // GhostnotesOutlineControllerObserver
    func selectedNote(note: GhostNote) {
        if let theme = GNTheme.themesByName[note.themeName] {
            noteTextView?.backgroundColor = theme.backgroundColor
        }
        else {
            noteTextView?.backgroundColor = NSColor.whiteColor()
        }
        
        noteTextViewController.currentNote = note
        
    }
}
