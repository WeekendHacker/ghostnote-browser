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
                if #available(OSX 10.10, *) {
                    textField?.lineBreakMode = .ByTruncatingMiddle
                } else {
                    textField?.cell?.lineBreakMode = .ByTruncatingMiddle

                }
                textField?.stringValue = myDoc.note.docID
                toolTip = myDoc.note.docID
                
                let proposedDocImage = DocumentIconProvider.iconImageForDocumentPath(myDoc.path)
                imageView?.image = proposedDocImage.appIconIfGeneric(myDoc.note.appBundleID)
                textField?.font = NSFont(name: "HelveticaNeue", size: 12.0)
            }
        }
    }
}
