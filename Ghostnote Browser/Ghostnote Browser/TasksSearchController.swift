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
                    print(task.title)
                    print("search text is \(searchText)")
                    
                    if task.title.containsString(searchText) {
                        print(task.title)
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
