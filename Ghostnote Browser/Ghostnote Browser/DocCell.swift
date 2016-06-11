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
                imageView?.image = DocumentIconProvider.iconImageForDocumentPath(myDoc.path)
            }
        }
    }
    
    override var backgroundStyle: NSBackgroundStyle {
        didSet {
            if self.backgroundStyle == .Light {
                self.textField?.textColor = NSColor.controlTextColor()
            } else if self.backgroundStyle == .Dark {
                self.textField?.textColor = NSColor.alternateSelectedControlTextColor()
            }
        }
    }
    
}
