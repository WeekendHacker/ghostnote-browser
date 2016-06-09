//
//  TodosViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/19/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class TasksViewController: NSViewController, ButtonNavigable, TaskListControllerObserver {

    var taskListController = TaskListController()
    var taskController = TasksController()
    
    @IBOutlet weak var taskListTableView:DeletableTableView? {
        didSet {
            if let tv = taskListTableView {
                taskListController.taskListTableView = tv
                taskListController.observer = self
           }
        }
    }
    
    @IBOutlet weak var tasksTableView:DeletableTableView? {
        didSet {
            taskController.tasksTableView = tasksTableView
        }
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.autoresizingMask = [.ViewWidthSizable, .ViewHeightSizable]

        let nib = NSNib(nibNamed: "TaskCell", bundle: nil)
        tasksTableView?.registerNib(nib, forIdentifier: "TaskCell")
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        sizeForContainer()
    }
    
    // TaskListControllerObserver
    
    func selectedList(taskList: TaskList) {
        
        if taskListTableView!.hasSelection() {
            if let row = taskListTableView?.selectedRowIndexes.firstIndex {
                let view = taskListTableView?.viewAtColumn(0, row: row, makeIfNecessary: false) as? TaskListCell
                
                if let selectedTaskList = view?.taskList {
                    print("selected \(selectedTaskList)")
                    taskController.selectedTaskList = selectedTaskList
                }
            }
        }else {
            selectedNoList()
        }
    }
    
    func selectedNoList() {
        taskController.selectedTaskList = nil
    }
    
    func currentListChanged() {
        tasksTableView?.reloadData()
    }
    
}
