//
//  NoteSearchController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 6/20/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa
import RealmSwift

class NoteSearchController: NSObject {

    let db = try! Realm()
    
    var isSearching:Bool = false
    
    var results:Array<Note> {
        get {
            var sr = Array<Note>()
            
            for note in db.objects(Note.self) {
                
                if note.rawText().containsString(searchText) {
                    sr.append(note)
                }
            }
            return sr
        }
    }
    
    
    
    var searchText:String = ""
}
