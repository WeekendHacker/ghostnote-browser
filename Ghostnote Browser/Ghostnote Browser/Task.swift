//
//  Task.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/4/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa
import RealmSwift

class Task: Object {

    dynamic var title = "New Task"
    dynamic var creationDate:NSDate?
    dynamic var completionDate:NSDate?
    dynamic var isComplete:Bool = false
    
    override class func primaryKey() -> String {
        return "title"  
    }
    
    func complete() {
        let db = try! Realm()
        
        do {
            try db.write({ 
                self.completionDate = NSDate()
                db.add(self, update: true)
            })
        }
        catch {
            print(error)
        }
    }
    
    func incomplete() {
        let db = try! Realm()
        
        do {
            try db.write({
                self.completionDate = nil
                db.add(self, update: true)
            })
        }
        catch {
            print(error)
        }
    }
}