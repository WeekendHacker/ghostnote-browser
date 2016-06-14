//
//  TodosViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/19/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class TasksViewController: NSViewController, ButtonNavigable, TaskListControllerObserver, TextEditingVCClient {

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
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleEditTaskTitle(_:)),
                                                         name: "EditTaskTitle",
                                                         object: nil)
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
    
    // Notifcation HAndlers
    
    func handleEditTaskTitle(notifcation:NSNotification) {
        
        if let taskCell = notifcation.object as? TaskCell {
            if let task = taskCell.task {
                if let editButton = taskCell.editButton {
                    
                    let editVC = TextEditingVC(nibName: "TextEditingVC",
                                               bundle: nil)
                    editVC?.client = self
                    editVC?.currentTitle = task.title
                    
                    presentViewController(editVC!,
                                          asPopoverRelativeToRect: editButton.bounds,
                                          ofView: editButton,
                                          preferredEdge: .MaxY,
                                          behavior: .ApplicationDefined)
                }

            }
        }
    }
    
    func choseText(text: String) {
        print("chose \(text)")
    }
}
