//
//  TodosViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/19/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class TasksViewController: NSViewController, ButtonNavigable {

    var taskListController = TaskListController()
    var taskController = TasksController()
    
    @IBOutlet weak var taskListTableView:NSTableView? {
        didSet {
            if let tv = taskListTableView {
                taskListController.taskListTableView = tv
           }
        }
    }
    
    @IBOutlet weak var tasksTableView:NSTableView? {
        didSet {
            taskController.tasksTableView = tasksTableView
        }
    }
    
    @IBOutlet weak var addTaskListButton:NSButton? {
        didSet {
            taskListController.addTaskListButton = addTaskListButton
        }
    }
    
    @IBOutlet weak var deleteTaskListButton:NSButton? {
        didSet {
            taskListController.deleteTaskListButton = deleteTaskListButton
        }
    }
    
    
    @IBOutlet weak var addTaskButton:NSButton? {
        didSet {
            if let button = addTaskButton {
                taskController.addTaskButton = button
            }
        }
    }
    
    @IBOutlet weak var deleteTaskButton:NSButton? {
        
        didSet {
            if let button = deleteTaskButton {
                taskController.deleteTaskButton = button
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.autoresizingMask = [.ViewWidthSizable, .ViewHeightSizable]
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(taskListSelected(_:)), name: "SelectedTaskChanged", object: nil)
        deleteTaskListButton?.enabled = false
        let nib = NSNib(nibNamed: "TaskCell", bundle: nil)
        tasksTableView?.registerNib(nib, forIdentifier: "TaskCell")
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        taskListController.clientViewController = self
        taskController.clientViewController = self
        sizeForContainer()
        deleteTaskButton?.enabled = false
    }
    
    override func presentViewController(viewController: NSViewController, asPopoverRelativeToRect positioningRect: NSRect, ofView positioningView: NSView, preferredEdge: NSRectEdge, behavior: NSPopoverBehavior) {
        super.presentViewController(viewController, asPopoverRelativeToRect: positioningRect, ofView: positioningView, preferredEdge: preferredEdge, behavior: behavior)
    }
    
    // Notification Handlers
    
    func taskListSelected(notif:NSNotification) {
        
        if taskListTableView!.hasSelection() {
            deleteTaskListButton?.enabled = true
            if let row = taskListTableView?.selectedRowIndexes.firstIndex {
                let view = taskListTableView?.viewAtColumn(0, row: row, makeIfNecessary: false) as? TaskListCell
                
                if let selectedTaskList = view?.taskList {
                    print("selected \(selectedTaskList)")
                    taskController.selectedTaskList = selectedTaskList
                }
            }
        }else {
            taskController.selectedTaskList = nil

            deleteTaskListButton?.enabled = false
        }
    }
    
    func taskSelected(notif:NSNotification) {
        
        if let tv = tasksTableView {
            if tv.hasSelection() {
                deleteTaskButton?.enabled = true
            }else {
                deleteTaskButton?.enabled = false
            }

        }
    }
        
}
