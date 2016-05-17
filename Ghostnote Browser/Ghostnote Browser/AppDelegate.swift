//
//  AppDelegate.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/17/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa
import MagicalRecord

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    var windowController = MainWindowController(windowNibName: "MainWindowController")
    
    var buttonNavViewController:ButtonNavViewController?
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
//        GNCoreDataToRealmMigrator.shared.migrate(GhostNoteManager.shared)
        buttonNavViewController = ButtonNavViewController(nibName: "ButtonNavViewController", bundle: nil)
        windowController.window?.contentView = buttonNavViewController?.view
        windowController.showWindow(self);
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

