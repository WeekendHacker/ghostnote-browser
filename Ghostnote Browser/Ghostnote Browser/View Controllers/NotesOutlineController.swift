//
//  File.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/18/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Foundation
import Cocoa

class NotesOutlineController:NSObject, NSOutlineViewDelegate, NSOutlineViewDataSource {
    
    weak var notesOutlineView:NSOutlineView? { didSet {
                if let outlineView = notesOutlineView {
                    outlineView.setDelegate(self)
                    outlineView.setDataSource(self)
                    reload()
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
        for bundleID in NoteManager.shared.allAppBundleIDs() {
            let app = App(bundleID: bundleID)
            apps.append(app)
        }
    }
    
    func refreshAppsAndDocsOutline() {
        
        appsAndDocsOutline = Dictionary<App, Array<Document>>()
        for app in apps {
        
            let notes = NoteManager.shared.docNotesForApp(app.bundleID)
            var docs = Array<Document>()
            
            for note in notes {
                let doc = Document(path: note.documentPath!)
                docs.append(doc)
            }
            
            appsAndDocsOutline[app] = docs

        }
    }
    
    // NSOutlineViewDataSource
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        
        return item is App
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
    
}