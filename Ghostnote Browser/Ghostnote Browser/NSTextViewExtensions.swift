//
//  NSTextViewExtensions.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 7/16/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Foundation
import Cocoa


class TextProcessor: NSObject {
    
    // public
    var textView:NSTextView?
    
    func toggleBold() {
        
        if let ranges = textView?.selectedRanges  {
            
            ranges.forEach({ (range) in
                
                if range.rangeValue.length > 0 {
                    
                    toggleBoldOverRange(range.rangeValue)
                }
                else {
                    toggleBoldAtInsertionPoint()
                }
            })
        }
    }
    
    func toggleItalic() {
        
        if let ranges = textView?.selectedRanges  {
            
            ranges.forEach({ (range) in
                
                if range.rangeValue.length > 0 {
                    
                    toggleItalicOverRange(range.rangeValue)
                }
                else {
                    toggleItalicAtInsertionPoint()
                }
            })
        }
    }

    func toggleNumberedList() {
        print("toggleNumberedList")
    }
    
    func toggleTaskList() {
        let taskUncheck = taskUncheckedString()
        
        print("toggleTaskList \(taskUncheck)")
        if let text = textView?.textStorage {
            if let index = textView?.selectedRange().location {
                text.beginEditing()
                text.insertAttributedString(taskUncheck, atIndex: index)
                text.endEditing()
            }
        }
        
    }
    
    
    // porbably private
    func toggleBoldOverRange(range:NSRange) {
        
        if let string = textView?.textStorage?.attributedSubstringFromRange(range) {
            
            let attribs = string.fontAttributesInRange(NSRange(location: 0, length: string.length))
            
            if let font = attribs["NSFont"] as? NSFont {
                
                if font.isBold() {
                    textView?.textStorage?.applyFontTraits(.UnboldFontMask, range: range)
                }else {
                    textView?.textStorage?.applyFontTraits(.BoldFontMask, range: range)
                }
            }
        }
    }
    
    func toggleItalicOverRange(range:NSRange) {
        
        if let string = textView?.textStorage?.attributedSubstringFromRange(range) {
            
            let attribs = string.fontAttributesInRange(NSRange(location: 0, length: string.length))
            
            if let font = attribs["NSFont"] as? NSFont {
                
                if font.isItalic() {
                    textView?.textStorage?.applyFontTraits(.UnitalicFontMask, range: range)
                }else {
                    textView?.textStorage?.applyFontTraits(.ItalicFontMask, range: range)
                }
            }
        }
    }
    
    func toggleBoldAtInsertionPoint() {
        if let font = textView?.typingAttributes["NSFont"] as? NSFont {
            var newFont = font
            
            if font.isBold() {
                newFont = font.nonBoldFont()
            }else {
                newFont = font.boldFont()
            }
            textView?.typingAttributes["NSFont"] = newFont
        }
    }
    
    func toggleItalicAtInsertionPoint() {
        if let font = textView?.typingAttributes["NSFont"] as? NSFont {
            var newFont = font
            
            if font.isItalic() {
                newFont = font.nonItalicFont()
            }else {
                newFont = font.italicFont()
            }
            textView?.typingAttributes["NSFont"] = newFont
        }
    }

    func taskCheckedString() -> NSAttributedString {
        var attribs = textView?.typingAttributes
        attribs![NSFontAttributeName] = NSFont(name: "Hellvetica", size: 12.0)
        let foo =  NSAttributedString(string: "\"", attributes: attribs)
        return foo
    }
    
    func taskUncheckedString() -> NSAttributedString {
        var attribs = textView?.typingAttributes
        attribs![NSFontAttributeName] = NSFont(name: "Hellvetica", size: 12.0)
        let foo =  NSAttributedString(string: "!", attributes: attribs)
        return foo
    }
    
}