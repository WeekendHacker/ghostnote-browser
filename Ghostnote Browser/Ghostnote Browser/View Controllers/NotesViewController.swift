//
//  NotesViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/19/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class NotesViewController: NSViewController, ButtonNavigable {

    var notesTableController = NotesTableViewController()
    
    @IBOutlet var noteTextView:NSTextView?
    
    @IBOutlet var notesTableView:NSTableView? { didSet {
            if let tv = notesTableView {
                tv.setDelegate(notesTableController)
                tv.setDataSource(notesTableController)
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
        noteTextView?.usesInspectorBar = true
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        noteTextView?.usesInspectorBar = false
    }
    
    // Actions
    
    @IBAction func addNoteButtonClicked(sender:AnyObject?) {
        
    }
    
    @IBAction func delteNoteButtonClicked(sender:AnyObject) {
        
    }
    
}
