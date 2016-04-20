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
    
    override func windowDidLoad() {
        super.windowDidLoad()
        let appearance = NSAppearance(named: NSAppearanceNameVibrantLight)
        window?.appearance = appearance
        window?.contentView?.appearance = appearance
    }
    
    // ButtonNavViewObserver
    
    func selectedNotes() {
        
    }
    
    func selectedTodos() {
        
    }
    
    func selectedGhostnotes() {
        
    }

}
