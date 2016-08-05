//
//  ButtonNavViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/24/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

protocol ButtonNavigable {
    var view:NSView {get}
    func isActive() -> Bool
    func deactivate() -> Void
}

extension  ButtonNavigable {
    
    func isActive() -> Bool {
        return !(view.superview == nil)
    }
    
    func deactivate() {
         view.removeFromSuperview()
    }
}

class ButtonNavViewController: NSViewController {

    @IBOutlet weak var searchField:NSSearchField?     
    @IBOutlet weak var contentView:NSView?
    @IBOutlet weak var navView:NSView?
    
    @IBOutlet weak var notesButton:NSButton?
    @IBOutlet weak var tasksButton:NSButton?
    @IBOutlet weak var ghostnotesButton:NSButton?
    
    var notesController = NotesViewController()
    var tasksController = TasksViewController()
    var ghostnotesController = GhostnotesViewController()
    
    var currentController:NSViewController? {
        didSet {

            if let current = currentController {
                if let title = current.title {
                   
                    if #available(OSX 10.10, *) {
                        searchField?.placeholderString = "Search \(title)"
                    } else {
                        if let cell = searchField?.cell as? NSTextFieldCell {
                            cell.placeholderString = ""
                        }
                    }
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("ControllerChanged", object: title)

                }
            }

        }
    }
    
    func clearSearchField() {
        searchField?.resignFirstResponder()
    }
//    func searchMenuForNotes() -> NSMenu {
//        let notesMenu = NSMenu()
//        let noteTitleItem = NSMenuItem(title: "Title", action: nil, keyEquivalent: "")
//        
//        let noteTextItem = NSMenuItem(title: "Text", action: nil, keyEquivalent: "")
//        
//        notesMenu.addItem(noteTitleItem)
//        notesMenu.addItem(noteTextItem)
//        
//        return notesMenu
//    }
//    
//    func searchMenuForTasks() -> NSMenu {
//        
//        let tasksMenu = NSMenu()
//        let taskListItem = NSMenuItem(title: "List", action: nil, keyEquivalent: "")
//        let taskItem = NSMenuItem(title: "Task", action: nil, keyEquivalent: "")
//        tasksMenu.addItem(taskListItem)
//        tasksMenu.addItem(taskItem)
//        return tasksMenu
//    }
//    
//    func searchMenuForGhostnotes() -> NSMenu {
//        let ghostnotesMenu = NSMenu()
//        let appItem = NSMenuItem(title: "App", action: nil, keyEquivalent: "")
//        let docItem = NSMenuItem(title: "Document", action: nil, keyEquivalent: "")
//        let ghostnoteTextItem = NSMenuItem(title: "Text", action: nil, keyEquivalent: "")
//        ghostnotesMenu.addItem(appItem)
//        ghostnotesMenu.addItem(docItem)
//        ghostnotesMenu.addItem(ghostnoteTextItem)
//        return ghostnotesMenu
//    }
    
    override func viewDidLoad() {
        if #available(OSX 10.10, *) {
            super.viewDidLoad()
        } else {
            // Fallback on earlier versions
        }

        notesButton?.wantsLayer = true
        tasksButton?.wantsLayer = true
        ghostnotesButton?.wantsLayer = true
        
        notesButton?.layer?.backgroundColor = NSColor.clearColor().CGColor
        tasksButton?.layer?.backgroundColor = NSColor.clearColor().CGColor
        ghostnotesButton?.layer?.backgroundColor = NSColor.clearColor().CGColor

        let selectedTab = NSUserDefaults.standardUserDefaults().integerForKey("selectedTab")
        
        if selectedTab == 0 {
            notesButtonClicked(self)
        }else if selectedTab == 1 {
            tasksButtonClicked(self)
        }else if selectedTab == 2 {
            ghostnotesButtonClicked(self)
        }else {
            notesButtonClicked(self)
        }
        
        updateNavButtonState()
        view.subviews.forEach { (view) in
            view.wantsLayer  = true
        }
    }
    
    // Actions
    
    @IBAction func searchFieldGotText(sender:AnyObject?) {
        
        if let sf = sender as? NSSearchField {
            if currentController == notesController {
                
                NoteManager.shared.searchController.isSearching = !sf.stringValue.isEmpty
                NoteManager.shared.searchController.searchText = sf.stringValue
                
                notesController.notesTableView?.reloadData()
                notesController.noteTextViewController.currentNote = nil
                
            }else if currentController == tasksController  {
                
                TaskListManager.shared.searchController.isSearching = !sf.stringValue.isEmpty
                TaskListManager.shared.searchController.searchText = sf.stringValue
                
                tasksController.selectedNoList()
                tasksController.taskListTableView?.reloadData()
                
            }else if currentController == ghostnotesController {
                
                GhostNoteManager.shared.searchController.isSearching = !sf.stringValue.isEmpty
                GhostNoteManager.shared.searchController.searchText = sf.stringValue
                
                ghostnotesController.appsTableViewController.reload()
                ghostnotesController.docsTableViewController.reload()
            }
        }
    }
    
    @IBAction func notesButtonClicked(sender:AnyObject?) {
        
        tasksController.deactivate()
        ghostnotesController.deactivate()
        
        if !notesController.isActive() {
            contentView?.addSubview(notesController.view)
        }
        
        currentController = notesController
        
        updateNavButtonState()
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "selectedTab")
    }
    
    @IBAction func tasksButtonClicked(sender:AnyObject?) {
        
        notesController.deactivate()
        ghostnotesController.deactivate()
        
        if !tasksController.isActive() {
            contentView?.addSubview(tasksController.view)
        }
        currentController = tasksController
        updateNavButtonState()
        NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "selectedTab")

    }
    
    @IBAction func ghostnotesButtonClicked(sender:AnyObject?) {
        
        notesController.deactivate()
        tasksController.deactivate()
        
        if !ghostnotesController.isActive() {
            contentView?.addSubview(ghostnotesController.view)
        }
        currentController = ghostnotesController
        updateNavButtonState()
        NSUserDefaults.standardUserDefaults().setInteger(2, forKey: "selectedTab")

    }

    func updateNavButtonState() {
        
        if notesController.isActive() {
            notesButton?.image = NSImage(imageLiteral: "Notes-Active")
        }else {
            notesButton?.image = NSImage(imageLiteral: "Notes-Inactive")
        }
        
        if tasksController.isActive() {
            tasksButton?.image =  NSImage(imageLiteral: "Tasks-Active")
        }else {
            tasksButton?.image =  NSImage(imageLiteral: "Tasks-Inactive")
        }
        
        if ghostnotesController.isActive() {
            ghostnotesButton?.image =  NSImage(imageLiteral: "Ghostnotes-Active")

        }else {
            ghostnotesButton?.image =  NSImage(imageLiteral: "Ghostnotes-Inactive")
        }
    }
}
