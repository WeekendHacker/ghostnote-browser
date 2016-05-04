//
//  NewTaskListViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/4/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

protocol NewTaskListViewControllerClient {
    func choseName(name:String)
    func canceled()
}

class NewTaskListViewController: NSViewController {

    @IBOutlet weak var listNameTextField:NSTextField?
    @IBOutlet weak var cancelButton:NSButton?
    @IBOutlet weak var createButton:NSButton?
    @IBOutlet weak var errorLabel:NSTextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
