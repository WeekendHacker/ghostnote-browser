//
//  CustomRowView.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 6/27/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class CustomRowView: NSTableRowView {

    override func drawSelectionInRect(dirtyRect: NSRect) {
        let selectionRect = NSInsetRect(self.bounds, 2.5, 2.5);
        let selectionPath = NSBezierPath(roundedRect: selectionRect, xRadius: 0.0, yRadius: 0.0)
        let color:NSColor
        
        if emphasized {
            
            color = NSColor(netHex: 0x3C75B8)

        }else {
            
            color = NSColor.grayColor()

        }
        
        color.set()
        selectionPath.stroke()
        selectionPath.fill()
    }
}
