//
//  TaskListController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/3/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

protocol TaskListControllerObserver {
    func selectedList(taskList:TaskList)
    func selectedNoList()
}

class TaskListController: NSObject, NSTableViewDelegate, NSTableViewDataSource,
                          DeleteRowDelegate {
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleTaskListCreation), name: "CreatedTaskList", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleTaskListCreation), name: "DeletedTaskList", object: nil)
    }
    
    var observer:TaskListControllerObserver?

    var currentTaskList:TaskList? {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName("CurrentTaskListChanged", object: currentTaskList)
        }
    }
    
    weak var taskListTableView:DeletableTableView? {
        didSet {
            if let tv = taskListTableView {
                tv.setDelegate(self)
                tv.setDataSource(self)
                tv.wantsLayer = true
                tv.selectionHighlightStyle = .None
                
                tv.deleteDelegate = self

                tv.target = self
                tv.action = #selector(selected)

                if let cellNib = NSNib(nibNamed: "TaskListCell", bundle: nil) {
                    tv.registerNib(cellNib, forIdentifier: "TaskListCell")
                }
            }
        }
    }

    // NSTableViewDatasource
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {

        return 30.0
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        let count = TaskListManager.shared.taskLists.count
        return count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let taskList = TaskListManager.shared.taskLists.reverse()[row]
        
        let view = taskListTableView?.makeViewWithIdentifier("TaskListCell", owner: nil) as? TaskListCell
        view?.taskList = taskList
        return view
    }
    
    // Actions
    func addTaskListClicked(sender:AnyObject?) {
        TaskListManager.shared.createTaskList("New Task List")
    }

    // DeleteRowDelegate
    func deleteRow(row: Int) {
        let selectedList = TaskListManager.shared.taskLists.reverse()[row]
        TaskListManager.shared.deleteTaskList(selectedList.title)
    }

    func selected(sender:AnyObject?) {
        
        if let row = taskListTableView?.selectedRow {
            let selectedTaskList = TaskListManager.shared.taskLists[row]
            observer?.selectedList(selectedTaskList)
            currentTaskList = selectedTaskList
        }else {
            currentTaskList = nil
        }
        
        taskListTableView?.enumerateAvailableRowViewsUsingBlock({ (rowView, row) in
            if let cell = rowView.viewAtColumn(0) as? SelectableCell {
                cell.select(rowView.selected)
            }
        })
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        selected(self)
    }
    
    // Notification Handlers
    
    func handleTaskListCreation() {
        taskListTableView?.reloadData()
    }
    
    func handleTaskListDeletion() {
        taskListTableView?.reloadData()
    }
}
