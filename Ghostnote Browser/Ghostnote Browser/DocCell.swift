//
//  DocCell.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/19/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class DocCell: NSTableCellView, SelectableCell {

    var doc:Document? {
        didSet {
            if let  myDoc = doc {
                textField?.lineBreakMode = .ByTruncatingMiddle
                textField?.stringValue = myDoc.note.docID
                toolTip = myDoc.note.docID
                
                if myDoc.note.appBundleID == "com.apple.finder" {
                    imageView?.image = AppIconProvider.iconImagefor(myDoc.note.appBundleID)
                }else {
                    imageView?.image = DocumentIconProvider.iconImageForDocumentPath(myDoc.path)
                }
                textField?.font = NSFont(name: "HelveticaNeue", size: 12.0)
            }
        }
    }
}
