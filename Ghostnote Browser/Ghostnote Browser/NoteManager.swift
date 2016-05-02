//
//  File.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/25/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa
import Foundation
import RealmSwift

class NoteManager {
    static let shared = NoteManager()
    
    let store = try! Realm()
    
    var notes:Results<Note> {
        get {
            return store.objects(Note)
        }
    }
    
    func createNoteWithName(name:String) {
        
        
    }
    
    func deleteNote(note:Note) {
        
        removeFileForNote(note)
        do {
            try store.write({ 
                store.delete(note)
            })
        }
        catch {
            
        }
        
    }
    // file methods
    func createFileForNote(note:Note) throws  -> NSURL {
        return NSURL()
    }
    
    func removeFileForNote(note:Note) {

    }
}