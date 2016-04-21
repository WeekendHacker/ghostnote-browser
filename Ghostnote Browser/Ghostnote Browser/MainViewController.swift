//
//  MainViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/21/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController, ButtonNavObserver {

    @IBOutlet var buttonNav:ButtonNavViewController?
    @IBOutlet var contentView:NSView?
    
    @IBOutlet var notesController:NotesViewController?
    @IBOutlet var tasksController:TasksViewController?
    @IBOutlet var ghostnotesController:GhostnotesViewController?
    
    var currentContentVC:NSViewController? { willSet {
            if let current = currentContentVC {
                current.view.removeFromSuperview()

            }
        }
        didSet {
            if let current = currentContentVC {
                contentView!.addSubview(current.view)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonNav?.navObserver = self
    }
    
    // ButtonNavObserver
    
    func selectedNotes() {
        performSegueWithIdentifier("EmbedNotes", sender: self)
    }
    
    func selectedTasks() {
        performSegueWithIdentifier("EmbedTasks", sender: self)
    }
    
    func selectedGhostnotes() {
        performSegueWithIdentifier("EmbedGhostnotes", sender: self)
    }
 
    
    //
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if let identifier = segue.identifier {
            if identifier == "EmbedButtonNav" {
                if buttonNav == nil {
                    buttonNav = segue.destinationController as? ButtonNavViewController
                    buttonNav?.navObserver = self
                }
            }else if identifier == "EmbedNotes" {
                if notesController == nil {
                    notesController = segue.destinationController as? NotesViewController
                }
                if !(currentContentVC == notesController) {
                    transitionToNotes()
                }

            }else if identifier == "EmbedTasks"  {
                if tasksController == nil {
                    tasksController = segue.destinationController as? TasksViewController
                }
                if !(currentContentVC == tasksController) {
                    transitionToTasks()
                }
            }else if identifier == "EmbedGhostnotes" {
                if ghostnotesController == nil {
                    ghostnotesController = segue.destinationController as? GhostnotesViewController
                }
                if !(currentContentVC == ghostnotesController) {
                    transitionToGhostnotes()
                }
            }
        }
    }
    
    // 
    
    func transitionToNotes() {
        print(notesController)
        currentContentVC = notesController
    }
    
    func transitionToTasks() {
        print(tasksController)
        currentContentVC = tasksController
    }
    
    func transitionToGhostnotes() {

        print(ghostnotesController)
        currentContentVC = ghostnotesController
    }
}
