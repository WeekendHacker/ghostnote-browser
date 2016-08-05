//
//  CustomRowView.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 6/27/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class CustomRowView: NSTableRowView {

    var forTasks:Bool = false
    
        override func drawSelectionInRect(dirtyRect: NSRect) {
        
        if !forTasks {
            let selectionRect = NSInsetRect(self.bounds, 2.5, 2.5);
            let selectionPath = NSBezierPath(roundedRect: selectionRect, xRadius: 0.0, yRadius: 0.0)
            let color:NSColor
            
            if emphasized {
            
                color = NSColor.gnBlue()
                
            }else {
            
                color = NSColor.gnGrey().colorWithAlphaComponent(0.5)
            
            }
            
            color.set()
            selectionPath.stroke()
            selectionPath.fill()
            
        }else {
            
            func drawWithContext(ctx:CGContext) {
                
                let borderColor = NSColor.gnWhite().CGColor
                let selectedBorderColor = NSColor.gnBlue().CGColor
                
                let width = bounds.size.width
                let height = bounds.size.height
                let insetDistance:CGFloat = 4.0
                let doubleInset:CGFloat = 2.0 * insetDistance
                let boxLeft:CGFloat = 2.0
                
                
                if selected {
                    CGContextSetStrokeColorWithColor(ctx, selectedBorderColor)
                }else {
                    CGContextSetStrokeColorWithColor(ctx, borderColor)
                }
                
                let origin = CGPoint(x: boxLeft, y: insetDistance)
                let size = CGSize(width: width - boxLeft, height: height - doubleInset)
                let rect = CGRect(origin: origin, size: size)
                
                //
                CGContextSetLineWidth(ctx, 1.0)
                
                // start at origin
                CGContextMoveToPoint (ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));
                
                // add bottom edge
                CGContextAddLineToPoint (ctx, CGRectGetMaxX(rect) - 9.0, CGRectGetMinY(rect));
                
                // add right edge
                CGContextAddLineToPoint (ctx, CGRectGetMaxX(rect) - 9.0, CGRectGetMaxY(rect));
                
                // add top edge
                CGContextAddLineToPoint (ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));
                
                // add left edge and close
                CGContextClosePath (ctx);
                CGContextStrokePath(ctx)
            }
            

            if #available(OSX 10.10, *) {
                
                if let ctx = NSGraphicsContext.currentContext()?.CGContext {
                    drawWithContext(ctx)
                }
            }
            else {
                if let contextPointer = NSGraphicsContext.currentContext()?.graphicsPort {
                    let ctx: CGContextRef = Unmanaged.fromOpaque(COpaquePointer(contextPointer)).takeUnretainedValue()
                    drawWithContext(ctx)
                }
            }
        }
    }
}
