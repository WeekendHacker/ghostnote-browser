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
    func currentListChanged()
}

class TaskListController: NSObject, NSTableViewDelegate, NSTableViewDataSource,
                          DeleteRowDelegate, KeyboardCreationDelegate {
    
    var observer:TaskListControllerObserver?

    weak var taskListTableView:DeletableTableView? {
        didSet {
            if let tv = taskListTableView {
                tv.setDelegate(self)
                tv.setDataSource(self)
                tv.wantsLayer = true
                tv.selectionHighlightStyle = .Regular
                
                tv.deleteDelegate = self
                tv.createDelegate = self
                tv.target = self
                tv.action = #selector(selected)
            
                let buttonNib = NSNib(nibNamed: "ButtonTableCellView", bundle: nil)
                tv.registerNib(buttonNib, forIdentifier: "ButtonTableCellView"  )
                let cellNib = NSNib(nibNamed: "TaskListCell", bundle: nil)
                tv.registerNib(cellNib, forIdentifier: "TaskListCell")
            }
        }
    }

    // NSTableViewDatasource
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30.0
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        let count = TaskListManager.shared.taskLists.count + 1
        return count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if row == 0 {
            
            let view = taskListTableView?.makeViewWithIdentifier("ButtonTableCellView", owner: nil) as? ButtonTableCellView
            let title = NSAttributedString(string: "Add Task List", attributes: [NSForegroundColorAttributeName : NSColor.blueColor()])
            view?.button?.attributedTitle = title
            view?.button?.target = self
            view?.button?.action = #selector(addTaskListClicked)
            return view
        }
        
        let taskList = TaskListManager.shared.taskLists[row - 1]
        
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
        let uniquePart = "\(NSDate().timeIntervalSince1970)"
        TaskListManager.shared.createTaskList("New Task List" + "<!\(uniquePart)>")
        taskListTableView?.reloadData()
    }

    // DeleteRowDelegate
    func deleteRow(row: Int) {
        let selectedList = TaskListManager.shared.taskLists[row - 1]
        TaskListManager.shared.deleteTaskList(selectedList.title)
        taskListTableView?.reloadData()
    }
    
    // KeyboardCreationDelegate
    func createKeyPressed(row: Int) {
        let selectedList = TaskListManager.shared.taskLists[row - 1]
        let uniquePart = NSDate().timeIntervalSince1970
        selectedList.addTask("New Task <!\(uniquePart)>")
        observer?.currentListChanged()
    }
    
    func selected(sender:AnyObject?) {
        if let row = taskListTableView?.selectedRow {
            let selectedTaskList = TaskListManager.shared.taskLists[row - 1]
            observer?.selectedList(selectedTaskList)
        }
    }
}
