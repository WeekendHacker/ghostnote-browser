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

class TaskCell: NSTableCellView, NSTextFieldDelegate
{

    @IBOutlet weak var checkbox:NSButton?

    var task:Task? {
        didSet {
            if let t = task {
                
                if let displayTitle = t.title.componentsSeparatedByString("<!").first {
                    textField?.delegate = self
                    textField?.lineBreakMode = .ByTruncatingTail
                    textField?.stringValue = displayTitle
                    textField?.toolTip = displayTitle
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

    // NSTextFieldDelegate
    
    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        if textField!.stringValue.isEmpty {
            NSBeep()
            return false
        }
        return true
    }
    
    override func controlTextDidEndEditing(obj: NSNotification) {
        if let editedField = obj.object as? NSTextField {
            
            if !editedField.stringValue.isEmpty {
                if let task = self.task {
                    TaskListManager.shared.changeTask(task, to: editedField.stringValue)
                }
            }
            
            editedField.editable = false
            (editedField.superview as? SelectableCell)?.select(true)
        }
    }

    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        if let ctx = NSGraphicsContext.currentContext()?.CGContext {
            
            let width = bounds.size.width
            let height = bounds.size.height
            let insetDistance:CGFloat = 4.0
            let doubleInset:CGFloat = 2.0 * insetDistance
            let boxLeft:CGFloat = 24.0
            
            CGContextSetGrayStrokeColor(ctx, 0.8, 1.0)
            let origin = CGPoint(x: boxLeft, y: insetDistance)
            let size = CGSize(width: width - boxLeft, height: height - doubleInset)
            let rect = CGRect(origin: origin, size: size)
            
            //
            CGContextSetLineWidth(ctx, 1.0)
            // start at origin
            CGContextMoveToPoint (ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));
            
            // add bottom edge
            CGContextAddLineToPoint (ctx, CGRectGetMaxX(rect) - 8.0, CGRectGetMinY(rect));
            
            // add right edge
            CGContextAddLineToPoint (ctx, CGRectGetMaxX(rect) - 8.0, CGRectGetMaxY(rect));
                
                // add top edge
            CGContextAddLineToPoint (ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));
                
                // add left edge and close
            CGContextClosePath (ctx);

            CGContextStrokePath(ctx)
        }
    }
}
