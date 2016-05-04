//
//  NewNoteViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/2/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa
protocol NewNamedItemViewControllerClient {
    func choseName(name:String)
    func canceled()
}

class NewNoteViewController: NSViewController {

    
    var client:NewNamedItemViewControllerClient?
    var validator:NamedItemValidator?
    
    @IBOutlet weak var nameTextField:NSTextField?
    @IBOutlet weak var errorTextField:NSTextField?
    @IBOutlet weak var cancelButton:NSButton?
    @IBOutlet weak var createButton:NSButton?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createButton?.enabled = false
        nameTextField?.target = self
        nameTextField?.action = #selector(self.validateAndSubmit)
        errorTextField?.hidden = true
    }
    

    // Validation UI logic
    
    func validateName() {
        if let name = nameTextField?.stringValue {
            
            if (nameTextField!.stringValue.isEmpty) {
                errorTextField?.hidden = false
                errorTextField?.stringValue = "Can't be blank!"
                createButton?.enabled = false
                
            }else {
                
                if let v = validator {
                    if v.nameExists(name) {
                        errorTextField?.hidden = false
                        errorTextField?.stringValue = "Must be unique!"
                        createButton?.enabled = false
                    }else {
                        errorTextField?.hidden = true
                        createButton?.enabled = true
                    }
                }
            }
            
        }
    }
    
    
    // Actions
    
    @IBAction func validateAndSubmit(sender:AnyObject?) {
        validateName()
        if createButton!.enabled {
            createButton?.performClick(self)
        }
    }
    
    @IBAction func createClicked(sender:AnyObject?) {
        client?.choseName(nameTextField!.stringValue)
    }
    
    @IBAction func cancelClicked(sender:AnyObject?) {
        client?.canceled()
    }
    
    // NSTextFieldDelegate
    
    override func controlTextDidChange(obj: NSNotification) {
        errorTextField?.hidden = true
        validateName()
    }
}
