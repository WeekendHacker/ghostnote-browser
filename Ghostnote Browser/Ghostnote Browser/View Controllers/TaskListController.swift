//
//  TaskListController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/3/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class TaskListController: NSObject, NSTableViewDelegate, NSTableViewDataSource, NewNamedItemViewControllerClient {

    var newTaskListController:NewNamedItemViewController?
    var clientViewController:NSViewController?
    
    weak var taskListTableView:NSTableView? {
        didSet {
            if let tv = taskListTableView {
                tv.setDelegate(self)
                tv.setDataSource(self)
                tv.wantsLayer = true
                tv.selectionHighlightStyle = .Regular
                
                let buttonNib = NSNib(nibNamed: "ButtonTableCellView", bundle: nil)
                tv.registerNib(buttonNib, forIdentifier: "ButtonTableCellView"  )
            }
        }
    }
    
    weak var addTaskListButton:NSButton? {
        didSet {
            if let button = addTaskListButton {
                button.target = self
                button.action = #selector(TaskListController.addTaskListClicked(_:))
            }
        }
    }
    
    weak var deleteTaskListButton:NSButton? {
        didSet {
            if let button = deleteTaskListButton {
                button.target = self
                button.action = #selector(TaskListController.deleteTaskListClicked(_:))
            }
        }
    }
    
    
    
    // NSTableViewDatasource
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return TaskListManager.shared.taskLists.count + 1
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if row == 0 {
            
            let view = taskListTableView?.makeViewWithIdentifier("ButtonTableCellView", owner: nil) as? ButtonTableCellView
            let title = NSAttributedString(string: "+ Add Task List", attributes: [NSForegroundColorAttributeName : NSColor.blueColor()])
            view?.button?.attributedTitle = title
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
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        
        let tv = notification.object as? NSTableView
        
        
        tv?.enumerateAvailableRowViewsUsingBlock({ (view, row) in
            
            let cell = view.subviews.first as? TaskListCell
            if view.selected == true {
                cell?.textField?.textColor = NSColor.blueColor()
                
            }else {
                cell?.textField?.textColor = NSColor.blackColor()
                
                
            }
            
        })
        NSNotificationCenter.defaultCenter().postNotificationName("SelectedTaskChanged", object: notification.object)
    }

    
    
    // Actions
    
    @IBAction func addTaskListClicked(sender:AnyObject?) {
        newTaskListController = NewNamedItemViewController(nibName: nil, bundle: nil)
        newTaskListController?.client = self
        newTaskListController?.validator = TaskListNameValidator.shared
        newTaskListController?.nameTextField?.placeholderString = "New Task List Name"
        
        clientViewController?.presentViewController(newTaskListController!, asPopoverRelativeToRect: newTaskListController!.view.frame, ofView: addTaskListButton!, preferredEdge: NSRectEdge.MaxX, behavior: NSPopoverBehavior.Transient)
    }
    
    @IBAction func deleteTaskListClicked(sender:AnyObject?)  {
        
        if let row = taskListTableView?.selectedRowIndexes.firstIndex {
            let view = taskListTableView?.viewAtColumn(0, row: row, makeIfNecessary: false) as? TaskListCell
            
            if let selectedTaskList = view?.taskList {
                print("selected \(selectedTaskList) to delete.")
                TaskListManager.shared.deleteTaskList(selectedTaskList.title)
                taskListTableView?.reloadData()
                deleteTaskListButton?.enabled = false
            }
        }
    }
    
    
    // NewNamedItemViewControllerClient
    
    func choseName(name: String) {
        print("chose \(name)")
        TaskListManager.shared.createTaskList(name)
        taskListTableView?.reloadData()
        dismissNewNamedItemController()
    }
    
    func canceled() {
        print("canceled")
        dismissNewNamedItemController()
    }
    
    func dismissNewNamedItemController() {
        if let vc = newTaskListController {
            clientViewController?.dismissViewController(vc)
            newTaskListController = nil
        }
    }
}
