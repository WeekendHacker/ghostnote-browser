//
//  MainMenuController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 6/20/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class MainMenuController: NSObject {

    @IBOutlet weak var newMenuItem:NSMenuItem?
    var currentControllerID  = ""
    var currentTaskList:TaskList? = nil
    
    init(menuItem:NSMenuItem?) {
        super.init()
        self.newMenuItem = menuItem
        newMenuItem?.target = self
        newMenuItem?.keyEquivalent = "n"
        newMenuItem?.action = #selector(newItem(_:))
        
        registerForNotifications()
    }
    
    func registerForNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleControllerChanged(_:)),
                                                         name: "ControllerChanged",
                                                         object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleTaskListChanged(_:)),
                                                         name: "CurrentTaskListChanged",
                                                         object: nil)
    }
    
    // menu
    @IBAction func newItem(sender:AnyObject?) {
        if currentControllerID == "Tasks" {
            NSNotificationCenter.defaultCenter().postNotificationName("NewTaskAction", object: nil)
        }else if currentControllerID == "Notes" {
            NSNotificationCenter.defaultCenter().postNotificationName("NewNoteAction", object: nil)
        }
    }
    
    // notifcation handlers
    
    func handleTaskListChanged(notification:NSNotification) {
        currentTaskList = notification.object as? TaskList
        
        if currentTaskList != nil {
            enableNewMenuItem()
        }else {
            disableNewMenuItem()
        }
    }
    
    func handleControllerChanged(notification:NSNotification) {
        
        if let controllerID = notification.object as? String {
            currentControllerID = controllerID
            if controllerID == "Notes" {
                configureNewMenuItemForNotes()
                enableNewMenuItem()
            }else if controllerID == "Tasks" {
                if currentTaskList != nil {
                    configureNewMenuItemForTasks()
                    enableNewMenuItem()
                }else {
                    disableNewMenuItem()
                }
            }else {
                disableNewMenuItem()
            }
        }
    }
    
    func configureNewMenuItemForTasks() {
        newMenuItem?.title = "New Task"
    }
    
    func configureNewMenuItemForNotes() {
        newMenuItem?.title = "New Note"
    }
    
    func enableNewMenuItem() {
        newMenuItem?.enabled = true
        newMenuItem?.hidden = false
    }
    
    func disableNewMenuItem() {
        newMenuItem?.enabled = false
        newMenuItem?.hidden = true
    }

}
