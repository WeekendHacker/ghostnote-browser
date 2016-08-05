//
//  AppView.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/19/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class AppCell: NSTableCellView, SelectableCell {

    var app:App? {
        didSet {
            if let myApp = app {
                if #available(OSX 10.10, *) {
                    textField?.lineBreakMode = .ByTruncatingMiddle
                } else {
                    textField?.cell?.lineBreakMode = .ByTruncatingMiddle
                }
                textField?.stringValue = AppNameProvider.displayNameForBundleID(myApp.bundleID)
                toolTip = myApp.bundleID
                imageView?.image = AppIconProvider.iconImagefor(myApp.bundleID)
                textField?.font = NSFont(name: "HelveticaNeue", size: 12.0)
            }
        }
    }
    
}
