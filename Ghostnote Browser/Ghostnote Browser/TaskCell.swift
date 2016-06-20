//
//  TaskCell.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/5/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa
import QuartzCore


extension NSTextField {
    
}

class TaskCell: NSTableCellView, NSTextFieldDelegate, SelectableCell
{

    @IBOutlet weak var checkbox:NSButton?
    @IBOutlet weak var editButton:NSButton?

    var task:Task? {
        didSet {
            if let t = task {
                
                if let displayTitle = t.title.componentsSeparatedByString("<!").first {
                    textField?.delegate = self
                    textField?.lineBreakMode = .ByTruncatingTail
                    textField?.stringValue = displayTitle
                    textField?.toolTip = displayTitle
                    textField?.refusesFirstResponder = true
                }

                if let cb = checkbox {
                    if t.isComplete == true {
                        cb.state = NSOnState
                        textField?.applyStrikethrough()
                    }else {
                        cb.state = NSOffState
                        textField?.removeStrikethrough()
                    }
                }
            }
        }
    }

    @IBAction func checkboxChecked(sender:AnyObject?) {
        
        if checkbox?.state == NSOnState {
            
            task?.complete()
            textField?.applyStrikethrough()
            
        }else if checkbox?.state == NSOffState {

            task?.incomplete()
            textField?.removeStrikethrough()
        }
    }

    @IBAction func editButtonClicked(sender:AnyObject?) {
        NSNotificationCenter.defaultCenter().postNotificationName("EditTaskTitle", object: self)
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        if let ctx = NSGraphicsContext.currentContext()?.CGContext {
            
            let width = bounds.size.width
            let height = bounds.size.height
            let insetDistance:CGFloat = 4.0
            let doubleInset:CGFloat = 2.0 * insetDistance
            
            CGContextSetGrayStrokeColor(ctx, 0.0, 0.8)
            let origin = CGPoint(x: insetDistance, y: insetDistance)
            let size = CGSize(width: width - doubleInset, height: height - doubleInset)
            CGContextAddRect(ctx, CGRect(origin: origin, size: size))

            CGContextStrokePath(ctx)
        }
    }
}
