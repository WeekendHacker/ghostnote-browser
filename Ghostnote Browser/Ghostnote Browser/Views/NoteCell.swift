//
//  NoteCell.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/24/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class NoteCell: NSTableCellView {

    var note:Note? { didSet {
     
            if let myNote = note {
                textField?.stringValue = myNote.name
            }
        }
    }
    
    
}
