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
        configureRealm()
        menuController = MainMenuController(menuItem: newMenuItem)
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
}

