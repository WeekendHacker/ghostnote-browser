//
//  TaskCell.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/5/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class TaskCell: NSTableCellView {

    var task:Task? {
        didSet {
            if let t = task {
                self.textField?.stringValue = t.title
            }
        }
    }
    
}
