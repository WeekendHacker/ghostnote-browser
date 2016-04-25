//
//  NotesViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/19/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class NotesViewController: NSViewController, ButtonNavigable {

    
// ButtonNavigable

    @IBOutlet var noteTextView:NSTextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.redColor().CGColor
        
        view.autoresizingMask = [.ViewWidthSizable, .ViewHeightSizable]
    }
    
    
    override func viewWillAppear() {
        

    }
    
    
    override func viewDidAppear() {
        super.viewDidAppear()
        sizeForContainer()
        noteTextView?.usesInspectorBar = true
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        noteTextView?.usesInspectorBar = false
    }
    
    
}
