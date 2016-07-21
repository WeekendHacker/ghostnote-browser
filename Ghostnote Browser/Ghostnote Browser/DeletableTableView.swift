//
//  DeletableTableView.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 6/3/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

protocol DeleteRowDelegate :NSTableViewDelegate {
    func deleteRow(row:Int)
}

protocol InterTableKeyboardNavigationDelegate {
    func leftArrow()
    func rightArrow()
}

class DeletableTableView: NSTableView {

    weak var deleteDelegate:DeleteRowDelegate?
    var keyboardDelegate:InterTableKeyboardNavigationDelegate?
    
    override func keyDown(theEvent: NSEvent) {

        if theEvent.keyCode == 117 /* Delete Key */  || theEvent.keyCode == 51 /* backspace key */ {
            if hasSelection() == true {
                let selectionToDelete = selectedRow
                deleteDelegate?.deleteRow(selectionToDelete)
            }
        }
        else if theEvent.keyCode == 123 {
            keyboardDelegate?.leftArrow()
        }
        else if theEvent.keyCode == 124 {
            keyboardDelegate?.rightArrow()
        }
        else {
            super.keyDown(theEvent)
        }
    }
}
