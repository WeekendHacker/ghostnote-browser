//
//  GhostnotesViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/19/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class GhostnotesViewController: NSViewController, ButtonNavigable,
                                GhostNotesAppTableViewControllerObserver, GhostNotesDocTableViewControllerObserver, InterTableKeyboardNavigationDelegate {

    var appsTableViewController = GhostNotesAppTableViewController()
    var docsTableViewController = GhostNotesDocTableViewController()
    var noteTextViewController = GhostNoteTextViewController()
    
    @IBOutlet weak var splitView:CustomSplitView?
    
    
    @IBOutlet weak var boldButton:NSButton? {
        didSet {
            noteTextViewController.boldButton = boldButton
        }
    }
    
    @IBOutlet weak var italicButton:NSButton? {
        didSet {
            noteTextViewController.italicButton = italicButton
        }
    }
    
    @IBOutlet weak var bulletListButton:NSButton? {
        didSet {
            noteTextViewController.bulletListButton = bulletListButton
        }
    }
    
    @IBOutlet weak var numberedListButton:NSButton? {
        didSet {
            noteTextViewController.numberedListButton = numberedListButton
        }
    }
    
    @IBOutlet weak var todoListButton:NSButton? {
        didSet {
            noteTextViewController.todoListButton = todoListButton
        }
    }
    
    @IBOutlet var noteTextView:CustomTextView? {
        didSet {
            if let tv = noteTextView {
                noteTextViewController.noteTextView = tv
                tv.wantsLayer = true
                tv.backgroundColor = NSColor.clearColor()
            
            }
        }
    }
    
    @IBOutlet weak var noteTitleLabel:NSTextField? {
        didSet {
            noteTitleLabel?.stringValue = ""
            noteTextViewController.noteTitleLabel = noteTitleLabel
        }
    }
    
    @IBOutlet weak var noteIconImageView:NSImageView? {
        didSet {
            noteTextViewController.noteIconImageView = noteIconImageView
        }
    }
    
    @IBOutlet weak var appsTableView:DeletableTableView? {
        didSet {
            if let tv = appsTableView {
                appsTableViewController.appsTableView = tv
                appsTableViewController.observer = self
                tv.wantsLayer = true
                tv.keyboardDelegate = self
            }
        }
    }
    
    @IBOutlet weak var docsTableView:DeletableTableView? {
        didSet {
            if let tv = docsTableView {
                docsTableViewController.docsTableView = tv
                docsTableViewController.observer = self
                tv.wantsLayer = true
                tv.keyboardDelegate = self
            }
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ghostnotes"
        splitView?.dividerStyle = .Thin
        noteTextViewController.disableUI()
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        appsTableViewController.reload()
        moveDidvdersToDefaultPosition()
        selectFirstApp()
    }

    
    func moveDidvdersToDefaultPosition() {
        splitView?.setPosition(160.0, ofDividerAtIndex: 0)
        splitView?.setPosition(320.0, ofDividerAtIndex: 1)
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
    
    
    // Selection automation 
    
    func selectFirstApp() {
        
        if GhostNoteManager.shared.allAppBundleIDs().count > 0 {
            appsTableView?.selectRowIndexes(NSIndexSet(index:0), byExtendingSelection: false)
            appsTableView?.window?.makeFirstResponder(appsTableView)
        }
    }
    
    func selectFirstDoc() {
        docsTableView?.selectRowIndexes(NSIndexSet(index:0), byExtendingSelection: false)
        docsTableView?.window?.makeFirstResponder(docsTableView)
    }
    
    // GhostNotesAppTableViewControllerObserver
    func selectedApp(app: App) {
        noteTextViewController.currentNote = app.note
        docsTableViewController.currentApp = app
    }
    
    func selectedNothing() {
        noteTextViewController.currentNote = nil
        docsTableViewController.currentApp = nil
    }
    
    // GhostNotesDocTableViewControllerObserver
    
    func selectedNote(note: GhostNote) {
        noteTextViewController.currentNote = note
    }
    
    func selectedNoNote() {
        noteTextViewController.currentNote = nil
    }
    
    // InterTableKeyboardNavigationDelegate
    
    func leftArrow() {
        if appsTableViewController.apps.count > 0 {

            if let row = appsTableView?.selectedRow where row >= 0 {
                appsTableView?.selectRowIndexes(NSIndexSet(index:row), byExtendingSelection: false)
                appsTableView?.window?.makeFirstResponder(appsTableView)
                let notif = NSNotification(name: "NSTableViewSelectionDidChangeNotification",
                                           object: appsTableView!)
                NSNotificationCenter.defaultCenter().postNotification(notif)
            }
        }
    }
    
    func rightArrow() {
        if docsTableViewController.ghostnotes.count > 0 {
            selectFirstDoc()
        }
    }
    
    // IBACtions
    
    @IBAction func boldClicked(sender:AnyObject?) {
        noteTextViewController.boldClicked(self)
    }
    
    @IBAction func italicClicked(sender:AnyObject?) {
        noteTextViewController.italicClicked(self)
    }
    
    @IBAction func bulletListClicked(sender:AnyObject?) {
        noteTextViewController.bulletListClicked(self)
    }
    
    @IBAction func numberedListClicked(sender:AnyObject?) {
        noteTextViewController.numberedListClicked(self)
    }
    
    @IBAction func todoListClicked(sender:AnyObject?) {
        noteTextViewController.todoListClicked(self)
    }
    
}
