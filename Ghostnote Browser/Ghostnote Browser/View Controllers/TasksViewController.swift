//
//  TodosViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/19/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class TasksViewController: NSViewController, ButtonNavigable {

    var taskListController = TaskListController()
    
    @IBOutlet weak var taskListTableView:NSTableView? {
        didSet {
            if let tv = taskListTableView {
                taskListController.taskListTableView = tv
            }
        }
    }
    
    @IBOutlet weak var addTaskListButton:NSButton? {
        didSet {
            if let button = addTaskListButton {
                taskListController.addListButton = button
            }
        }
    }
    
    @IBOutlet weak var deleteTaskListButton:NSButton? {
        didSet {
            if let button = deleteTaskListButton {
                taskListController.deleteListButton = button
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.autoresizingMask = [.ViewWidthSizable, .ViewHeightSizable]
    }
    
}
