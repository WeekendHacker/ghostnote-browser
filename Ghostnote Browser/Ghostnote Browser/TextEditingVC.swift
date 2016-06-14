//
//  TextEditingVC.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 6/13/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

protocol TextEditingVCClient {
    func choseText(text:String)
}

class TextEditingVC: NSViewController {

    @IBOutlet var textView:NSTextView?
    @IBOutlet weak var doneButton:NSButton?
    @IBOutlet weak var cancelButton:NSButton?
    
    var client:TextEditingVCClient?
    
    var currentTitle:String = ""
    
    @IBAction func cancelButton(sender:AnyObject) {
        presentingViewController?.dismissController(self)
    }
    
    @IBAction func doneButtonClicked(sender:AnyObject) {
        
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        let string = NSAttributedString(string: currentTitle)
        textView?.textStorage?.appendAttributedString(string)
    }
}
