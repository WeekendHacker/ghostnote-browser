//
//  TaskListTableCellView.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/5/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class TaskListCell: NSTableCellView, NSTextFieldDelegate {

    var taskList:TaskList? {
        didSet {
            if let list = taskList {
                let title = list.title
                let displayTitle = title.componentsSeparatedByString("<!").first
                textField?.stringValue = displayTitle!
                textField?.delegate = self
            }
        }
    }
    
    override func controlTextDidEndEditing(obj: NSNotification) {
        if let editedField = obj.object as? NSTextField {
            
            if !editedField.stringValue.isEmpty {
                if let tl = taskList {
                    TaskListManager.shared.renameTaskList(tl, to: editedField.stringValue)
                }
            }
        }
    }
    
}
