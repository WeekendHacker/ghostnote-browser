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

class GhostNoteManager: NSObject {
    
    static let shared = GhostNoteManager()
    let searchController = GhostnotesSearchController()
    
    override init() {
        var  config = Realm.Configuration()
        config.fileURL =  NSURL(fileURLWithPath: appSupportDir.first!).URLByAppendingPathComponent("com.ghostnoteapp.Ghostnote-Paddle/Default.realm")
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
        
        let removedFile = RTFFileManager.shared.removeFileForNote(ghostnote.appBundleID,
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
        }
        
    }
}