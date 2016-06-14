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
                newList.title = name
                newList.creationDate = NSDate()
                db.add(newList)
            })
        }
        catch {
            print(error)
        }
        let uniquePart = NSDate().timeIntervalSince1970
        newList.addTask("New Task <!\(uniquePart)>")
        
        NSNotificationCenter.defaultCenter().postNotificationName("CreatedTaskList", object: nil)
    }
    
    func deleteTaskList(name:String) {
        
        let namePredicate = NSPredicate(format: "title == %@", argumentArray: [name])
        if let listToDelete = db.objects(TaskList).filter(namePredicate).first {
            
            do {
                try db.write({
                    listToDelete.tasks.forEach({ (task) in
                        db.delete(task)
                    })
                    db.delete(listToDelete)
                })
                NSNotificationCenter.defaultCenter().postNotificationName("DeletedTaskList", object: listToDelete)

            }
            catch {
                print(error)
            }
        }
    }
    
    func renameTaskList(taskList:TaskList, to:String) {
        do {
            try db.write({
                taskList.title = to
                db.add(taskList, update: true)
            })
        }
        catch {
            print(error)
        }
        NSNotificationCenter.defaultCenter().postNotificationName("TaskListRenamed", object: taskList)
    }
    
    func changeTask(task:Task, to:String) {
        
        do {
            try db.write({
                task.title = to
                db.add(task, update: true)
            })
            NSNotificationCenter.defaultCenter().postNotificationName("TaskRenamed", object: nil)
        }
        catch {
            print(error)
        }
    }
}
