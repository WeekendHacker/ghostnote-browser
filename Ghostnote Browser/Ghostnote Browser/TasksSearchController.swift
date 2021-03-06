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
    
    var results:Array<TaskList> {
        get {

            let taskLists = Array<TaskList>(db.objects(TaskList.self))
            
            let foo = taskLists.filter { (taskList) -> Bool in
                
                let filteredTasks = taskList.tasks.filter({ (task) -> Bool in

                    if task.title.containsString(searchText) {
                        return true
                    }else if task.title.uppercaseString.containsString(searchText) {
                        return true
                    }
                    return false
                })
                if filteredTasks.count > 0 {
                    return true
                }
                return false
            }
            return foo
        }
    }
    
    var searchText:String = ""
    

}
