//
//  TaskCell.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/5/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class TaskCell: NSTableCellView {

    @IBOutlet weak var checkbox:NSButton?
    
    var task:Task? {
        didSet {
            if let t = task {
                if let cb = checkbox {
                    checkbox?.title = t.title
                    
                    if t.completionDate != nil {
                        cb.state = NSOnState
                    }else {
                        cb.state = NSOffState
                    }
                }
            }
        }
    }
    
    @IBAction func checkboxChecked(sender:AnyObject?) {
        
        if task?.completionDate != nil {
            task?.incomplete()
        }else {
            task?.complete()
        }
    }
    
}
