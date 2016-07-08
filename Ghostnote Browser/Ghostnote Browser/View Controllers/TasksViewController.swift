//
//  TodosViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/19/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class TasksViewController: NSViewController, ButtonNavigable, TaskListControllerObserver, NSSplitViewDelegate {

    var taskListController = TaskListController()
    var taskController = TasksController()
    
    @IBOutlet weak var addTaskListButton:NSButton? {
        didSet {
           taskListController.addTaskListButton = addTaskListButton
        }
    }
    
    @IBOutlet weak var addTaskButton:NSButton? {
        didSet {
            taskController.addTaskButton = addTaskButton
        }
    }
    
    @IBOutlet weak var splitView:CustomSplitView?
    
    @IBOutlet weak var taskListTableView:DeletableTableView? {
        didSet {
            if let tv = taskListTableView {
                taskListController.taskListTableView = tv
                taskListController.observer = self
           }
        }
    }
    
    
    @IBOutlet weak var listTitleLabel:NSTextField? {
        didSet {
            taskController.listTitleLabel = listTitleLabel
        }
    }
    
    @IBOutlet weak var tasksTableView:DeletableTableView? {
        didSet {
            taskController.tasksTableView = tasksTableView
        }
    }

    
    // view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        title = "Tasks"
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleTaskListDeleteRequest(_:)),
                                                         name: "DeleteTaskListRequest",
                                                         object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleTaskDeletionRequest),
                                                         name: "DeleteTaskRequest",
                                                         object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleSelectTasksTableView),
                                                         name: "SelectTasksTableView",
                                                         object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleSelectTaskListTableView),
                                                         name: "SelectTaskListTableView",
                                                         object: nil)
        
        splitView?.dividerStyle = .Thin
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        splitView?.setPosition(160.0, ofDividerAtIndex: 0)
        selectFirstTaskList()
    }
    
    // Selection Automation
    func selectFirstTaskList() {
        if (TaskListManager.shared.taskLists.count > 0) {
            taskListTableView?.selectRowIndexes(NSIndexSet(index:0), byExtendingSelection: false)
            taskListTableView?.window?.makeFirstResponder(taskListTableView)
        }
    }
    
    func selectFirstTask() {
        if (taskListController.currentTaskList?.tasks.count > 0) {
            tasksTableView?.selectRowIndexes(NSIndexSet(index:0), byExtendingSelection: false)
            tasksTableView?.window?.makeFirstResponder(tasksTableView)
            taskController.tvAction(self)
        }
    }
    
    // NSSplitViewDelegate
    
    func splitView(splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        return 160.0
    }
    
    func splitView(splitView: NSSplitView, constrainMaxCoordinate proposedMaximumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        return 320.0
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        if let superView = view.superview {
            let top = NSLayoutConstraint(item: view,
                                         attribute: .Top,
                                         relatedBy: .Equal,
                                         toItem: superView,
                                         attribute: .Top,
                                         multiplier: 1.0,
                                         constant: 0.0)
            
            let left =  NSLayoutConstraint(item: view,
                                           attribute: .Left,
                                           relatedBy: .Equal,
                                           toItem: superView,
                                           attribute: .Left,
                                           multiplier: 1.0,
                                           constant: 0.0)
            
            let right =  NSLayoutConstraint(item: view,
                                            attribute: .Right,
                                            relatedBy: .Equal,
                                            toItem: superView,
                                            attribute: .Right,
                                            multiplier: 1.0,
                                            constant: 0.0)
            
            let bottom =  NSLayoutConstraint(item: view,
                                             attribute: .Bottom,
                                             relatedBy: .Equal,
                                             toItem: superView,
                                             attribute: .Bottom,
                                             multiplier: 1.0,
                                             constant: 0.0)
            
            superView.addConstraints([top, left, bottom, right])
            superView.layoutSubtreeIfNeeded()
        }
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
    
    // Notification Handlers
    func handleTaskListDeleteRequest(notif:NSNotification) {
        if let payload = notif.object as? Dictionary<String,AnyObject> {
            
            if let taskListToDelete = payload["taskListToDelete"] as? TaskList {
                if let hostingNoteCell = payload["hostingTaskListCell"] as? TaskListCell {
                    
                    let deleteVC = ConfirmDeleteViewController()
                    deleteVC.promptText = "Delete \(taskListToDelete.title.withoutUniquePart()) ?"
                    deleteVC.yesBlock = {
                        TaskListManager.shared.deleteTaskList(taskListToDelete.title)
                        self.dismissViewController(deleteVC)
                    }
                    
                    deleteVC.noBlock = {
                        self.dismissViewController(deleteVC)
                    }
                    
                    presentViewController(deleteVC,
                                          asPopoverRelativeToRect: hostingNoteCell.bounds,
                                          ofView: hostingNoteCell,
                                          preferredEdge: .MaxX,
                                          behavior: .Transient)
                }
            }
        }

    }
    
    func handleTaskDeletionRequest(notif:NSNotification) {
        
        if let payload = notif.object as? Dictionary<String,AnyObject> {
            if let hostingTaskCell = payload["hostingTaskCell"] as? TaskCell {
                if let containingTaskList = payload["containingTaskList"] as? TaskList {
                    if let taskToDelete = payload["taskToDelete"] as? Task {
                        
                        let deleteVC = ConfirmDeleteViewController()

                        deleteVC.promptText = "Delete \(taskToDelete.title.withoutUniquePart()) ?"
                        
                        deleteVC.yesBlock = {
                            containingTaskList.removeTask(taskToDelete)
                            self.dismissViewController(deleteVC)
                        }
                        
                        deleteVC.noBlock = {
                            self.dismissViewController(deleteVC)
                        }
                        
                        presentViewController(deleteVC,
                                              asPopoverRelativeToRect: hostingTaskCell.bounds,
                                              ofView: hostingTaskCell,
                                              preferredEdge: .MaxX,
                                              behavior: .Transient)
                        
                    }

                    }
            }

        }
    }
    
    func handleSelectTaskListTableView() {
        print("handleSelectTaskListTableView")
        selectFirstTaskList()
    }
    
    func handleSelectTasksTableView() {
        print("handleSelectTasksTableView")
        selectFirstTask()
    }
}
