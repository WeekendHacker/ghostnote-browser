//
//  TaskListNameValidator.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/4/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class TaskListNameValidator: NSObject, NamedItemValidator {

    static let shared = TaskListNameValidator()
    
    func nameExists(name:String) -> Bool {
        var exists = false

        TaskListManager.shared.taskLists.forEach { (tl) in
            if tl.title == name {
                exists = true
            }
        }
        
        return exists
    }
}
