//
//  File.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/18/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Foundation
import Cocoa


protocol GhostnotesOutlineControllerObserver {
    func selectedNote(note:GhostNote)
    func selectedNothing()
}

class GhostnotesOutlineController:NSObject, NSOutlineViewDelegate, NSOutlineViewDataSource {

    var observer:GhostnotesOutlineControllerObserver?
    
    weak var notesOutlineView:NSOutlineView? { didSet {
                if let outlineView = notesOutlineView {
                    outlineView.setDelegate(self)
                    outlineView.setDataSource(self)
                    
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
    }
    
    var appsAndDocsOutline = Dictionary<App,Array<Document>>()
    var apps = Array<App>()
    
    
    func handleNoteCreation() {
        print("Note created")
        reload()
    }
    
    func handleNoteDeletion() {
        print("Note deleted")
        reload()
    }
    
    func reload() {
        refreshApps()
        refreshAppsAndDocsOutline()
        notesOutlineView?.reloadData()
    }

    func refreshApps() {
        apps = Array<App>()

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
    
    func refreshAppsAndDocsOutline() {
        
        appsAndDocsOutline = Dictionary<App, Array<Document>>()
        
        for app in apps {
        
            let notes = GhostNoteManager.shared.docNotesForApp(app.bundleID)
            var docs = Array<Document>()
            
            for note in notes {
                let doc = Document(note: note)
                docs.append(doc)
            }
            
            appsAndDocsOutline[app] = docs
        }
    }
    
    // NSOutlineViewDataSource
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        if let app = item as? App {
            if appsAndDocsOutline[app]?.count > 0 {
                return true
            }
        }
        return false
    }
    
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        
        if item == nil {
            return apps.count
        }
        
        let app = item as! App

        return appsAndDocsOutline[app]!.count
    }
    
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        
        if item == nil {
            return apps[index]
        }
        let app = item as! App

        return appsAndDocsOutline[app]![index]
        
    }
    
    func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        
        var view:NSView = NSView()
        
        
        if item is App {
            let app = item as! App
            view = notesOutlineView?.makeViewWithIdentifier("AppCell", owner: nil) as! AppCell
            (view as! AppCell).app = app
            
        }else if item is Document {
            let doc = item as! Document
            view = notesOutlineView?.makeViewWithIdentifier("DocCell", owner: nil) as! DocCell
            (view as! DocCell).doc = doc
        }
        
        return view
    }
    
    
    // NSOutlineViewDelegate
    
    func outlineViewSelectionDidChange(notification: NSNotification) {
        
        if let outlineView = notification.object as! NSOutlineView? {
            
            if let selectedItem = outlineView.itemAtRow(outlineView.selectedRow) {
                
                if selectedItem is App {
                    if let app = selectedItem as? App {
                        if let note = app.note {
                            observer?.selectedNote(note)
                        }else {
                            observer?.selectedNothing()
                        }
                    }
                }
                else if selectedItem is Document {
                    if let doc = selectedItem as? Document {
                        observer?.selectedNote(doc.note)
                    }
                }
                
            }
        }
    }
    
    // IBAction
    
    @IBAction func refresh(sender:AnyObject?) {
        reload()
    }
}