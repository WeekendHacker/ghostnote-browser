//
//  GNCoreDataToRealmMigrator.swift
//  GhostNote
//
//  Created by Jimmy Hough Jr on 5/12/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Cocoa
import RealmSwift

class GNCoreDataToRealmMigrator: NSObject {
    
    static let shared = GNCoreDataToRealmMigrator()
    
    let store = try! Realm()
    
    func hasPerformedImport() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey("hasMigratedToRealm")
    }
    
    func migrate(noteManager:NoteManager) {
        
//        let coreDataNotes =  GNNote.MR_findAll() ?? []
        
//        for case let note as GNNote in coreDataNotes {
//
//            if let bundleID = note.appBundleID, docPath = note.documentPath, content = note.content where !content.string.isEmpty {
//
//                noteManager.createNote(bundleID, docID: docPath, content: content)
//            }
//        }
    }
}
