//
//  TaskList.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/4/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa
import RealmSwift
import SwiftyBeaver

class TaskList: Object {
    dynamic var id = NSUUID().UUIDString
    dynamic var title = "New List"
    var tasks = List<Task>()
    dynamic var creationDate:NSDate?
    
    override class func primaryKey() ->String {
        return "id"
    }
    
    func addTask(named:String) {
        let db = try! Realm()
        
        let task = Task()
        
        do {
            try db.write({ 
                task.creationDate = NSDate()
                let uniquePart = NSDate().timeIntervalSince1970
                
                task.title = named.stringByAppendingString(" <!\(uniquePart)>")
                self.tasks.append(task)
                db.add(self, update: true)
            })
            NSNotificationCenter.defaultCenter().postNotificationName("TaskAdded", object: task)
        }
        catch {
            SwiftyBeaver.error(error)
        }
    }
    
    func removeTask(task:Task) {
        let db = try! Realm()
        
        
        do {
            try db.write({
                db.delete(task)
            })
            NSNotificationCenter.defaultCenter().postNotificationName("TaskDeleted", object: nil)

        }
        catch {
            SwiftyBeaver.error(error)
        }

    }
}
