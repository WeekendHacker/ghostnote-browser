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

    var mainWindowController:MainWindowController?
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        mainWindowController = MainWindowController(windowNibName: "MainWindowController")
        mainWindowController?.showWindow(self)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

