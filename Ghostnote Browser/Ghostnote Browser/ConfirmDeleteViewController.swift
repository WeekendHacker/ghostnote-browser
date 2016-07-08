//
//  ConfirmDeleteViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 6/27/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa


class ConfirmDeleteViewController: NSViewController {

    @IBOutlet weak var yesButton:NSButton?
    @IBOutlet weak var noButton:NSButton?
    @IBOutlet weak var promptLabel:NSTextField?
    
    var promptText:String = "Delete Me?" {
        didSet {
            promptLabel?.stringValue = promptText
        }
    }
    
    var yesBlock:(() -> Void)?
    var noBlock:(() -> Void)?
    
    @IBAction func yesClicked(sender:AnyObject?) {
        yesBlock!()
    }
    
    @IBAction func noClicked(sender:AnyObject?) {
        noBlock!()
    }
    
    override func viewDidAppear() {
        promptLabel?.stringValue = promptText
    }
}
