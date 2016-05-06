//
//  TaskNameValidator.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/5/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class TaskNameValidator: NamedItemValidator {

    
    static let shared = TaskNameValidator()
    
    var taskList:TaskList?
    
    @objc func nameExists(name:String) -> Bool {
        var exists = false
        // unique name check
        
        if let tl = taskList {
            let predicate = NSPredicate(format: "title == %@", argumentArray: [name])
            if (tl.tasks.filter(predicate).count > 0) {
                exists = true
            }
        }
       
        
        return exists
    }
    
}
