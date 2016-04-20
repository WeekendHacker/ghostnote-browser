//
//  MainWindowController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/18/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, ButtonNavViewObserver {

    @IBOutlet weak var navView:ButtonNavView? { didSet {
            navView?.observer = self
        }
    }
    
    @IBOutlet weak var activityView:NSView?
    
    
    var notesController:NotesViewController? { didSet {
        
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        let appearance = NSAppearance(named: NSAppearanceNameVibrantLight)
        window?.appearance = appearance
        window?.contentView?.appearance = appearance
        
        notesController = NotesViewController(nibName: "NotesViewController", bundle: nil)
    }
    
    // ButtonNavViewObserver
    
    func selectedNotes() {
        self.activityView?.addSubview((notesController?.view)!)
        print("")
    }
    
    func selectedTodos() {
        
    }
    
    func selectedGhostnotes() {
        
    }

}
