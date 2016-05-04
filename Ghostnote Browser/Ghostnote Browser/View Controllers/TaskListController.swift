//
//  TaskListController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/3/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class TaskListController: NSObject, NSTableViewDelegate, NSTableViewDataSource {

    weak var taskListTableView:NSTableView? {
        didSet {
            if let tv = taskListTableView {
                tv.setDelegate(self)
                tv.setDataSource(self)
            }
        }
    }
    
    weak var addListButton:NSButton?
    weak var deleteListButton:NSButton?
    
    
    // NSTableViewDatasource
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return TaskListManager.shared.taskLists.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let taskList = TaskListManager.shared.taskLists[row]
        
        let view = taskListTableView?.makeViewWithIdentifier("TaskListCell", owner: nil) as? NSTableCellView
        view?.textField?.stringValue = taskList.listName
        
        return view
        
    }
}
