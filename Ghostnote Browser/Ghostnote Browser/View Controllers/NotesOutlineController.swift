//
//  File.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/18/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Foundation
import Cocoa


protocol NotesOutlineControllerObserver {
    func selectedNote(note:GNNote)
}

class NotesOutlineController:NSObject, NSOutlineViewDelegate, NSOutlineViewDataSource {

    var observer:NotesOutlineControllerObserver?
    
    weak var notesOutlineView:NSOutlineView? { didSet {
                if let outlineView = notesOutlineView {
                    outlineView.setDelegate(self)
                    outlineView.setDataSource(self)
                }
        }
    }
    
    var appsAndDocsOutline = Dictionary<App,Array<Document>>()
    var apps = Array<App>()
    
    
    func reload() {
        refreshApps()
        refreshAppsAndDocsOutline()
        notesOutlineView?.reloadData()
    }
    
    func refreshApps() {
        apps = Array<App>()
        print("refreshing apps...")
        let bundleIDs = NoteManager.shared.allAppBundleIDs()
        print("found \(bundleIDs)")
        for bundleID in bundleIDs  {
            print(bundleID)
            if let note = NoteManager.shared.appNoteForApp(bundleID) {
                print("found note \(note)")
                let app = App(note:note)
                apps.append(app)
                print("added \(app.bundleID)")
            }
        }
    }
    
    func refreshAppsAndDocsOutline() {
        
        appsAndDocsOutline = Dictionary<App, Array<Document>>()
        
        for app in apps {
        
            let notes = NoteManager.shared.docNotesForApp(app.bundleID)
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
        
        let view = notesOutlineView?.makeViewWithIdentifier("DataCell", owner: nil) as! NSTableCellView
        
        if item is App {
            let app = item as! App
            view.textField?.stringValue = app.bundleID
            view.imageView?.image = AppIconProvider.iconImagefor(app.bundleID)
        }else if item is Document {
            let doc = item as! Document
            view.textField?.stringValue = doc.path
            view.imageView?.image = DocumentIconProvider.iconImageForDocumentPath(doc.path)
        }
        
        return view
    }
    
    
    // NSOutlineViewDelegate
    
    func outlineViewSelectionDidChange(notification: NSNotification) {
        if let outlineView = notification.object as! NSOutlineView? {
            if let selectedItem = outlineView.itemAtRow(outlineView.selectedRow) {
                
                if selectedItem is App {
                    if let app = selectedItem as? App {
                        observer?.selectedNote(app.note)
                    }
                }
                
                if selectedItem is Document {
                    if let doc = selectedItem as? Document {
                        observer?.selectedNote(doc.note)
                    }
                }
                
            }
        }
    }
}