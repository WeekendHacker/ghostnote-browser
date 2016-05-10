//
//  TaskTableViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/5/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class TasksController: NSObject, NSTableViewDataSource, NSTableViewDelegate, NewNamedItemViewControllerClient {

    var newTaskController: NewNamedItemViewController?
    var clientViewController: NSViewController?
    
    
    weak var selectedTaskList:TaskList? {
        didSet {
//            if selectedTaskList != nil {
                tasksTableView?.reloadData()
//            }
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
                button.enabled = false
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
        
        newTaskController = NewNamedItemViewController(nibName: nil, bundle: nil)
        newTaskController?.client = self
        newTaskController?.validator = TaskNameValidator.shared
        TaskNameValidator.shared.taskList = selectedTaskList
        newTaskController?.nameTextField?.placeholderString = "New Task List Name"
        
        clientViewController?.presentViewController(newTaskController!, asPopoverRelativeToRect: newTaskController!.view.frame, ofView: addTaskButton!, preferredEdge: NSRectEdge.MaxX, behavior: NSPopoverBehavior.Transient)
        
    }
    
    func deleteTaskButtonClicked(sender:AnyObject?) {
        if let row = tasksTableView?.selectedRowIndexes.firstIndex {
            let view = tasksTableView?.viewAtColumn(0, row: row, makeIfNecessary: false) as? TaskCell
            
            if let selectedTask = view?.task {
                
                if let taskList = selectedTaskList {
                    taskList.removeTask(selectedTask)
                }
                tasksTableView?.reloadData()
                deleteTaskButton?.enabled = false
            }
        }
    }
    
    // NewNamedItemViewControllerClient
    
    func choseName(name: String) {
       
        if let selected = selectedTaskList {
            selected.addTask(name)
            tasksTableView?.reloadData()
            dismissNewNamedItemController()
        }
    }
    
    func canceled() {
       dismissNewNamedItemController()
    }
    
    func dismissNewNamedItemController() {
        if let vc = newTaskController {
            clientViewController?.dismissViewController(vc)
            newTaskController = nil
        }
    }
    
    // 
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        if let tv = notification.object as? NSTableView {
            if tv.hasSelection() {
                deleteTaskButton?.enabled = true
            }else {
                deleteTaskButton?.enabled = false
            }
        }
    }
}
