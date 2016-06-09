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

protocol KeyboardCreationDelegate :NSTableViewDelegate {
    func createKeyPressed(row:Int)
}

class DeletableTableView: NSTableView {

    weak var deleteDelegate:DeleteRowDelegate?
    weak var createDelegate:KeyboardCreationDelegate?
    
    override func keyDown(theEvent: NSEvent) {

        if theEvent.keyCode == 117 {
            if hasSelection() == true {
                let selectionToDelete = selectedRow
                deleteDelegate?.deleteRow(selectionToDelete)
            }
            else {
                NSBeep()
            }
        }else if theEvent.keyCode == 48 {
            createDelegate?.createKeyPressed(selectedRow)
        }
        super.keyDown(theEvent)
    }
    
}
