//
//  GhostNotesAppTableViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 6/4/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa
import XCGLogger

protocol GhostNotesAppTableViewControllerObserver {

    func selectedApp(app:App)
    func selectedNothing()
}

class GhostNotesAppTableViewController: NSObject , NSTableViewDelegate , NSTableViewDataSource, DeleteRowDelegate {

    var observer:GhostNotesAppTableViewControllerObserver?
    
    @IBOutlet weak var appsTableView:DeletableTableView? {
        didSet {
            appsTableView?.setDelegate(self)
            appsTableView?.setDataSource(self)
            appsTableView?.selectionHighlightStyle = .Regular
            appsTableView?.target = self
            appsTableView?.doubleAction = #selector(doubleClickedAction(_:))
            appsTableView?.deleteDelegate = self
            if let appCellNib = NSNib(nibNamed: "AppCell", bundle: nil) {
                appsTableView?.registerNib(appCellNib, forIdentifier: "AppCell")
            }
            
            if let rowViewNib = NSNib(nibNamed: "CustomRowView", bundle: nil) {
                appsTableView?.registerNib(rowViewNib, forIdentifier: "CustomRowView")
            }

            
            NSNotificationCenter.defaultCenter().addObserver(self,
                                                             selector: #selector(reload),
                                                             name: "GhostnoteDeleted",
                                                             object: nil)
            
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
    
    func doubleClickedAction(sender:AnyObject?) {
        if let tv = sender as? NSTableView {
            let row = tv.selectedRow
            if row != NSNotFound {
                let app = apps[row]
                NoteSourceOpener.open(app.bundleID)
            }
        }
    }
    
    var apps = Array<App>()

    func reload() {
        refreshApps()
        appsTableView?.reloadData()
    }
    
    func refreshApps() {
        
        apps = Array<App>()

        // if there is a doc note for an app
        // we still need an app in the tree to get to it
        // thus the else clause
        
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
    
    // MARK DeleteRowDelegate
    
    func deleteRow(row: Int) {
        let app = apps[row]
        if let appNote = GhostNoteManager.shared.appNoteForApp(app.bundleID) {
            if let cell = appsTableView?.viewAtColumn(0, row: row, makeIfNecessary: false) {
                let payload = ["noteToDelete" : appNote,
                               "hostingCell" : cell]
                
                NSNotificationCenter.defaultCenter().postNotificationName("DeleteGhostnoteRequest",
                                                                          object: payload)
            }
        }
  
    }
    
    deinit {
        NSDistributedNotificationCenter.defaultCenter().removeObserver(self)
    }
}
