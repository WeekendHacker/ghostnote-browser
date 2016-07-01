//
//  GhostnotesSearchController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 6/20/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa
import RealmSwift

class GhostnotesSearchController: NSObject {
    let db = try! Realm()
    
    var isSearching:Bool = false
    
    var results:Results<GhostNote> {
        get {
            return db.objects(GhostNote.self).filter(ghostNotePredicate)
        }
    }
    
    var ghostNotePredicate:NSPredicate {
        get {
            let predicate = NSPredicate(format: "title contains %@", argumentArray: [searchText])
            return predicate
        }
    }
    
    var searchText:String = ""
}
