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
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(TasksController.handleTaskListDeleted(_:)),
                                                         name: "DeletedTaskList",
                                                         object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleNewTaskAction),
                                                         name: "NewTaskAction",
                                                         object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleTaskDeleted),
                                                         name: "TaskDeleted",
                                                         object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleTaskAdded(_:)),
                                                         name: "TaskAdded",
                                                         object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleTaskListRenamed(_:)),
                                                         name: "TaskListRenamed",
                                                         object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleTaskRenamed(_:)),
                                                         name: "TaskRenamed",
                                                         object: nil)
        
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
                tv.selectionHighlightStyle = .None
                
                if let headerNib = NSNib(nibNamed:"HeaderCell", bundle: nil) {
                    tv.registerNib(headerNib, forIdentifier: "HeaderCell")
                }
                
                if let taskNib = NSNib(nibNamed: "TaskCell", bundle: nil) {
                    tv.registerNib(taskNib, forIdentifier: "TaskCell")
                }
                
                tv.target = self
                tv.action = #selector(tvAction(_:))
            }
        }
    }

    // NSTableViewDatasource
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        if row == 0 {
            return 30.0
        }
        return 50.0
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        var rows = 0
        
        if let selected = selectedTaskList {
            rows = selected.tasks.count + 1
        }
        return rows
    }
    
    func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if row == 0 {
            return false
        }
        return true
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if let taskList = selectedTaskList {
            if row == 0 {
                let view = tableView.makeViewWithIdentifier("HeaderCell", owner: nil) as? HeaderCell
                view?.title = taskList.title
                return view
            }else {
                let view = tableView.makeViewWithIdentifier("TaskCell", owner: nil) as? TaskCell
                let task = taskList.tasks[row]
                view?.task = task
                return view
            }
        }
        return nil
    }
    
    // select cell for selected row
    func tvAction(tv:AnyObject?) {
        if let tableView = tv as? DeletableTableView {
            
            tableView.enumerateAvailableRowViewsUsingBlock({ (rowView, row) in
                if row != 0 {
                    if let selectedCell = rowView.viewAtColumn(0) as? SelectableCell {
                        selectedCell.select(rowView.selected)
                    }
                }
            })
        }
    }
 
    // Actions
    
    func deleteRow(row: Int) {
        if let row = tasksTableView?.selectedRowIndexes.firstIndex {
            let view = tasksTableView?.viewAtColumn(0, row: row, makeIfNecessary: false) as? TaskCell
            
            if let selectedTask = view?.task {
                
                if let taskList = selectedTaskList {
                    taskList.removeTask(selectedTask)
                }
            }
        }
    }
    
    func beginEditingForNewTask(task:Task) {
        if let tableView = tasksTableView {
            
            tableView.enumerateAvailableRowViewsUsingBlock({ (rowView, row) in
                if row != 0 {
                    if let cell = rowView.viewAtColumn(0) as? TaskCell {
                        if let cellTask = cell.task {
                            if cellTask.id == task.id {
                                self.tasksTableView?.scrollRowToVisible(row)
                                cell.textField?.enterEditing()
                            }
                        }
                    }
                }
            })
        }
    }

    // notification handlers
    func handleNewTaskAction() {
        if let tl = selectedTaskList {
            
            tl.addTask("New Task")
        }
    }
    
    func handleTaskListRenamed(notif:NSNotification) {
        if let tl = selectedTaskList {
            let view = tasksTableView?.viewAtColumn(0, row: 0, makeIfNecessary: false) as? HeaderCell
            view?.title = tl.title
        }
    }
    
    func handleTaskListDeleted(notif:NSNotification) {
            selectedTaskList = nil
            tasksTableView?.reloadData()
    }
    
    func handleTaskDeleted() {
        tasksTableView?.reloadData()
    }

    func handleTaskAdded(notif:NSNotification) {
        tasksTableView?.reloadData()
        
        performSelector(#selector(beginEditingForNewTask(_:)),
                        withObject: notif.object as! Task,
                        afterDelay: 0.3)
    }
    
    func handleTaskRenamed(notification:NSNotification) {
        tasksTableView?.reloadData()
    }
}
