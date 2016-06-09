//
//  TaskCell.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/5/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class TaskCell: NSTableCellView, NSTextFieldDelegate
{

    @IBOutlet weak var checkbox:NSButton?

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
                    }else {
                        cb.state = NSOffState
                    }
                }
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
    
    @IBAction func checkboxChecked(sender:AnyObject?) {
        
        if checkbox?.state == NSOnState {
            let string = textField?.attributedStringValue.mutableCopy() as? NSMutableAttributedString
            string?.addAttributes([NSStrikethroughStyleAttributeName : true], range: NSRange(location: 0, length: string!.length))
            textField?.attributedStringValue = string!
            task?.complete()
        }else if checkbox?.state == NSOffState {
            let string = textField?.attributedStringValue.mutableCopy() as? NSMutableAttributedString
            string?.removeAttribute(NSStrikethroughStyleAttributeName, range: NSRange(location: 0, length: string!.length))
            textField?.attributedStringValue = string!
            task?.incomplete()
        }
 
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

    
}
