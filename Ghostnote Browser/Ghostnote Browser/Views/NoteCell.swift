//
//  NoteCell.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/24/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa
import RealmSwift

class NoteCell: NSTableCellView, NSTextFieldDelegate, SelectableCell {
    
    var note:Note? { didSet {
     
            if let myNote = note {
                textField?.stringValue = myNote.name.withoutUniquePart()
                textField?.delegate = self
                textField?.font = NSFont(name: "HelveticaNeue", size: 12.0)
            }
        }
    }
    

    // NSTextFieldDelegate
    
    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        if textField!.stringValue.isEmpty {
            NSBeep()
            return false
        }
        return true
    }
    
    override func controlTextDidEndEditing(obj: NSNotification) {
        if let editedField = obj.object as? NSTextField {
            
            if !editedField.stringValue.isEmpty {
                
                if NoteManager.shared.canName(editedField.stringValue) == true {
                    NoteManager.shared.renameNote(note!, toName: editedField.stringValue)
                }else {
                    editedField.stringValue = (note?.name.withoutUniquePart())!
                    NSBeep()
                }
            }

            editedField.editable = false
        }
    }
}
