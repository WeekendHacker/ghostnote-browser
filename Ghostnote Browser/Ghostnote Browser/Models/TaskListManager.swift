//
//  TaskListManager.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/4/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa
import RealmSwift

class TaskListManager: NSObject {

    static let shared = TaskListManager()
    let db = try! Realm()
    
    var taskLists:Results<TaskList> {
        get {
            return db.objects(TaskList)
        }
    }
    
    func createTaskList(name:String) {
        
        let newList = TaskList()
        
        do {
            try db.write({
                newList.listName = name
                newList.creationDate = NSDate()
                db.add(newList)
            })
        }
        catch {
            print(error)
        }
    }
    
    func deleteTaskList(name:String) {
        
        let namePredicate = NSPredicate(format: "listName == %@", argumentArray: [name])
        if let listToDelete = db.objects(TaskList).filter(namePredicate).first {
            
            do {
                try db.write({ 
                    db.delete(listToDelete)
                })
            }
            catch {
                print(error)
            }
        }
        
    }
}
