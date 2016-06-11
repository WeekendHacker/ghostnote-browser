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
                textField?.lineBreakMode = .ByTruncatingMiddle
                textField?.stringValue = AppNameProvider.displayNameForBundleID(myApp.bundleID)
                toolTip = myApp.bundleID
                imageView?.image = AppIconProvider.iconImagefor(myApp.bundleID)
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
