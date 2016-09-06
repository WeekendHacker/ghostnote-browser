//
//  AppDelegate.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/17/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa
import RealmSwift
import Sparkle
import XCGLogger

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, SUUpdaterDelegate {

    let isBeta = true
    let log = XCGLogger(identifier: "AppDelegate", includeDefaultDestinations: true)
    let updater = SUUpdater(forBundle: NSBundle.mainBundle())
    
    @IBOutlet var newMenuItem:NSMenuItem?
    
    var currentControllerID = ""
    var windowController = MainWindowController(windowNibName: "MainWindowController")
    
    var buttonNavViewController:ButtonNavViewController?
    
    var realm:Realm? = nil
    
    var menuController:MainMenuController?
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
//        resetWelcomeCreationMarker()
        updater.delegate = self
               
        
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
        log.info("")
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        realm = try! Realm(configuration: config)
    }
    
    func showUI() {
        
        if let contentView = windowController.window?.contentView {
            buttonNavViewController = ButtonNavViewController(nibName: "ButtonNavViewController",
                                                              bundle: nil)
            
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
    
    
    @IBAction func checkForUpdates(sender:AnyObject) {
        updater.checkForUpdates(self)
    }
    
    // SUUpdaterDelegate
    
    func feedURLStringForUpdater(updater: SUUpdater!) -> String! {
        if isBeta {
            return "https://www.ghostnoteapp.com/updates/beta/GhostnoteBrowserAppcast.xml"
        }else {
            return "https://www.ghostnoteapp.com/updates/GhostnoteBrowserAppcast.xml"
        }
    }
    
    func updaterDidNotFindUpdate(updater: SUUpdater!) {
        log.warning("")
    }
    
    func updater(updater: SUUpdater!, didFinishLoadingAppcast appcast: SUAppcast!) {
        
        if let ac = appcast {
            XCGLogger.info("Fetched update info from \(updater!.feedURL)")

            if let items = ac.items as? Array<SUAppcastItem> {
                var output = ""
                
                XCGLogger.info("found \(items.count) versions.")
                for item in items {
                    output += "\n------------\n"
                    output += "pubDate: \(item.dateString)" + "\n"
                    output += "item description: \(item.itemDescription)" + "\n"
                    output += "update URL: \(item.fileURL)"
                    output += "\n------------\n"
                }
                log.info("retrieved \(output)")
            }
            
        }
        
    }
    
    func updater(updater: SUUpdater!, didAbortWithError error: NSError!) {
        log.error("\(error)")
    }
    
    func updater(updater: SUUpdater!, didFindValidUpdate item: SUAppcastItem!) {
        log.info("found valid update")
    }
    
    func updater(updater: SUUpdater!, failedToDownloadUpdate item: SUAppcastItem!, error: NSError!) {
        XCGLogger.error("\(error)")
    }
    
}

