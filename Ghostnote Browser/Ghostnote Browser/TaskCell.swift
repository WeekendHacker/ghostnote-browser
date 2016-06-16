//
//  TaskCell.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/5/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa
import QuartzCore

class TaskCell: NSTableCellView, NSTextFieldDelegate, SelectableCell
{

    @IBOutlet weak var checkbox:NSButton?
    @IBOutlet weak var editButton:NSButton?

    var task:Task? {
        didSet {
            if let t = task {
                let title = t.title
                let displayTitle = title.componentsSeparatedByString("<!").first
                textField?.stringValue = displayTitle!
                textField?.delegate = self
                
                if let cb = checkbox {
                    if t.isComplete == true {
                        cb.state = NSOnState
                        applyStrikethrough()
                    }else {
                        cb.state = NSOffState
                        removeStrikethrough()
                    }
                }
                
                let editbuttonContraint = NSLayoutConstraint(item: editButton!,
                                                             attribute: .Top,
                                                             relatedBy: .Equal,
                                                             toItem: textField!,
                                                             attribute: .Top,
                                                             multiplier: 1.0, constant: 0.0)
                addConstraint(editbuttonContraint)
                updateConstraints()
            }
        }
    }
    
    
    @IBAction func checkboxChecked(sender:AnyObject?) {
        
        if checkbox?.state == NSOnState {

            task?.complete()
            applyStrikethrough()
        }else if checkbox?.state == NSOffState {

            task?.incomplete()
            removeStrikethrough()
        }
    }
    
    func applyStrikethrough() {
        let string = textField?.attributedStringValue.mutableCopy() as? NSMutableAttributedString
        string?.addAttributes([NSStrikethroughStyleAttributeName : true], range: NSRange(location: 0, length: string!.length))
        textField?.attributedStringValue = string!
    }
    
    func removeStrikethrough() {
        let string = textField?.attributedStringValue.mutableCopy() as? NSMutableAttributedString
        string?.removeAttribute(NSStrikethroughStyleAttributeName, range: NSRange(location: 0, length: string!.length))
        textField?.attributedStringValue = string!
    }
    
    // NSTextFieldDelegate

    override func controlTextDidBeginEditing(obj: NSNotification) {
        if let editingTextField = obj.object as? NSTextField {
            editingTextField.textColor = NSColor.blackColor()
        }
    }
    
    override func controlTextDidEndEditing(obj: NSNotification) {
        if let editedField = obj.object as? NSTextField {
            
            if !editedField.stringValue.isEmpty {
                TaskListManager.shared.changeTask(task!, to: editedField.stringValue)
            }
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
