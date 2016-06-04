//
//  GhostNotesAppTableViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 6/4/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class GhostNotesAppTableViewController: NSObject , NSTableViewDelegate , NSTableViewDataSource {

    @IBOutlet weak var appsTableView:NSTableView? {
        didSet {
            appsTableView?.setDelegate(self)
            appsTableView?.setDataSource(self)
            
            if let appCellNib = NSNib(nibNamed: "AppCell", bundle: nil) {
                appsTableView?.registerNib(appCellNib, forIdentifier: "AppCell")
            }
            
            NSDistributedNotificationCenter.defaultCenter().addObserver(self,
                                                                        selector: #selector(handleNoteCreation),
                                                                        name: "GhostnoteCreatedNote",
                                                                        object: nil)
            
            NSDistributedNotificationCenter.defaultCenter().addObserver(self,
                                                                        selector: #selector(handleNoteDeletion),
                                                                        name: "GhostnoteDeletedNote",
                                                                        object: nil)
        }
    }
    
    var apps = Array<App>()

    var currentAppNote:GhostNote?
    
    func reload() {
        refreshApps()
        appsTableView?.reloadData()
    }
    
    func refreshApps() {
        apps = Array<App>()
        print("refreshing apps...")
        let bundleIDs = GhostNoteManager.shared.allAppBundleIDs()
        for bundleID in bundleIDs  {
            print(bundleID)
            if let note = GhostNoteManager.shared.appNoteForApp(bundleID) {
                let app = App(bundleID: bundleID, note:note)
                apps.append(app)
            }else {
                let app = App(bundleID: bundleID, note: nil)
                apps.append(app)
            }
        }
    }
    
    // Notification Handlers
    func handleNoteCreation() {
        print("Note created")
        reload()
    }
    
    func handleNoteDeletion() {
        print("Note deleted")
        reload()
    }
    
    // NstableViewDatasource
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return apps.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let app = apps[row]
        let view = appsTableView?.makeViewWithIdentifier("AppCell", owner: nil) as! AppCell
        view.app = app
        return view
    }
}
