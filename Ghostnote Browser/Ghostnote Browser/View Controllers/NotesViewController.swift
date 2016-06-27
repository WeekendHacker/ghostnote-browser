//
//  NotesViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/19/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class NotesViewController: NSViewController, ButtonNavigable, NSSplitViewDelegate {

    var notesTableController = NotesTableViewController()
    var noteTextViewController:NoteTextViewController = NoteTextViewController()
    
    @IBOutlet weak var addNoteButton:NSButton? {
        didSet {
            
            let color = NSColor(netHex:0x3C75B8)
            let title = NSAttributedString(string: "Add Note",
                                           attributes: [NSFontSizeAttribute : 15.0,
                                                        NSForegroundColorAttributeName : color])
            
            addNoteButton?.attributedTitle = title
        }
    }
    @IBOutlet weak var splitView:CustomSplitView?
    
    @IBOutlet var noteTextView:NSTextView?
    
    @IBOutlet var notesTableView:DeletableTableView? { didSet {
            notesTableController.notesTableView = notesTableView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        NoteManager.shared.createNoteWithName("New Note <!\(uniquePart)>")
        notesTableView?.reloadData()
    }
    

    // Setup
    func registerForNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(selectedNoteChanged),
                                                         name: "SelectedNoteChanged",
                                                         object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(addNoteButtonClicked),
                                                         name: "NewNoteAction",
                                                         object: nil)

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
