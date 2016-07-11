//
//  GhostNotesAppTableViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 6/4/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

protocol GhostNotesAppTableViewControllerObserver {

    func selectedApp(app:App)
    func selectedNothing()
}

class GhostNotesAppTableViewController: NSObject , NSTableViewDelegate , NSTableViewDataSource {

    var observer:GhostNotesAppTableViewControllerObserver?
    
    @IBOutlet weak var appsTableView:NSTableView? {
        didSet {
            appsTableView?.setDelegate(self)
            appsTableView?.setDataSource(self)
            appsTableView?.selectionHighlightStyle = .Regular
            
            if let appCellNib = NSNib(nibNamed: "AppCell", bundle: nil) {
                appsTableView?.registerNib(appCellNib, forIdentifier: "AppCell")
            }
            
            if let rowViewNib = NSNib(nibNamed: "CustomRowView", bundle: nil) {
                appsTableView?.registerNib(rowViewNib, forIdentifier: "CustomRowView")
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

    func reload() {
        refreshApps()
        appsTableView?.reloadData()
    }
    
    func refreshApps() {
        apps = Array<App>()

        let bundleIDs = GhostNoteManager.shared.allAppBundleIDs()
        for bundleID in bundleIDs  {
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
        reload()
    }
    
    func handleNoteDeletion() {
        reload()
    }
    
    // NstableViewDatasource
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return apps.count
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 25.0
    }
    
    func tableView(tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let rowView = tableView.makeViewWithIdentifier("CustomRowView", owner: nil) as? CustomRowView
        return rowView
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let app = apps[row]
        let view = appsTableView?.makeViewWithIdentifier("AppCell", owner: nil) as! AppCell
        view.app = app
        return view
    }
    
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        if let tv = notification.object as? NSTableView! {
            
            if tv.hasSelection() {
                let selectedApp = apps[tv.selectedRow]
                observer?.selectedApp(selectedApp)
            }else {
                observer?.selectedNothing()
            }
        }
    }
}
