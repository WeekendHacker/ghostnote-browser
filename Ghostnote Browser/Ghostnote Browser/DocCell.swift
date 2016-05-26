//
//  DocCell.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/19/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class DocCell: NSTableCellView {

    var doc:Document? {
        didSet {
            if let  myDoc = doc {
                textField?.lineBreakMode = .ByTruncatingMiddle
                textField?.stringValue = myDoc.path
                toolTip = myDoc.path
                imageView?.image = DocumentIconProvider.iconImageForDocumentPath(myDoc.path)
            }
        }
    }
    
}
