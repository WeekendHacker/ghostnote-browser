//
//  TaskTableViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/5/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class TaskTableViewController: NSObject, NSTableViewDataSource, NSTableViewDelegate {

    weak var selectedTaskList:TaskList? {
        didSet {
            if selectedTaskList != nil {
                tasksTableView?.reloadData()
            }
        }
    }
    
    weak var tasksTableView:NSTableView? {
        didSet {
            if let tv = tasksTableView {
                tv.setDelegate(self)
                tv.setDataSource(self)
            }
        }
    }
    
 
}
