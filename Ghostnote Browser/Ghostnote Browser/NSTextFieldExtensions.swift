//
//  NSTextFieldExtensions.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 6/17/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Foundation
import Cocoa

extension NSTextField {
    
    override public func mouseDown(theEvent: NSEvent) {
        
        if theEvent.clickCount == 1 {
            if self.superview is NSTableCellView {
                superview?.mouseDown(theEvent)
            }else {
                super.mouseDown(theEvent)
            }
        }else if theEvent.clickCount == 2 {
            enterEditing()
        }
       
    }
    
    func enterEditing() {
        editable = true
        becomeFirstResponder()
    }
    
    func applyBold() {
        
        if let text = (attributedStringValue.mutableCopy()) as? NSMutableAttributedString {
            
                let range = NSRange(location: 0, length: text.length)
                text.applyFontTraits(.BoldFontMask,
                                     range: range)
                
                attributedStringValue = text
                
        }
    }

    func removeBold() {
        if let text = (attributedStringValue.mutableCopy()) as? NSMutableAttributedString {
            let range = NSRange(location: 0, length: text.length)
            
            text.applyFontTraits(.UnboldFontMask,
                                 range: range)
            
            attributedStringValue = text
        }
    }

    func applyStrikethrough() {
        if let string = attributedStringValue.mutableCopy() as? NSMutableAttributedString {
            string.addAttributes([NSStrikethroughStyleAttributeName : true],
                                  range: NSRange(location: 0, length: string.length))
            attributedStringValue = string
        }
    }
    
    func removeStrikethrough() {
        if let string = attributedStringValue.mutableCopy() as? NSMutableAttributedString {
            string.removeAttribute(NSStrikethroughStyleAttributeName,
                                   range: NSRange(location: 0, length: string.length))
            attributedStringValue = string

        }
    }
    
    override public var intrinsicContentSize:NSSize {
        return NSMakeSize(self.attributedStringValue.size().width + 10, 20)
    }

}
