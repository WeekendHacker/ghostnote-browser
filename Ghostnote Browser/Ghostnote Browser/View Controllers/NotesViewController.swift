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
    var noteTextViewController:NoteTextViewController = NoteTextViewController()
    @IBOutlet weak var splitView:CustomSplitView?
    
    @IBOutlet var noteTextView:NSTextView?
    
    @IBOutlet var notesTableView:DeletableTableView? { didSet {
            notesTableController.notesTableView = notesTableView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.autoresizingMask = [.ViewWidthSizable, .ViewHeightSizable]
        view.wantsLayer = true
        splitView?.dividerStyle = .Thin
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(selectedNoteChanged),
                                                         name: "SelectedNoteChanged",
                                                         object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(addNoteButtonClicked),
                                                         name: "AddNoteClicked",
                                                         object: nil)
        
        noteTextViewController.noteTextView = noteTextView
        noteTextView?.wantsLayer = true
        
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        sizeForContainer()
    }
    
    // Actions
    
    @IBAction func addNoteButtonClicked(sender:AnyObject?) {
        let date = NSDate()
        
        let uniquePart = "\(date.timeIntervalSince1970)"
        NoteManager.shared.createNoteWithName("New Note <!\(uniquePart)>")
        notesTableView?.reloadData()
    }
    

    // handlers
    
    func selectedNoteChanged(notif:NSNotification) {
        
        if notesTableView!.hasSelection() {
            if let row = notesTableView?.selectedRowIndexes.firstIndex where row != 0 {
                let view = notesTableView?.viewAtColumn(0, row: row, makeIfNecessary: false) as? NoteCell
                
                if let selectedNote = view?.note {
                    noteTextViewController.currentNote = selectedNote
                }
            }
        }else {
            noteTextViewController.currentNote = nil
        }
    }
}
