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
    
    var menuController:MainMenuController?
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        resetWelcomeCreationMarker()
        
        
        if !NSUserDefaults.standardUserDefaults().boolForKey("hasCreatedWelcomeNote") {
            NoteManager.shared.copyWelcomeNoteFile()
        }
        
        if !NSUserDefaults.standardUserDefaults().boolForKey("hasCreatedWelcomeTasks") {
            TaskListManager.shared.createWelcomeTaskList()
        }
        
        configureRealm()
        menuController = MainMenuController(menuItem: newMenuItem)
        showUI()
    }
    
    func resetWelcomeCreationMarker() {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "hasCreatedWelcomeNote")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "hasCreatedWelcomeTasks")
    }
    
    func configureRealm() {
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        realm = try! Realm(configuration: config)
    }
    
    func showUI() {
        
        if let contentView = windowController.window?.contentView {
            buttonNavViewController = ButtonNavViewController(nibName: "ButtonNavViewController", bundle: nil)
            
            if let navConView = buttonNavViewController?.view {
                contentView.addSubview(navConView)
                
                let top = NSLayoutConstraint(item: navConView,
                                             attribute: .Top,
                                             relatedBy: .Equal,
                                             toItem: contentView,
                                             attribute: .Top,
                                             multiplier: 1.0,
                                             constant: 0.0)
                
                let left =  NSLayoutConstraint(item: navConView,
                                               attribute: .Left,
                                               relatedBy: .Equal,
                                               toItem: contentView,
                                               attribute: .Left,
                                               multiplier: 1.0,
                                               constant: 0.0)
                
                let right =  NSLayoutConstraint(item: navConView,
                                                attribute: .Right,
                                                relatedBy: .Equal,
                                                toItem: contentView,
                                                attribute: .Right,
                                                multiplier: 1.0,
                                                constant: 0.0)
                
                let bottom =  NSLayoutConstraint(item: navConView,
                                                 attribute: .Bottom,
                                                 relatedBy: .Equal,
                                                 toItem: contentView,
                                                 attribute: .Bottom,
                                                 multiplier: 1.0,
                                                 constant: 0.0)
                
                contentView.addConstraints([top, left, bottom, right])
                contentView.wantsLayer = true
                contentView.updateConstraints()
                contentView.layer?.backgroundColor = NSColor.greenColor().CGColor
            }
            
        }

        
        windowController.showWindow(self);
    }
}

