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
        
        if emphasized {
            let selectionRect = NSInsetRect(self.bounds, 2.5, 2.5);
            
            let selectionPath = NSBezierPath(roundedRect: selectionRect, xRadius: 0.0, yRadius: 0.0)
            let color = NSColor(netHex: 0x3C75B8)
            color.set()
            selectionPath.stroke()
            selectionPath.fill()
        }else {
            let selectionRect = NSInsetRect(self.bounds, 2.5, 2.5);
            
            let selectionPath = NSBezierPath(roundedRect: selectionRect, xRadius: 0.0, yRadius: 0.0)
            let color = NSColor.grayColor()
            color.set()
            selectionPath.stroke()
            selectionPath.fill()
        }


    }
}
