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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleTaskListDeletion), name: "DeletedTaskList", object: nil)
    }
    
    var observer:TaskListControllerObserver?

    var currentTaskList:TaskList? {
        didSet {

            NSNotificationCenter.defaultCenter().postNotificationName("CurrentTaskListChanged", object: currentTaskList)
        }
    }
    
    
    weak var addTaskListButton:NSButton? {
        didSet {

            addTaskListButton?.action = #selector(addTaskListButtonClicked(_:))
            addTaskListButton?.target = self
        }
    }
    
    weak var taskListTableView:DeletableTableView? {
        didSet {
            if let tv = taskListTableView {
                tv.setDelegate(self)
                tv.setDataSource(self)
                tv.wantsLayer = true
                tv.selectionHighlightStyle = .Regular
                tv.allowsTypeSelect = true
                tv.deleteDelegate = self

                if let cellNib = NSNib(nibNamed: "TaskListCell", bundle: nil) {
                    tv.registerNib(cellNib, forIdentifier: "TaskListCell")
                }
                
                if let rowViewNib = NSNib(nibNamed: "CustomRowView", bundle: nil) {
                    tv.registerNib(rowViewNib, forIdentifier: "CustomRowView")
                }
            }
        }
    }
    
    // Actions
    @IBAction func addTaskListButtonClicked(sender:AnyObject?) {
        TaskListManager.shared.createTaskList("New Task List")
    }
    

    // NSTableViewDatasource
    
    func tableView(tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let rowView = tableView.makeViewWithIdentifier("CustomRowView", owner: nil) as? NSTableRowView
        return rowView
    }
    
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

    // DeleteRowDelegate
    func deleteRow(row: Int) {
        let selectedList = TaskListManager.shared.taskLists.reverse()[row]
        TaskListManager.shared.deleteTaskList(selectedList.title)
    }


    func tableViewSelectionDidChange(notification: NSNotification) {
        if let row = taskListTableView?.selectedRow where row >= 0 {
            let selectedTaskList = TaskListManager.shared.taskLists[row]
            observer?.selectedList(selectedTaskList)
            currentTaskList = selectedTaskList
        }else {
            observer?.selectedNoList()
            currentTaskList = nil
        }
    }
    
    
    func beginEditingForNewTaskList(newTaskList:TaskList) {
        
        // should maybe get to a protocol and extension
        // for this maybe a CRUD tv controller with the HasIDString on the comparision below
        
        if let tableView = taskListTableView {
            
            tableView.enumerateAvailableRowViewsUsingBlock({ (rowView, row) in
                if let cell = rowView.viewAtColumn(0) as? TaskListCell {
                    if let cellTaskList = cell.taskList {
                        if cellTaskList.id == newTaskList.id {
                            tableView.scrollRowToVisible(row)
                            tableView.selectRowIndexes(NSIndexSet(index:row), byExtendingSelection: false)
                            cell.textField?.enterEditing()
                        }else {
                            cell.select(false)
                        }
                    }
                }
            })
        }
    }
    
    // Notification Handlers
    
    func handleTaskListCreation(notif:NSNotification) {
        taskListTableView?.reloadData()
        
        performSelector(#selector(beginEditingForNewTaskList(_:)),
                        withObject: notif.object as! TaskList,
                        afterDelay: 0.3)
    }
    
    func handleTaskListDeletion() {
        taskListTableView?.reloadData()
    }
}
