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
    
    func sizeForContainer() {
        if let contentFrame = view.superview?.frame {
            let newFrame = NSRect(origin: CGPoint(x: 0,y: 0), size: contentFrame.size)
            view.frame = newFrame
        }
    }
}

class ButtonNavViewController: NSViewController {

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
            var id = ""
            if currentController == notesController {
                id = "notes"
            }else if currentController == tasksController {
                id = "tasks"
            }else if currentController == ghostnotesController {
                id = "ghostnotes"
            }
            NSNotificationCenter.defaultCenter().postNotificationName("ControllerChanged", object: id)

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        updateNaveButtonState()
        view.subviews.forEach { (view) in
            view.wantsLayer  = true
        }
    }
    
    @IBAction func notesButtonClicked(sender:AnyObject?) {
        
        tasksController.deactivate()
        ghostnotesController.deactivate()
        
        if !notesController.isActive() {
            contentView?.addSubview(notesController.view)
        }
        currentController = notesController
        
        updateNaveButtonState()
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "selectedTab")
    }
    
    @IBAction func tasksButtonClicked(sender:AnyObject?) {
        
        notesController.deactivate()
        ghostnotesController.deactivate()
        
        if !tasksController.isActive() {
            contentView?.addSubview(tasksController.view)
        }
        currentController = tasksController
        updateNaveButtonState()
        NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "selectedTab")

    }
    
    @IBAction func ghostnotesButtonClicked(sender:AnyObject?) {
        
        notesController.deactivate()
        tasksController.deactivate()
        
        if !ghostnotesController.isActive() {
            contentView?.addSubview(ghostnotesController.view)
        }
        currentController = ghostnotesController
        updateNaveButtonState()
        NSUserDefaults.standardUserDefaults().setInteger(2, forKey: "selectedTab")

    }

    func updateNaveButtonState() {
        
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
