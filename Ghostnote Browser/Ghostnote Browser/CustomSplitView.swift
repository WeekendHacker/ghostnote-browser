//
//  NSSplitViewExtensions.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 6/17/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Foundation
import Cocoa

class CustomSplitView:NSSplitView {
    
    override var dividerColor: NSColor {
        return NSColor.grayColor().colorWithAlphaComponent(0.5)
    }
}