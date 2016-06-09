//
//  TaskTableViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/5/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class TasksController: NSObject, NSTableViewDataSource, NSTableViewDelegate, DeleteRowDelegate {

    override init() {
         super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TasksController.handleTaskListDeleted(_:)), name: "DeletedTaskList", object: nil)
        
    }
    
    weak var selectedTaskList:TaskList? {
        didSet {
            tasksTableView?.reloadData()
        }
    }
    
    weak var tasksTableView:DeletableTableView? {
        didSet {
            if let tv = tasksTableView {
                tv.setDelegate(self)
                tv.setDataSource(self)
                tv.wantsLayer = true
                tv.deleteDelegate = self
            }
        }
    }

    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 72.0
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
    
    func deleteRow(row: Int) {
        if let row = tasksTableView?.selectedRowIndexes.firstIndex {
            let view = tasksTableView?.viewAtColumn(0, row: row, makeIfNecessary: false) as? TaskCell
            
            if let selectedTask = view?.task {
                
                if let taskList = selectedTaskList {
                    taskList.removeTask(selectedTask)
                }
                tasksTableView?.reloadData()
            }
        }

    }

    // notification handlers
    
    func handleTaskListDeleted(notif:NSNotification) {
        
            selectedTaskList = nil
            tasksTableView?.reloadData()
        
    }
}
