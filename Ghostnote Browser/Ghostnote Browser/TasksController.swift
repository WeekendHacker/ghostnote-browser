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
    
    weak var addTaskButton:NSButton? {
        didSet {
            if let button = addTaskButton {
                button.target = self
                button.action = #selector(TasksController.addTaskButtonClicked(_:))
            }
        }
    }
    
    weak var deleteTaskButton:NSButton? {
        didSet {
            if let button = deleteTaskButton {
                button.target = self
                button.action = #selector(TasksController.deleteTaskButtonClicked(_:))
            }
        }
    }
    
    // NSTableViewDatasource
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
 
    
    // Actions
    
    func addTaskButtonClicked(sender:AnyObject?) {
        print("add task clicked")
    }
    
    func deleteTaskButtonClicked(sender:AnyObject?) {
        print("delete task clicked")
    }
}
