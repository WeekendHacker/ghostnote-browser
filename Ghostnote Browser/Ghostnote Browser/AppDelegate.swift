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


    var windowController = MainWindowController(windowNibName: "MainWindowController")
    
    var buttonNavViewController:ButtonNavViewController?
    var realm:Realm? = nil
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        realm = try! Realm(configuration: config)
        
        buttonNavViewController = ButtonNavViewController(nibName: "ButtonNavViewController", bundle: nil)
        windowController.window?.contentView = buttonNavViewController?.view
        windowController.showWindow(self);
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

