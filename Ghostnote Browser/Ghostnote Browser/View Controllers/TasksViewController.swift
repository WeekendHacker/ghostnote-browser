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
            let color = NSColor(netHex:0x3C75B8)
            let title = NSAttributedString(string: "Add List",
                                           attributes: [NSFontSizeAttribute : 15.0,
                                            NSForegroundColorAttributeName : color])
            addTaskListButton?.attributedTitle = title
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
    
    @IBOutlet weak var tasksTableView:DeletableTableView? {
        didSet {
            taskController.tasksTableView = tasksTableView
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        title = "Tasks"
        
        splitView?.dividerStyle = .Thin
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        splitView?.setPosition(160.0, ofDividerAtIndex: 0)
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

    
    // Actions
    @IBAction func addTaskListClicked(sender:AnyObject?) {
        TaskListManager.shared.createTaskList("New Task List")
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
    

}
