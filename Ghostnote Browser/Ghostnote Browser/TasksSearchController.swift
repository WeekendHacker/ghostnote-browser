//
//  TasksSearchController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 6/20/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa
import RealmSwift

class TasksSearchController: NSObject {

    let db = try! Realm()
    
    var isSearching:Bool = false
    
    var results:Results<TaskList> {
        get {
            return db.objects(TaskList.self).filter(taskListNamePredicate)
        }
    }
    
    var taskListNamePredicate:NSPredicate {
        get {
            let predicate = NSPredicate(format: "title contains %@", argumentArray: [searchText])
            
            return predicate
        }
    }
    
    var searchText:String = ""
}
