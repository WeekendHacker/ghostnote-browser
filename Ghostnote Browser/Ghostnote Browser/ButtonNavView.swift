//
//  ButtonNavView.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/19/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa


protocol ButtonNavViewObserver {
    func selectedNotes()
    func selectedTodos()
    func selectedGhostnotes()
}

class ButtonNavView: NSView {

    @IBOutlet weak var notesButton:NSButton?
    @IBOutlet weak var todosButton:NSButton?
    @IBOutlet weak var ghostnotesButton:NSButton?
    
    var activeButton:NSButton?
    
    var observer:ButtonNavViewObserver?
    
    @IBAction func notesButtonClicked(sender:AnyObject?) {
        activeButton = notesButton
        updateButtonStates()
        observer?.selectedNotes()
    }
    
    @IBAction func todosButtonClicked(sender:AnyObject?) {
        activeButton = todosButton
        updateButtonStates()
        observer?.selectedTodos()
    }
    
    @IBAction func ghostnotesButtonClicked(sender:AnyObject?) {
        activeButton = ghostnotesButton
        updateButtonStates()
        observer?.selectedGhostnotes()
    }
    
    func updateButtonStates() {
        
        if activeButton == notesButton {
            notesButton?.image = NSImage(named: "Notes-Active")
            todosButton?.image = NSImage(named:"Task-Inactive")
            ghostnotesButton?.image = NSImage(named:"GhostNote-Inactive")
            
        }else if activeButton == todosButton {
            notesButton?.image = NSImage(named: "Notes-Inactive")
            todosButton?.image = NSImage(named:"Task-Active")
            ghostnotesButton?.image = NSImage(named:"GhostNote-Inactive")

        }else if activeButton == ghostnotesButton {
            notesButton?.image = NSImage(named: "Notes-Inactive")
            todosButton?.image = NSImage(named:"Task-Inactive")
            ghostnotesButton?.image = NSImage(named:"GhostNote-Active")

        }
    
    }
    
}
