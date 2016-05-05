//
//  TodosViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/19/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class TasksViewController: NSViewController, ButtonNavigable, NewNamedItemViewControllerClient {

    var taskListController = TaskListTableViewController()
    var taskController = TaskTableViewController()
    
    var newTaskController:NewNamedItemViewController?
    
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
    
    @IBOutlet weak var addTaskListButton:NSButton?
    @IBOutlet weak var deleteTaskListButton:NSButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.autoresizingMask = [.ViewWidthSizable, .ViewHeightSizable]
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(taskListSelected(_:)), name: "SelectedTaskChanged", object: nil)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        sizeForContainer()
    }
    
    @IBAction func addTaskClicked(sender:AnyObject?) {
        newTaskController = NewNamedItemViewController(nibName: nil, bundle: nil)
        newTaskController?.client = self
        newTaskController?.validator = TaskListNameValidator.shared
        newTaskController?.nameTextField?.placeholderString = "New Task List Name"
        
        self.presentViewController(newTaskController!, asPopoverRelativeToRect: addTaskListButton!.frame, ofView: addTaskListButton!, preferredEdge: NSRectEdge.MaxX, behavior: NSPopoverBehavior.Transient)
    }
    
    @IBAction func deleteTaskClicked(sender:AnyObject?)  {
        
    }
    
    // NewNamedItemViewControllerClient
    
    func choseName(name: String) {
        print("chose \(name)")
        TaskListManager.shared.createTaskList(name)
        taskListTableView?.reloadData()
    }
    
    func canceled() {
        if let vc = newTaskController {
            dismissController(vc)
            newTaskController = nil
        }
    }
    
    // Notification Handlers
    
    func taskListSelected(notif:NSNotification) {
        taskController.selectedTaskList = 
    }
    
}
