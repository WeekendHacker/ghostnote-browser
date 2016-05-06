//
//  TaskList.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/4/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa
import RealmSwift

class TaskList: Object {
    dynamic var title = "New List"
    var tasks = List<Task>()
    dynamic var creationDate:NSDate?
    
    override class func primaryKey() ->String {
        return "title"
    }
    
    func addTask(named:String) {
        let db = try! Realm()
        
        let task = Task()
        
        do {
            try db.write({ 
                task.creationDate = NSDate()
                task.title = named
                self.tasks.append(task)
                db.add(self, update: true)
            })
        }
        catch {
            print(error)
        }
    }
    
    func removeTask(task:Task) {
        let db = try! Realm()
        
        
        do {
            try db.write({
                db.delete(task)
            })
        }
        catch {
            print(error)
        }

    }
}
