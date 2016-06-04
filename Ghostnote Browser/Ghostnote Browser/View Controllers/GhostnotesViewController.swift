//
//  GhostnotesViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/19/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class GhostnotesViewController: NSViewController, ButtonNavigable {

    var appsTableViewController = GhostNotesAppTableViewController()
    var docsTableViewController = GhostNotesDocTableViewController()
    var noteTextViewController = GhostNoteTextViewController()
    
    @IBOutlet var noteTextView:NSTextView? {
        didSet {
            if let tv = noteTextView {
                noteTextViewController.noteTextView = tv
            }
        }
    }
    
    
    @IBOutlet weak var appsTableView:NSTableView? {
        didSet {
            if let tv = appsTableView {
                appsTableViewController.appsTableView = tv
                tv.wantsLayer = true
            }
        }
    }
    
    @IBOutlet weak var docsTableView:NSTableView? {
        didSet {
            if let tv = docsTableView {
                docsTableViewController.docsTableView = tv
                tv.wantsLayer = true
            }
        }
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        view.autoresizingMask = [.ViewWidthSizable, .ViewHeightSizable]
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        sizeForContainer()
        appsTableViewController.reload()
        
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
    }
    
    // GhostnotesOutlineControllerObserver
    func selectedNote(note: GhostNote) {

        noteTextViewController.currentNote = note
        
    }
    
    func selectedNothing() {
        noteTextViewController.currentNote = nil;
        
    }
}
