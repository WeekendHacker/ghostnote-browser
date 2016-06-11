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
                let title = myNote.name
                let displayTitle = title.componentsSeparatedByString("<!").first
                textField?.stringValue = displayTitle!
                textField?.delegate = self
            }
        }
    }
    
    // NSTextFieldDelegate
    
    override func controlTextDidEndEditing(obj: NSNotification) {
        if let editedField = obj.object as? NSTextField {
            
            if !editedField.stringValue.isEmpty {
                
                if NoteManager.shared.canName(editedField.stringValue) == true {
                    NoteManager.shared.renameNote(note!, toName: editedField.stringValue)
                }else {
                    editedField.stringValue = (note?.name)!
                }
                
            }
        }
    }
}
