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

    @IBOutlet weak var window: NSWindow!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
            let pathString = "~/Library/Application Support/Ghostnote/GhostNote.sqlite" as NSString
        
            let gnURL = NSURL.fileURLWithPath(pathString.stringByExpandingTildeInPath)
        MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStoreAtURL(gnURL)
        
        let all = GNNote.MR_findAll() as! [GNNote]
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

