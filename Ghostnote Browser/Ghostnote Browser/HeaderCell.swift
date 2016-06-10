//
//  HeaderCell.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 6/9/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class HeaderCell: NSTableCellView {

    var title:String = "" {
        didSet {
            if let displayTitle = title.componentsSeparatedByString("<!").first {
                textField?.stringValue = displayTitle
            }
        }
    }
}
