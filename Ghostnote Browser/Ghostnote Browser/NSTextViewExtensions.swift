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
        
        if let ranges = textView?.selectedRanges  {
            
            ranges.forEach({ (range) in
                
                if range.rangeValue.length > 0 {
                    toggleTaskListOverRange(range.rangeValue)
                }
                else {
                    toggleTaskListAtInsertionPoint()
                }
            })
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
    
    func toggleTaskListOverRange(range:NSRange) {

        if let lines = textView?.textStorage?.attributedSubstringFromRange(range).mutableLines() {
            let replacementString = NSMutableAttributedString()
            
            lines.forEach { (attributedString) in
                
                if attributedString.hasCheckBox() {
                    
                    attributedString.deleteCharactersInRange(NSRange(location: 0, length: 2))
                    let newLine = NSAttributedString(string: "\n")
                    attributedString.appendAttributedString(newLine)
                    replacementString.appendAttributedString(attributedString)
                    
                }else {
                    
                    var mutableAttribs = attributedString.attributesAtIndex(0, effectiveRange: nil)
                    
                    if let currentFont = mutableAttribs[NSFontAttributeName] as? NSFont {
                        
                        let size = currentFont.pointSize
                        mutableAttribs[NSFontAttributeName] = NSFont(name: "Hellvetica", size: size)
                        let box = NSAttributedString.taskUncheckedStringWith(mutableAttribs)
                        attributedString.insertAttributedString(box, atIndex: 0)
                        let newLine = NSAttributedString(string: "\n")
                        attributedString.appendAttributedString(newLine)
                        replacementString.appendAttributedString(attributedString)
                    }
                }
            }
            
            if ((textView?.shouldChangeTextInRange(range, replacementString: replacementString.string)) != nil) {
                textView?.textStorage?.beginEditing()
                textView?.textStorage?.replaceCharactersInRange(range, withAttributedString: replacementString)
                textView?.textStorage?.endEditing()
                textView?.didChangeText()
//                let notif = NSNotification(name: NSTextDidChangeNotification, object: textView)
//                textView?.delegate?.textDidChange!(notif)
            }
           
        }
    }
    
    func toggleTaskListAtInsertionPoint() {
        print("toggleTaskAtInsertionPoint")
        if let range = textView?.selectedRange() {
            ((textView?.textStorage?.string)! as NSString).enumerateSubstringsInRange(range, options:.ByLines) { (line, lineRange, rangeWithTerminators, nil) in
                print(line)
            }
        }
       
    }
}