//
//  TaskListManager.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/4/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa
import RealmSwift
import SwiftyBeaver

class TaskListManager: NSObject {

    static let shared = TaskListManager()
    
    let searchController = TasksSearchController()

    let db = try! Realm()
    
    var taskLists:Array<TaskList> {
        get {
            if searchController.isSearching {
                return searchController.results
            }
            return Array<TaskList>(db.objects(TaskList))
        }
    }
    
    
    func createWelcomeTaskList() {
        
        let newList = TaskList()
        
        do {
            try db.write({
               
                newList.title = "Welcome to Ghostnote Browser !"
                newList.creationDate = NSDate()
                db.add(newList)
            })
        }
        catch {
            SwiftyBeaver.error(error)
        }
        
        newList.addTask("Create task lists with command-l.")
        newList.addTask("Create tasks in the current list with command-t.")
        newList.addTask("Complete a task with the mouse or spacebar.")
        newList.addTask("Delete tasks or task lists with the delete key.")
        newList.addTask("Browse & edit your Ghostnotes out of context by clicking the Ghost icon on the left.")
        
        NSNotificationCenter.defaultCenter().postNotificationName("CreatedTaskList", object: newList)
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasCreatedWelcomeTasks")
    }
    
    func newTaskNameSuffix(inTaskList:TaskList) -> String {
        
        let count = inTaskList.tasks.filter { (taskList) -> Bool in
            if taskList.title.containsString("New Task") {
                return true
            }else {
                return false
            }
            }.count
        if count > 0 {
            return "\(count + 1)"
        }
        return ""
    }
    
    func newTaskListNameSuffix() -> String {
        
        let count = taskLists.filter { (taskList) -> Bool in
            if taskList.title.containsString("New Task List") {
                return true
            }else {
                return false
            }
            }.count
        if count > 0 {
            return "\(count + 1)"
        }
        return ""
    }

    func createTaskList(name:String) {
        let newList = TaskList()
        
        do {
            try db.write({
                let uniquePart = NSDate().timeIntervalSince1970
                
                newList.title = name.stringByAppendingString(" <!\(uniquePart)>")
                newList.creationDate = NSDate()
                db.add(newList)
            })
        }
        catch {
            SwiftyBeaver.error(error)
        }

        newList.addTask("New Task")
        
        NSNotificationCenter.defaultCenter().postNotificationName("CreatedTaskList", object: newList)
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
                SwiftyBeaver.error(error)
            }
        }
    }
    
    func renameTaskList(taskList:TaskList, to:String) {
        do {
            try db.write({
                let uniquePart = NSDate().timeIntervalSince1970

                taskList.title = to.stringByAppendingString(" <!\(uniquePart)>")
                db.add(taskList, update: true)
            })
        }
        catch {
            SwiftyBeaver.error(error)
        }
        NSNotificationCenter.defaultCenter().postNotificationName("TaskListRenamed", object: taskList)
    }
    
    func changeTask(task:Task, to:String) {
        
        do {
            try db.write({
                let uniquePart = NSDate().timeIntervalSince1970
                
                task.title = to.stringByAppendingString(" <!\(uniquePart)>")
                
                db.add(task, update: true)
            })
            NSNotificationCenter.defaultCenter().postNotificationName("TaskRenamed", object: nil)
        }
        catch {
            SwiftyBeaver.error(error)
        }
    }
}
