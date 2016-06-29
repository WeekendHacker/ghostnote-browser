//
//  TaskListTableCellView.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/5/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class TaskListCell: NSTableCellView, NSTextFieldDelegate, SelectableCell {

    var taskList:TaskList? {
        didSet {
            if let list = taskList {
                textField?.stringValue = list.title.withoutUniquePart()
                textField?.delegate = self
            }
        }
    }
    
    
    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        if textField!.stringValue.isEmpty {
            NSBeep()
            return false
        }
        return true
    }
    
    override func controlTextDidEndEditing(obj: NSNotification) {
        if let editedField = obj.object as? NSTextField {
            
            if !editedField.stringValue.isEmpty {
                if let tl = taskList {
                    TaskListManager.shared.renameTaskList(tl, to: editedField.stringValue)
                }
            }
            editedField.editable = false
        }
    }
    
}
