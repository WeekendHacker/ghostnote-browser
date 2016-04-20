//
//  GhostNoteManager.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/18/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Foundation
import CoreData
import MagicalRecord

class GhostNoteManager {
    
    static let shared = GhostNoteManager()
    
    let pathString = "~/Library/Application Support/Ghostnote/GhostNote.sqlite" as NSString
    
    init() {
        
        let gnURL = NSURL.fileURLWithPath(pathString.stringByExpandingTildeInPath)
        MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStoreAtURL(gnURL)
    }
    
    func appNoteForApp(bundleID:String) -> GNNote? {
        var notes = Array<GNNote>()
        print("getting app note for \(bundleID)")
        
        for note in GNNote.MR_findAllSortedBy("appBundleID", ascending: false) as! [GNNote] {
            if note.isAppNote() && !note.isEmpty() && (note.appBundleID == bundleID) {
                notes.append(note)
            }
        }
        
        return notes.first
    }
    
    func docNotesForApp(bundleID:String) -> [GNNote] {
        var notes = Array<GNNote>()
        
        let predicate = NSPredicate(format: "appBundleID == %@", argumentArray: [bundleID])
        for note in GNNote.MR_findAllWithPredicate(predicate) as! [GNNote] {
            if !note.isAppNote() && !note.isEmpty() {
                notes.append(note)
            }
        }
        return notes
    }
    
    func allAppBundleIDs() -> Array<String> {
        var bundleIDs = Array<String>()
        
        for note in GNNote.MR_findAllSortedBy("appBundleID", ascending: false) as! [GNNote] {
            if let bundleID = note.appBundleID {
                if !bundleIDs.contains(bundleID) && !note.isEmpty() {
                    bundleIDs.append(bundleID)
                }
            }
        }
        
        return bundleIDs
    }

    
    func logAllInfo() {
        for note in GNNote.MR_findAll() as! [GNNote] {
            if !note.isEmpty() {
                print("found \(note.infoString())\n")
            }
        }
    }
    
    func noteCount() -> UInt {
        return GNNote.MR_countOfEntities()
    }
}