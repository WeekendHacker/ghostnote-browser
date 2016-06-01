//
//  NotesViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/19/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class NotesViewController: NSViewController, ButtonNavigable, NewNamedItemViewControllerClient {

    var notesTableController = NotesTableViewController()
    var newNoteController:NewNamedItemViewController?
    var noteTextViewController:NoteTextViewController = NoteTextViewController()
    
    @IBOutlet var noteTextView:NSTextView?
    
    @IBOutlet var notesTableView:NSTableView? { didSet {
            notesTableController.notesTableView = notesTableView
        }
    }
    
    @IBOutlet weak var addNoteButton:NSButton? {
        didSet {
            addNoteButton?.wantsLayer = true
        }
    }
    @IBOutlet weak var deleteNoteButton:NSButton? {
        didSet {
            deleteNoteButton?.wantsLayer = true
        }
    }
    @IBOutlet weak var searchField:NSSearchField? {
        didSet {
            searchField?.wantsLayer = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.autoresizingMask = [.ViewWidthSizable, .ViewHeightSizable]
        view.wantsLayer = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(selectedNoteChanged), name: "SelectedNoteChanged", object: nil)
        
        deleteNoteButton?.enabled = false
        noteTextViewController.noteTextView = noteTextView
        noteTextView?.wantsLayer = true
        
        
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        sizeForContainer()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
    }
    
    // Actions
    
    @IBAction func addNoteButtonClicked(sender:AnyObject?) {
        
        newNoteController = NewNamedItemViewController(nibName: nil, bundle: nil)
        newNoteController?.client = self
        newNoteController?.validator = NoteNameValidator.shared
        newNoteController?.nameTextField?.placeholderString = "New Note Name"
        
        self.presentViewController(newNoteController!, asPopoverRelativeToRect: addNoteButton!.frame, ofView: addNoteButton!, preferredEdge: NSRectEdge.MaxX, behavior: NSPopoverBehavior.Transient)
        
    }
    
    @IBAction func deleteNoteButtonClicked(sender:AnyObject?) {
        
        if notesTableView!.hasSelection() {
            for index in notesTableView!.selectedRowIndexes {
                if let view = notesTableView?.viewAtColumn(0, row: index, makeIfNecessary: false) as? NoteCell {
                    NoteManager.shared.deleteNote(view.note!)
                    notesTableView?.reloadData()
                    deleteNoteButton?.enabled = false
                }
            }
        }
        
    }
    
    // NewNoteWindowControllerClient
    
    func choseName(name: String) {
        print(name)
        
        NoteManager.shared.createNoteWithName(name)
        dismissViewController(newNoteController!)
        newNoteController = nil
        notesTableView?.reloadData()
    }
    
    func canceled() {
        
        if let vc = newNoteController {
            dismissViewController(vc)
            newNoteController = nil
        }
        
    }
    
    // handlers
    
    func selectedNoteChanged(notif:NSNotification) {
        
        if notesTableView!.hasSelection() {
            deleteNoteButton?.enabled = true
            if let row = notesTableView?.selectedRowIndexes.firstIndex {
                let view = notesTableView?.viewAtColumn(0, row: row, makeIfNecessary: false) as? NoteCell
                
                if let selectedNote = view?.note {
                    print("selected \(selectedNote)")
                    noteTextViewController.currentNote = selectedNote
                }
            }
        }else {
            deleteNoteButton?.enabled = false
        }
    }
}
