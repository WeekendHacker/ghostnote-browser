//
//  AppDelegate.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/17/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa
import RealmSwift

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var newMenuItem:NSMenuItem?
    var currentControllerID = ""
    var windowController = MainWindowController(windowNibName: "MainWindowController")
    
    var buttonNavViewController:ButtonNavViewController?
    
    var realm:Realm? = nil
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        configureRealm()
        registerForNotifications()
        showUI()
    }

    func configureRealm() {
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        realm = try! Realm(configuration: config)
    }
    
    func showUI() {
        buttonNavViewController = ButtonNavViewController(nibName: "ButtonNavViewController", bundle: nil)
        windowController.window?.contentView = buttonNavViewController?.view
        windowController.showWindow(self);
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
        if currentControllerID == "tasks" {
            NSNotificationCenter.defaultCenter().postNotificationName("NewTaskAction", object: nil)
        }
    }
    
    // notifcation handlers
    
    func handleTaskListChanged(notification:NSNotification) {
        print(notification.object)
        if notification.object != nil {
            newMenuItem?.title = "New Task"
            enableNewMenuItem()
        }else {
            disableNewMenuItem()
        }
    }
    
    func handleControllerChanged(notification:NSNotification) {
        print(notification)
        
        if let controllerID = notification.object as? String {
            currentControllerID = controllerID
            if controllerID == "notes" {
                newMenuItem?.title = "New Note"
                newMenuItem?.keyEquivalent = "n"
                enableNewMenuItem()
            }else if controllerID == "tasks" {
                if buttonNavViewController?.tasksController.taskListController.currentTaskList != nil {
                    newMenuItem?.title = "New Task"
                    newMenuItem?.keyEquivalent = "t"
                    enableNewMenuItem()
                }else {
                    disableNewMenuItem()
                }
            }else {
                disableNewMenuItem()
            }
        }
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

