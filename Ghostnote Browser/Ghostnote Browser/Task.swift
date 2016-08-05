//
//  Task.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/4/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa
import RealmSwift
import SwiftyBeaver

class Task: Object {

    dynamic var id = NSUUID().UUIDString
    dynamic var title = "New Task"
    dynamic var creationDate:NSDate?
    dynamic var completionDate:NSDate?
    dynamic var isComplete:Bool = false
    
    override class func primaryKey() -> String {
        return "id"  
    }
    
    func complete() {
        let db = try! Realm()
        
        do {
            try db.write({ 
                self.completionDate = NSDate()
                isComplete = true
                db.add(self, update: true)
            })
        }
        catch {
            SwiftyBeaver.error(error)
        }
    }
    
    func incomplete() {
        let db = try! Realm()
        
        do {
            try db.write({
                self.completionDate = nil
                isComplete = false
                db.add(self, update: true)
            })
        }
        catch {
            SwiftyBeaver.error(error)
        }
    }
    
    
}
