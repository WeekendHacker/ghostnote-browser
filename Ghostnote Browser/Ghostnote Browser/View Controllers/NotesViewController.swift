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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(selectedNoteChanged), name: "SelectedNoteChanged", object: nil)
        
        deleteNoteButton?.enabled = false
        noteTextViewController.noteTextView = noteTextView
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
        
        newNoteController = NewNamedItemViewController(nibName: nil, bundle: nil)
        newNoteController?.client = self
        newNoteController?.validator = NoteNameValidator.shared
        newNoteController?.nameTextField?.placeholderString = "New Note Name"
        
        self.presentViewController(newNoteController!, asPopoverRelativeToRect: addNoteButton!.frame, ofView: addNoteButton!, preferredEdge: NSRectEdge.MaxX, behavior: NSPopoverBehavior.Transient)
        
    }
    
    @IBAction func deleteNoteButtonClicked(sender:AnyObject?) {
        
        // need to make this use the extension
        // and handle multiple selection deletes i think

        if notesTableView!.hasSelection() {
            for index in notesTableView!.selectedRowIndexes {
                if let view = notesTableView?.viewAtColumn(0, row: index, makeIfNecessary: false) as? NoteCell {
                    NoteManager.shared.deleteNote(view.note!)
                }
            }
        }
        
        notesTableView?.reloadData()
        deleteNoteButton?.enabled = false
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
        }
    }
}
