//
//  GhostnoteManager.swift
//  GhostNote
//
//  Created by Jimmy Hough Jr on 5/12/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Cocoa
import Foundation
import RealmSwift
import XCGLogger

class GhostNoteManager: NSObject {
    
    static let shared = GhostNoteManager()
    let searchController = GhostnotesSearchController()
    
    override init() {
        var  config = Realm.Configuration()
        let newURL =  NSURL(fileURLWithPath: appSupportDir.first!).URLByAppendingPathComponent("com.ghostnoteapp.Ghostnote/Default.realm")
        let oldURL =  NSURL(fileURLWithPath: appSupportDir.first!).URLByAppendingPathComponent("com.ghostnoteapp.Ghostnote-Paddle/Default.realm")

        config.fileURL = newURL

        if !NSFileManager.defaultManager().fileExistsAtPath(newURL.path!) {
            XCGLogger.error("new Ghostnote realm does not exist.")
            XCGLogger.warning("You should run the latest Ghostnote to correct this.")
            XCGLogger.warning("Old Ghosnote realm is being used instead")
            
            config.fileURL = oldURL
        }
        
        XCGLogger.info("configuring GhostNotes realm to use \(config)")
        store = try! Realm(configuration: config)
    }
    
    let store:Realm
    
    var appSupportDir = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .AllDomainsMask, true)
    
    var ghostNotes:Array<GhostNote> {
        get {
            
            if searchController.isSearching {
                return searchController.results
            }
            return Array<GhostNote>(store.objects(GhostNote))
        }
    }
    
    func allAppBundleIDs() -> Array<String> {
        var ids = Array<String>()
        for id in ghostNotes {
            if !ids.contains(id.appBundleID) {
                ids.append(id.appBundleID)
            }
        }
        return ids
    }
    
    func docNotesForApp(bundleID:String) -> Array<GhostNote> {
        
        var notes = Array<GhostNote>()
        
        for note in ghostNotes {
            if note.appBundleID == bundleID {
                if !note.isAppNote() {
                    notes.append(note)
                }
            }
        }
        
        return notes
    }
    
    func appNoteForApp(bundleID:String) -> GhostNote? {
        
        for note in ghostNotes {
            if note.appBundleID == bundleID {
                if note.docID == bundleID {
                    return note
                }
            }
        }
        return nil
    }
    
    func delete(ghostnote:GhostNote) {
        let bundleID = ghostnote.appBundleID
        let removedFile = RTFFileManager.shared.removeFileForNote(bundleID,
                                                                  docID: ghostnote.docID)
        if removedFile {
            
            do {
                try store.write({
                    store.delete(ghostnote)

                })
                NSNotificationCenter.defaultCenter().postNotificationName("GhostnoteDeleted",
                                                                          object: nil)
            }
            catch {
                print(error)
            }
            
             RTFFileManager.shared.ifEmptyRemoveDirectoryFor(bundleID)
        }
        
    }
}