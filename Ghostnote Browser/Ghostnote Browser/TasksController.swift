//
//  TaskTableViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/5/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class TasksController: NSObject, NSTableViewDataSource, NSTableViewDelegate, DeleteRowDelegate, InterTableKeyboardNavigationDelegate {

    override init() {
        
        super.init()
        registerForNotifications()
        
        
    }
    
    weak var addTaskButton:NSButton? {
        didSet {

            addTaskButton?.action = #selector(addTaskButtonClicked(_:))
            addTaskButton?.target = self
            addTaskButton?.enabled = false
        }
    }
    
    weak var selectedTaskList:TaskList? {
        didSet {
            if let list = selectedTaskList {
                listTitleLabel?.stringValue = list.title.withoutUniquePart()
                addTaskButton?.enabled = true
            }else {
                addTaskButton?.enabled = false
                listTitleLabel?.stringValue = ""
            }
            
            tasksTableView?.reloadData()
        }
    }
    
    weak var listTitleLabel:NSTextField? {
        didSet {
            listTitleLabel?.stringValue = ""
        }
    }

    
    weak var tasksTableView:DeletableTableView? {
        didSet {
            if let tv = tasksTableView {
                
                tv.setDelegate(self)
                tv.setDataSource(self)
                tv.wantsLayer = true
                tv.deleteDelegate = self
                tv.keyboardDelegate = self
                
                tv.selectionHighlightStyle = .Regular
                tv.allowsTypeSelect = true
                
                tv.target = self
                tv.action = #selector(tvAction(_:))
                
                
                if let rowViewNib = NSNib(nibNamed: "CustomRowView", bundle: nil) {
                    tv.registerNib(rowViewNib, forIdentifier: "CustomRowView")
                }
                
                if let taskNib = NSNib(nibNamed: "TaskCell", bundle: nil) {
                    tv.registerNib(taskNib, forIdentifier: "TaskCell")
                }
            }
        }
    }

    
    func registerForNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleTaskListCreated),
                                                         name: "CreatedTaskList",
                                                         object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(TasksController.handleTaskListDeleted(_:)),
                                                         name: "DeletedTaskList",
                                                         object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleTaskListRenamed(_:)),
                                                         name: "TaskListRenamed",
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
                                                         selector: #selector(handleTaskRenamed(_:)),
                                                         name: "TaskRenamed",
                                                         object: nil)

    }
    
    // NSTableViewDatasource
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30.0
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        var rows = 0
        
        if let selected = selectedTaskList {
            rows = selected.tasks.count 
        }
        return rows
    }
    
    func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {

        return true
    }
    
    func tableView(tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        if let rv = tableView.makeViewWithIdentifier("CustomRowView", owner: nil) as? CustomRowView {
            rv.forTasks = true
            return rv
        }
        return nil
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if let taskList = selectedTaskList {

            let view = tableView.makeViewWithIdentifier("TaskCell", owner: nil) as? TaskCell
            let task = taskList.tasks[row]
            view?.task = task
            return view
        }
        return nil
    }
    
    
    // InterTableKeyboardNavigationDelegate
    
    func leftArrow() {
        NSNotificationCenter.defaultCenter().postNotificationName("SelectTaskListTableView",
                                                                  object: nil)
    }
    
    func rightArrow() {
        
    }
    // select cell for selected row
    func tvAction(tv:AnyObject?) {
        if let tableView = tv as? DeletableTableView {
            
            tableView.enumerateAvailableRowViewsUsingBlock({ (rowView, row) in
                if let selectedCell = rowView.viewAtColumn(0) as? SelectableCell {
                    selectedCell.select(rowView.selected)
                }
            })
        }
    }
 
    // Actions
    
    func deleteRow(row: Int) {
        if let row = tasksTableView?.selectedRowIndexes.firstIndex {
            let view = tasksTableView?.viewAtColumn(0, row: row, makeIfNecessary: false) as? TaskCell
            
            if let selectedTask = view?.task {
                
                var payload = Dictionary<String, AnyObject>()
                payload["hostingTaskCell"] = view
                payload["taskToDelete"] = selectedTask
                if let taskList = selectedTaskList {
                    payload["containingTaskList"] = taskList
                    NSNotificationCenter.defaultCenter().postNotificationName("DeleteTaskRequest",
                                                                              object: payload)
                }
            }
        }
    }
    
    func beginEditingForNewTask(task:Task) {
        if let tableView = tasksTableView {
            
            tableView.enumerateAvailableRowViewsUsingBlock({ (rowView, row) in
                if let cell = rowView.viewAtColumn(0) as? TaskCell {
                    if let cellTask = cell.task {
                        if cellTask.id == task.id {
                            self.tasksTableView?.scrollRowToVisible(row)
                            cell.textField?.enterEditing()
                        }
                    }
                }
            })
        }
    }

    @IBAction func addTaskButtonClicked(sender:AnyObject) {
        if let tl = selectedTaskList {
            let suffix = TaskListManager.shared.newTaskNameSuffix(tl)
            tl.addTask("New Task \(suffix)")
        }
    }
    
    // Notification Handlers
    
    func handleTaskListCreated(notif:NSNotification) {
        if let tl = selectedTaskList {
            if let firstTask = tl.tasks.reverse().first {
                beginEditingForNewTask(firstTask)
            }
        }
    }
    
    func handleTaskListRenamed(notif:NSNotification) {
        if let tl = selectedTaskList {
            listTitleLabel?.stringValue = tl.title.withoutUniquePart()
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
