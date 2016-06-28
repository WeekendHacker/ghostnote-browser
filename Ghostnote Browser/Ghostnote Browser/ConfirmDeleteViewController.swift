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

    
    var yesBlock:(() -> Void)?
    var noBlock:(() -> Void)?
    
    @IBAction func yesClicked(sender:AnyObject?) {
        yesBlock!()
    }
    
    @IBAction func noClicked(sender:AnyObject?) {
        noBlock!()
    }
}
