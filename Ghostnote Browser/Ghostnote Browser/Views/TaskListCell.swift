//
//  TaskListTableCellView.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/5/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class TaskListCell: NSTableCellView {

    var taskList:TaskList? {
        didSet {
            if let list = taskList {
                let title = list.title
                let displayTitle = title.componentsSeparatedByString("<!").first
                self.textField?.stringValue = displayTitle!
            }
        }
    }
    
}
