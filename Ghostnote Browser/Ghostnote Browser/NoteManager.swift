//
//  NoteManager.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/18/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Foundation
import CoreData
import MagicalRecord

class NoteManager {
    
    static let shared = NoteManager()
    
    let pathString = "~/Library/Application Support/Ghostnote/GhostNote.sqlite" as NSString
    
    init() {
        
        let gnURL = NSURL.fileURLWithPath(pathString.stringByExpandingTildeInPath)
        MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStoreAtURL(gnURL)
        logAppNoteInfo()
    }
    
    func appNotes() -> [GNNote] {
        var notes = Array<GNNote>()
        
        for note in GNNote.MR_findAll() as! [GNNote] {
            if note.isAppNote() && !note.isEmpty() {
                notes.append(note)
            }
        }
        
        return notes
    }
    
    func logAllInfo() {
        for note in GNNote.MR_findAll() as! [GNNote] {
            if !note.isEmpty() {
                print("found \(note.infoString())\n")
            }
        }
    }
    
    func logAppNoteInfo() {
        for note in self.appNotes() {
            print("found \(note.infoString())\n")
        }
    }
    
    func noteCount() -> UInt {
        return GNNote.MR_countOfEntities()
    }
}