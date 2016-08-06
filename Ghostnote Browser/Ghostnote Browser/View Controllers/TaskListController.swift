//
//  TaskListController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/3/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa
import SwiftyBeaver

protocol TaskListControllerObserver {
    func selectedList(taskList:TaskList)
    func selectedNoList()
}

class TaskListController: NSObject, NSTableViewDelegate, NSTableViewDataSource,
                          DeleteRowDelegate, InterTableKeyboardNavigationDelegate {
    
    let log = SwiftyBeaver.self
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleTaskListCreation), name: "CreatedTaskList", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleTaskListDeletion), name: "DeletedTaskList", object: nil)
        
        let console = ConsoleDestination()  // log to Xcode Console
        let file = FileDestination()  // log to default swiftybeaver.log file
        log.addDestination(console)
        log.addDestination(file)
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
            addTaskListButton?.toolTip = "Add List - command-l"
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
                tv.keyboardDelegate = self
                
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
        let suffix = TaskListManager.shared.newTaskListNameSuffix()
        
        TaskListManager.shared.createTaskList("New Task List \(suffix)")
    }
    

    // NSTableViewDatasource
    
    func tableView(tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        log.info("")
        let rowView = tableView.makeViewWithIdentifier("CustomRowView", owner: nil) as? NSTableRowView
        return rowView
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {

        return 25.0
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        
        if TaskListManager.shared.searchController.isSearching {
            let count = TaskListManager.shared.searchController.results.count
            return count
        }
        
        let count = TaskListManager.shared.taskLists.count
        return count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        log.info("")
        if TaskListManager.shared.searchController.isSearching {
            let taskList = TaskListManager.shared.searchController.results[row]
            
            let view = taskListTableView?.makeViewWithIdentifier("TaskListCell", owner: nil) as? TaskListCell
            view?.taskList = taskList
            return view
        }
        
        let taskList = TaskListManager.shared.taskLists.reverse()[row]
        
        let view = taskListTableView?.makeViewWithIdentifier("TaskListCell", owner: nil) as? TaskListCell
        view?.taskList = taskList
        return view
    }
    
    // DeleteRowDelegate
    func deleteRow(row: Int) {
        let selectedList:TaskList

        if TaskListManager.shared.searchController.isSearching {
            
            selectedList = TaskListManager.shared.searchController.results[row]
            
        }else {
            selectedList = TaskListManager.shared.taskLists.reverse()[row]
        }
        
        let hostingCell =  taskListTableView?.viewAtColumn(0, row: row, makeIfNecessary: false)
        
        var payload = Dictionary<String, AnyObject>()
        
        payload["taskListToDelete"] = selectedList
        payload["hostingTaskListCell"] = hostingCell
        
        NSNotificationCenter.defaultCenter().postNotificationName("DeleteTaskListRequest", object: payload)

    }


    func tableViewSelectionDidChange(notification: NSNotification) {
        if let row = taskListTableView?.selectedRow where row >= 0 {
            
            if TaskListManager.shared.searchController.isSearching {
                let selectedTaskList = TaskListManager.shared.searchController.results[row]
                observer?.selectedList(selectedTaskList)
                currentTaskList = selectedTaskList
            }else {
                let selectedTaskList = TaskListManager.shared.taskLists[row]
                observer?.selectedList(selectedTaskList)
                currentTaskList = selectedTaskList
            }

        }else {
            observer?.selectedNoList()
            currentTaskList = nil
        }
    }
    
    // InterTableKeyboardNavigationDelegate
    
    func leftArrow() {
        
    }
    
    func rightArrow() {
        NSNotificationCenter.defaultCenter().postNotificationName("SelectTasksTableView",
                                                                  object: nil)
    }
    
    func selectTaskList(taskList:TaskList) {
        
        if let tableView = taskListTableView {
            
            tableView.enumerateAvailableRowViewsUsingBlock({ (rowView, row) in
                if let cell = rowView.viewAtColumn(0) as? TaskListCell {
                    if let cellTaskList = cell.taskList {
                        if cellTaskList.id == taskList.id {
                            tableView.scrollRowToVisible(row)
                            tableView.selectRowIndexes(NSIndexSet(index:row), byExtendingSelection: false)
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
        
        if let tl = notif.object as? TaskList {
            performSelector(#selector(selectTaskList(_:)),
                            withObject:tl,
                            afterDelay: 0.1)
        }
        
    }
    
    func handleTaskListDeletion() {
        taskListTableView?.reloadData()
    }
}
