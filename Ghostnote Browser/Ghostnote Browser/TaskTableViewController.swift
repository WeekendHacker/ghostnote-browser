//
//  TaskTableViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/5/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class TasksController: NSObject, NSTableViewDataSource, NSTableViewDelegate {

    weak var selectedTaskList:TaskList? {
        didSet {
            if selectedTaskList != nil {
                tasksTableView?.reloadData()
            }
        }
    }
    
    weak var tasksTableView:NSTableView? {
        didSet {
            if let tv = tasksTableView {
                tv.setDelegate(self)
                tv.setDataSource(self)
            }
        }
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        var rows = 0
        
        if let selected = selectedTaskList {
            rows = selected.tasks.count
        }
        return rows
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let view = tableView.makeViewWithIdentifier("TaskCell", owner: nil) as? TaskCell
        if let taskList = selectedTaskList {
            let task = taskList.tasks[row]
            view?.task = task
        }
        return view
    }
 
}
