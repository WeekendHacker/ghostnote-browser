//
//  ButtonNavViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/21/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

@objc protocol ButtonNavObserver {
    func selectedNotes()
    func selectedTasks()
    func selectedGhostnotes()
}


class ButtonNavViewController: NSViewController {

    @IBOutlet weak var notesButton:NSButton?
    @IBOutlet weak var todosButton:NSButton?
    @IBOutlet weak var ghostnotesButton:NSButton?
    @IBOutlet weak var navObserver:ButtonNavObserver?
    
    
    // View Lifecylce
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded button nav VC")
    }
    
    
    // Actions
    
    @IBAction func notesButtonClicked(sender:AnyObject?) {
        navObserver?.selectedNotes()
    }
    
    @IBAction func tasksButtonClicked(sender:AnyObject?) {
        navObserver?.selectedTasks()
    }
    
    @IBAction func ghostnotesButtonClicked(sender:AnyObject?) {
        navObserver?.selectedGhostnotes()
    }
}
