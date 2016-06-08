//
//  GhostnotesViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/19/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class GhostnotesViewController: NSViewController, ButtonNavigable,
                                GhostNotesAppTableViewControllerObserver, GhostNotesDocTableViewControllerObserver {

    var appsTableViewController = GhostNotesAppTableViewController()
    var docsTableViewController = GhostNotesDocTableViewController()
    var noteTextViewController = GhostNoteTextViewController()
    
    @IBOutlet var noteTextView:NSTextView? {
        didSet {
            if let tv = noteTextView {
                noteTextViewController.noteTextView = tv
                tv.wantsLayer = true
                tv.backgroundColor = NSColor.clearColor()
            }
        }
    }
    
    
    @IBOutlet weak var appsTableView:NSTableView? {
        didSet {
            if let tv = appsTableView {
                appsTableViewController.appsTableView = tv
                appsTableViewController.observer = self
                tv.wantsLayer = true
                tv.backgroundColor = NSColor.clearColor()
            }
        }
    }
    
    @IBOutlet weak var docsTableView:NSTableView? {
        didSet {
            if let tv = docsTableView {
                docsTableViewController.docsTableView = tv
                docsTableViewController.observer = self
                tv.wantsLayer = true
                tv.backgroundColor = NSColor.clearColor()
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

    // GhostNotesAppTableViewControllerObserver
    func selectedApp(app: App) {
        print("selected \(app)")
        noteTextViewController.currentNote = app.note
        docsTableViewController.currentApp = app
    }
    
    func selectedNothing() {
        print("selected no app")
    }
    
    // GhostNotesDocTableViewControllerObserver
    
    func selectedNote(note: GhostNote) {
        noteTextViewController.currentNote = note
    }
    
    func selectedNoNote() {
        print("selected no note")
        noteTextViewController.currentNote = nil
    }
}
