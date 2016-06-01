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
    var newNoteController:NewNamedItemViewController?
    var noteTextViewController:NoteTextViewController = NoteTextViewController()
    
    @IBOutlet var noteTextView:NSTextView?
    
    @IBOutlet var notesTableView:NSTableView? { didSet {
            notesTableController.notesTableView = notesTableView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.autoresizingMask = [.ViewWidthSizable, .ViewHeightSizable]
        view.wantsLayer = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(selectedNoteChanged), name: "SelectedNoteChanged", object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(addNoteButtonClicked), name: "AddNoteClicked", object: nil)
        
        noteTextViewController.noteTextView = noteTextView
        noteTextView?.wantsLayer = true
        
        
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        sizeForContainer()
    }
    
    // Actions
    
    @IBAction func addNoteButtonClicked(sender:AnyObject?) {
        NoteManager.shared.createNoteWithName("New Note")
        notesTableView?.reloadData()
    }
    

    // handlers
    
    func selectedNoteChanged(notif:NSNotification) {
        
        if notesTableView!.hasSelection() {
            if let row = notesTableView?.selectedRowIndexes.firstIndex {
                let view = notesTableView?.viewAtColumn(0, row: row, makeIfNecessary: false) as? NoteCell
                
                if let selectedNote = view?.note {
                    print("selected \(selectedNote)")
                    noteTextViewController.currentNote = selectedNote
                }
            }
        }
    }
}
