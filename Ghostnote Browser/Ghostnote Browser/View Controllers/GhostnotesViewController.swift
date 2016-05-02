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
    
    @IBOutlet var noteTextView:NSTextView?
    
    @IBOutlet var notesOutlineView:NSOutlineView? { didSet {
            if let ov = notesOutlineView {
                notesOutlineController.notesOutlineView = ov
                notesOutlineController.observer = self
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
//        noteTextView?.usesInspectorBar = false
    }
    
    // GhostnotesOutlineControllerObserver
    func selectedNote(note: GNNote) {
        if let themeName = note.themeName {
            if let theme = GNTheme.themesByName[themeName] {
                noteTextView?.backgroundColor = theme.backgroundColor
            }
        }else {
            noteTextView?.backgroundColor = NSColor.whiteColor()
        }
        
        noteTextView?.textStorage?.mutableString.setString("")
        noteTextView?.textStorage?.appendAttributedString(note.content as! NSAttributedString)
    }
}
