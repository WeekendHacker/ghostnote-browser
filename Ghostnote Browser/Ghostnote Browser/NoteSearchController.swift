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
    
    var results = Array<Note>()
    
    var noteNamePredicate:NSPredicate {
        get {
            let predicate = NSPredicate(format: "name contains %@", argumentArray: [searchText])

            return predicate
        }
    }
    
    var searchText:String = "" {
        didSet {
            results.removeAll()
            for result in db.objects(Note.self).filter(noteNamePredicate) {
                results.append(result)
            }
        }
    }
}
