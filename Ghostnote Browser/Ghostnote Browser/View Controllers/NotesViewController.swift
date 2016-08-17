//
//  NotesViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/19/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa
import SwiftyBeaver

class NotesViewController: NSViewController, ButtonNavigable, NSSplitViewDelegate {

    let log = SwiftyBeaver.self
    
    var notesTableController = NotesTableViewController()
    var noteTextViewController:NoteTextViewController = NoteTextViewController()
    
    @IBOutlet weak var addNoteButton:NSButton? {
        didSet {
            addNoteButton?.toolTip = "Add Note - command-n"
        }
    }
    
    @IBOutlet weak var splitView:CustomSplitView?
    
    @IBOutlet var noteTextView:NSTextView?
    
    @IBOutlet var notesTableView:DeletableTableView? { didSet {
            notesTableController.notesTableView = notesTableView
        }
    }
    
    @IBOutlet weak var textViewPlaceholderLabel:NSTextField? {
        didSet {
            noteTextViewController.placeholderLabel = textViewPlaceholderLabel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let console = ConsoleDestination()  // log to Xcode Console
        let file = FileDestination()  // log to default swiftybeaver.log file
        log.addDestination(console)
        log.addDestination(file)
        
        title = "Notes"
        
        view.wantsLayer = true
        splitView?.dividerStyle = .Thin
        
        registerForNotifications()
        
        noteTextViewController.noteTextView = noteTextView
        noteTextView?.wantsLayer = true
        
        
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        splitView?.setPosition(160.0, ofDividerAtIndex: 0)
        selectFirstNote()
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        if let superView = view.superview {
            let top = NSLayoutConstraint(item: view,
                                         attribute: .Top,
                                         relatedBy: .Equal,
                                         toItem: superView,
                                         attribute: .Top,
                                         multiplier: 1.0,
                                         constant: 0.0)
            
            let left =  NSLayoutConstraint(item: view,
                                           attribute: .Left,
                                           relatedBy: .Equal,
                                           toItem: superView,
                                           attribute: .Left,
                                           multiplier: 1.0,
                                           constant: 0.0)
            
            let right =  NSLayoutConstraint(item: view,
                                            attribute: .Right,
                                            relatedBy: .Equal,
                                            toItem: superView,
                                            attribute: .Right,
                                            multiplier: 1.0,
                                            constant: 0.0)
            
            let bottom =  NSLayoutConstraint(item: view,
                                             attribute: .Bottom,
                                             relatedBy: .Equal,
                                             toItem: superView,
                                             attribute: .Bottom,
                                             multiplier: 1.0,
                                             constant: 0.0)
            
            superView.addConstraints([top, left, bottom, right])
            superView.layoutSubtreeIfNeeded()
        }
    }
    
    
    // foo
    func selectFirstNote() {
        if NoteManager.shared.notes.count > 0 {
            notesTableView?.selectRowIndexes(NSIndexSet(index: 0), byExtendingSelection: false)
            self.view.window?.makeFirstResponder(noteTextView)
        }
    }
    
    // NSSplitViewDelegate
    
    func splitView(splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        return 160.0
    }
    
    func splitView(splitView: NSSplitView, constrainMaxCoordinate proposedMaximumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        return 320.0
    }
    
    // IBActions
    
    @IBAction func addNoteButtonClicked(sender:AnyObject?) {
        let date = NSDate()
        
        let uniquePart = "\(date.timeIntervalSince1970)"
        let suffix = NoteManager.shared.newNoteNameSuffix()
        
        NoteManager.shared.createNoteWithName("New Note \(suffix) <!\(uniquePart)>")
        notesTableView?.reloadData()
    }

    // Setup
    func registerForNotifications() {
        
        let notifcationCenter = NSNotificationCenter.defaultCenter()
            notifcationCenter.addObserver(self,
                                         selector: #selector(selectedNoteChanged),
                                         name: "SelectedNoteChanged",
                                         object: nil)
        
            notifcationCenter.addObserver(self,
                                          selector: #selector(addNoteButtonClicked),
                                          name: "NewNoteAction",
                                          object: nil)
        
            notifcationCenter.addObserver(self,
                                          selector: #selector(handleDeleteNoteRequest(_:)),
                                          name: "DeleteNoteRequest",
                                          object: nil)

    }
    
    // handlers
    func selectedNoteChanged(notif:NSNotification) {
        if notesTableView!.hasSelection() {
            if let row = notesTableView?.selectedRow {
                let view = notesTableView?.viewAtColumn(0, row: row, makeIfNecessary: false) as? NoteCell
                
                if let selectedNote = view?.note {
                    noteTextViewController.currentNote = selectedNote
                }
            }
        }else {
            noteTextViewController.currentNote = nil
        }
    }
    
    func handleDeleteNoteRequest(notif:NSNotification) {

        if let payload = notif.object as? Dictionary<String,AnyObject> {
            
            if let noteToDelete = payload["noteToDelete"] as? Note {
                if let hostingNoteCell = payload["hostingNoteCell"] as? NoteCell {
                    
                   if let deleteVC = ConfirmDeleteViewController(nibName: "ConfirmDeleteViewController",
                                                                 bundle: NSBundle.mainBundle()) {
                    
                        deleteVC.promptText = "Delete \"\(noteToDelete.name.withoutUniquePart())\" ?"
                        deleteVC.yesBlock = {
                            NoteManager.shared.deleteNote(noteToDelete)
                            self.dismissViewController(deleteVC)
                        }
                        
                        deleteVC.noBlock = {
                            self.dismissViewController(deleteVC)
                        }
                        
                        presentViewController(deleteVC,
                                              asPopoverRelativeToRect: hostingNoteCell.bounds,
                                              ofView: hostingNoteCell,
                                              preferredEdge: .MaxX,
                                              behavior: .Transient)

                    
                    }
                    
                }
            }
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
