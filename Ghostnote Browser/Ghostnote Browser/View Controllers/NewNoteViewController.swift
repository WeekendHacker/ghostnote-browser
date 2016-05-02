//
//  NewNoteViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/2/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa
protocol NewNoteViewControllerClient {
    func choseName(name:String)
    func canceled()
}

class NewNoteViewController: NSViewController {

    
    var client:NewNoteViewControllerClient?
    
    @IBOutlet weak var nameTextField:NSTextField?
    @IBOutlet weak var cancelButton:NSButton?
    @IBOutlet weak var createButton:NSButton?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createButton?.enabled = false
        
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()

    }
    // Validation logic
    
    
    func validateName() {
        if let name = nameTextField?.stringValue {
            
            if (nameTextField!.stringValue.isEmpty) {
                nameTextField?.stringValue = ""
                nameTextField?.placeholderAttributedString = NSAttributedString(string: "Name can't be blank!", attributes: [NSForegroundColorAttributeName : NSColor.redColor()])
                createButton?.enabled = false
                
            }else {
                if NoteNameValidator.nameExists(name) {
                    nameTextField?.stringValue = ""
                    nameTextField?.placeholderAttributedString = NSAttributedString(string: "Name exists!", attributes: [NSForegroundColorAttributeName : NSColor.redColor()])
                    createButton?.enabled = false
                }else {
                    createButton?.enabled = true
                }
            }
            
        }
    }
    
    
    // Actions
    
    @IBAction func createClicked(sender:AnyObject?) {
        client?.choseName(nameTextField!.stringValue)
    }
    
    @IBAction func cancelClicked(sender:AnyObject?) {
        client?.canceled()
    }
    
    // NSTextFieldDelegate
    
    override func controlTextDidChange(obj: NSNotification) {
        validateName()
    }

}
