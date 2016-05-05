//
//  TaskListController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/3/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class TaskListController: NSObject, NSTableViewDelegate, NSTableViewDataSource, NewNamedItemViewControllerClient {

    var newTaskController:NewNamedItemViewController?
    var clientViewController:NSViewController?
    
    weak var taskListTableView:NSTableView? {
        didSet {
            if let tv = taskListTableView {
                tv.setDelegate(self)
                tv.setDataSource(self)
            }
        }
    }
    
    weak var addTaskListButton:NSButton? {
        didSet {
            if let button = addTaskListButton {
                button.target = self
                button.action = #selector(TaskListController.addTaskListClicked(_:))
            }
        }
    }
    
    weak var deleteTaskListButton:NSButton? {
        didSet {
            if let button = deleteTaskListButton {
                button.target = self
                button.action = #selector(TaskListController.deleteTaskClicked(_:))
            }
        }
    }
    
    
    // NSTableViewDatasource
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return TaskListManager.shared.taskLists.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let taskList = TaskListManager.shared.taskLists[row]
        
        let view = taskListTableView?.makeViewWithIdentifier("TaskListCell", owner: nil) as? TaskListCell
        view?.taskList = taskList
        return view
    }
    
    
    // NSTableViewDelegate 
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        
        NSNotificationCenter.defaultCenter().postNotificationName("SelectedTaskChanged", object: notification.object)
    }
    
    
    // Actions
    
    @IBAction func addTaskListClicked(sender:AnyObject?) {
        newTaskController = NewNamedItemViewController(nibName: nil, bundle: nil)
        newTaskController?.client = self
        newTaskController?.validator = TaskListNameValidator.shared
        newTaskController?.nameTextField?.placeholderString = "New Task List Name"
        
        clientViewController?.presentViewController(newTaskController!, asPopoverRelativeToRect: addTaskListButton!.frame, ofView: addTaskListButton!, preferredEdge: NSRectEdge.MaxX, behavior: NSPopoverBehavior.Transient)
    }
    
    @IBAction func deleteTaskClicked(sender:AnyObject?)  {
        
        if let row = taskListTableView?.selectedRowIndexes.firstIndex {
            let view = taskListTableView?.viewAtColumn(0, row: row, makeIfNecessary: false) as? TaskListCell
            
            if let selectedTaskList = view?.taskList {
                print("selected \(selectedTaskList) to delete.")
                TaskListManager.shared.deleteTaskList(selectedTaskList.listName)
                taskListTableView?.reloadData()
                deleteTaskListButton?.enabled = false
            }
        }
    }
    
    
    // NewNamedItemViewControllerClient
    
    func choseName(name: String) {
        print("chose \(name)")
        TaskListManager.shared.createTaskList(name)
        taskListTableView?.reloadData()
        dismissNewNamedItemController()
    }
    
    func canceled() {
        print("canceled")
        dismissNewNamedItemController()
    }
    
    func dismissNewNamedItemController() {
        if let vc = newTaskController {
            clientViewController?.dismissViewController(vc)
            newTaskController = nil
        }
    }
}
