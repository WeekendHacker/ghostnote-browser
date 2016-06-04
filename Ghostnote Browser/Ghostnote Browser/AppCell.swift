//
//  AppView.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/19/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class AppCell: NSTableCellView {

    var app:App? {
        didSet {
            if let myApp = app {
                textField?.lineBreakMode = .ByTruncatingMiddle
                textField?.stringValue = AppNameProvider.displayNameForBundleID(myApp.bundleID)
                toolTip = myApp.bundleID
                imageView?.image = AppIconProvider.iconImagefor(myApp.bundleID)
            }
        }
    }
}
