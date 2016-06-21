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


class DeletableTableView: NSTableView {

    weak var deleteDelegate:DeleteRowDelegate?
    
    override func keyDown(theEvent: NSEvent) {

        if theEvent.keyCode == 117 {
            if hasSelection() == true {
                let selectionToDelete = selectedRow
                deleteDelegate?.deleteRow(selectionToDelete)
            }
        }
        super.keyDown(theEvent)
    }
}
