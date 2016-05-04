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
    dynamic var listName = "New List"
    var tasks = List<Task>()
    dynamic var creationDate:NSDate?
    
}
