//
//  TaskListController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/3/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class TaskListController: NSObject, NSTableViewDelegate, NSTableViewDataSource, DeleteRowDelegate {

    
    weak var taskListTableView:DeletableTableView? {
        didSet {
            if let tv = taskListTableView {
                tv.setDelegate(self)
                tv.setDataSource(self)
                tv.wantsLayer = true
                tv.selectionHighlightStyle = .Regular
                tv.deleteDelegate = self
                let buttonNib = NSNib(nibNamed: "ButtonTableCellView", bundle: nil)
                tv.registerNib(buttonNib, forIdentifier: "ButtonTableCellView"  )
            }
        }
    }
    

    

    
    
    
    // NSTableViewDatasource
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        let count = TaskListManager.shared.taskLists.count + 1
        print("returning \(count)")
        return count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if row == 0 {
            
            let view = taskListTableView?.makeViewWithIdentifier("ButtonTableCellView", owner: nil) as? ButtonTableCellView
            let title = NSAttributedString(string: "+ Add Task List", attributes: [NSForegroundColorAttributeName : NSColor.blueColor()])
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
    
    // NSTableViewDelegate 
    
 

    // Actions
    
    @IBAction func addTaskListClicked(sender:AnyObject?) {
        newTaskList()
    }
    
    @IBAction func deleteTaskListClicked(sender:AnyObject?)  {
        
        if let row = taskListTableView?.selectedRowIndexes.firstIndex {
            let view = taskListTableView?.viewAtColumn(0, row: row, makeIfNecessary: false) as? TaskListCell
            
            if let selectedTaskList = view?.taskList {
                print("selected \(selectedTaskList) to delete.")
                TaskListManager.shared.deleteTaskList(selectedTaskList.title)
                taskListTableView?.reloadData()
            }
        }
    }
    
    func newTaskList() {
        let uniquePart = "\(NSDate().timeIntervalSince1970)"
        TaskListManager.shared.createTaskList("New Task List" + " \(uniquePart)")
        taskListTableView?.reloadData()
    }

    func deleteRow(row: Int) {
        let selectedList = TaskListManager.shared.taskLists[row - 1]
        TaskListManager.shared.deleteTaskList(selectedList.title)
        taskListTableView?.reloadData()
    }
    
    
}
