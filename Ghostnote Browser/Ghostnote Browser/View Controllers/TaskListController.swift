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
            
                if let buttonNib = NSNib(nibNamed: "ButtonTableCellView", bundle: nil) {
                    tv.registerNib(buttonNib, forIdentifier: "ButtonTableCellView"  )
                }
                
                if let cellNib = NSNib(nibNamed: "TaskListCell", bundle: nil) {
                    tv.registerNib(cellNib, forIdentifier: "TaskListCell")
                }
            }
        }
    }

    // NSTableViewDatasource
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        
        if row == 0 {
            return 50.0
        }
        return 30.0
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        let count = TaskListManager.shared.taskLists.count + 1
        return count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if row == 0 {
            
            let view = taskListTableView?.makeViewWithIdentifier("ButtonTableCellView", owner: nil) as? ButtonTableCellView
            let buttonColor = NSColor(netHex: 0x3C75B8)
            let title = NSAttributedString(string: "Add Task List", attributes: [NSForegroundColorAttributeName : buttonColor])
            
            view?.button?.attributedTitle = title
            view?.button?.target = self
            view?.button?.action = #selector(addTaskListClicked)
            return view
        }
        
        let taskList = TaskListManager.shared.taskLists.reverse()[row - 1]
        
        let view = taskListTableView?.makeViewWithIdentifier("TaskListCell", owner: nil) as? TaskListCell
        view?.taskList = taskList
        return view
    }
    
    func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if row == 0 {
            return false
        }
        return true
    }
    
    // Actions
    func addTaskListClicked(sender:AnyObject?) {
        TaskListManager.shared.createTaskList("New Task List")
    }

    // DeleteRowDelegate
    func deleteRow(row: Int) {
        let selectedList = TaskListManager.shared.taskLists.reverse()[row - 1]
        TaskListManager.shared.deleteTaskList(selectedList.title)
    }

    func selected(sender:AnyObject?) {
        
        if let row = taskListTableView?.selectedRow where row >= 1 {
            let selectedTaskList = TaskListManager.shared.taskLists[row - 1]
            observer?.selectedList(selectedTaskList)
            currentTaskList = selectedTaskList
        }else {
            currentTaskList = nil
        }
        
        taskListTableView?.enumerateAvailableRowViewsUsingBlock({ (rowView, row) in
            if row > 0 {
                if let cell = rowView.viewAtColumn(0) as? SelectableCell {
                    cell.select(rowView.selected)
                }
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
