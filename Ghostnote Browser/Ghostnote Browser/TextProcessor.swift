//
//  NSTextViewExtensions.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 7/16/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Foundation
import Cocoa

class TextProcessor: NSObject, CustomTextViewDelegate {
    
    var textView:CustomTextView? {
        
        didSet {
            textView?.processor = self
        }
    }
    
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
        if let ranges = textView?.selectedRanges  {
            
            ranges.forEach({ (range) in
                
                if range.rangeValue.length > 0 {
                    toggleLineNumberOverRange(range.rangeValue)
                }
                else {
                    toggleLineNumberAtInsertionPoint()
                }
            })
        }

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

        if let lines = textView?.textStorage?.attributedSubstringFromRange(range).mutableLines() where !lines.isEmpty {
            
            let replacementString = NSMutableAttributedString()
            
            lines.forEach { (attributedString) in
                
                if attributedString.hasCheckBox() {
                    
                    attributedString.deleteCharactersInRange(NSRange(location: 0, length: 2))
                    let newLine = NSAttributedString(string: "\n")
                    attributedString.appendAttributedString(newLine)
                    replacementString.appendAttributedString(attributedString)
                    
                }else {
                    
                    if !attributedString.string.isEmpty {
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
            }
            
            if ((textView?.shouldChangeTextInRange(range, replacementString: replacementString.string)) != nil) {
                textView?.textStorage?.beginEditing()
                textView?.textStorage?.replaceCharactersInRange(range, withAttributedString: replacementString)
                textView?.textStorage?.endEditing()
                textView?.didChangeText()
            }
        }
    }
    
    func toggleTaskListAtInsertionPoint() {
        if let range = textView?.selectedRange() {
            
            let lineRange = (textView?.textStorage?.string as! NSString).lineRangeForRange(NSRange(location: range.location, length: 0))
            
            if let currentLine = textView?.textStorage?.attributedSubstringFromRange(lineRange) {
                
                if currentLine.hasCheckBox() {
                    
                    removeCheckboxFromLine(lineRange)
                    
                }else {
                    
                    addCheckboxToLine(lineRange)

                }
            }
        }
    }
    
    func addCheckboxToLine(range:NSRange) {
        var mutableAttribs = textView?.typingAttributes

        if let currentFont = mutableAttribs![NSFontAttributeName] as? NSFont {
            
            let size = currentFont.pointSize
            mutableAttribs![NSFontAttributeName] = NSFont(name: "Hellvetica", size: size)
            let box = NSAttributedString.taskUncheckedStringWith(mutableAttribs)
            
            if textView!.shouldChangeTextInRange(range, replacementString: box.string) {
                textView?.textStorage?.beginEditing()
                textView?.textStorage?.insertAttributedString(box, atIndex: range.location)
                textView?.textStorage?.endEditing()
                textView?.didChangeText()
            }
        }
    }
    
    func removeCheckboxFromLine(range:NSRange) {
        
        if textView!.shouldChangeTextInRange(range, replacementString: "") {
            
            let rangeToDelete = NSRange(location: range.location, length: 2)
            textView?.textStorage?.beginEditing()
            textView?.textStorage?.deleteCharactersInRange(rangeToDelete)
            textView?.textStorage?.endEditing()
            textView?.didChangeText()
        }

    }
    
    func toggleLineNumberOverRange(range:NSRange) {
        print("toggleLineNumberOverRange")
        
        if let lines = textView?.textStorage?.attributedSubstringFromRange(range).mutableLines() where !lines.isEmpty {
            let replacementString = NSMutableAttributedString()
            
            var index = 1
            
            for attributedString in lines {
                
                if attributedString.hasLineNumber() {
                    
                    attributedString.deleteCharactersInRange(attributedString.rangeOfLineNumber())
                    let newLine = NSAttributedString(string: "\n")
                    attributedString.appendAttributedString(newLine)
                    replacementString.appendAttributedString(attributedString)
                    
                }else {
                    
                    let lineNumber = NSAttributedString(string: "\(index) ")
                    
                    attributedString.insertAttributedString(lineNumber, atIndex: 0)
                    let newLine = NSAttributedString(string: "\n")
                    attributedString.appendAttributedString(newLine)
                    replacementString.appendAttributedString(attributedString)
                    
                }
                
                index += 1
            }
            
            if ((textView?.shouldChangeTextInRange(range, replacementString: replacementString.string)) != nil) {
                
                textView?.textStorage?.beginEditing()
                textView?.textStorage?.replaceCharactersInRange(range, withAttributedString: replacementString)
                textView?.textStorage?.endEditing()
                textView?.didChangeText()
            }
        }
    }
    
    func toggleLineNumberAtInsertionPoint() {
        if let range = textView?.selectedRange() {
            
            let lineRange = (textView?.textStorage?.string as! NSString).lineRangeForRange(NSRange(location: range.location, length: 0))
            
            if let currentLine = textView?.textStorage?.attributedSubstringFromRange(lineRange) {
                
                if !currentLine.hasLineNumber() {
                    
                    addLineNumberToLine(1, range:lineRange)
                    
                }else {
                    
                    removeLineNumberFromLine(lineRange)
                    
                }
            }
        }
    }
    
    func addLineNumberToLine(number:Int , range:NSRange) {
        
        let mutableAttribs = textView?.typingAttributes
        let lineString = NSAttributedString(string: "\(number) ",attributes: mutableAttribs)
        
            if textView!.shouldChangeTextInRange(range, replacementString: lineString.string) {
                textView?.textStorage?.beginEditing()
                textView?.textStorage?.insertAttributedString(lineString, atIndex: range.location)
                textView?.textStorage?.endEditing()
                textView?.didChangeText()
            }
    }
    
    func removeLineNumberFromLine(range:NSRange) {
        
        if textView!.shouldChangeTextInRange(range, replacementString: "") {
            
            let rangeToDelete = NSRange(location: range.location, length: 2)
            textView?.textStorage?.beginEditing()
            textView?.textStorage?.deleteCharactersInRange(rangeToDelete)
            textView?.textStorage?.endEditing()
            textView?.didChangeText()
        }
    }
    

    // CustomTextViewDelegate
    func shouldMoveInsertionPointForClick(clickedIndex:Int) -> Bool {
        
        if (clickedIndex + 2) < textView?.textStorage?.length {
            if let attributedString = textView?.textStorage?.attributedSubstringFromRange(NSRange(location: clickedIndex, length: 2)) {
                
                if attributedString.rangeOfUncheckedBox().location == 0 {
                    checkCheckboxAt(clickedIndex)
                    return false
                    
                }else if attributedString.rangeOfCheckedBox().location == 0 {
                    uncheckCheckboxAt(clickedIndex)
                    return false
                }
            }
        }

        return true
    }
    
    func clickedCharacterAtIndex(index: Int) {

    }
    
    func newLineEntered() {
        print("newLine")
    }
    
    func checkCheckboxAt(index:Int) {
        let font = textView?.textStorage?.attribute(NSFontAttributeName, atIndex: index, effectiveRange: nil)
        let size = font?.pointSize
        
        
        let checkedBox = NSAttributedString.taskCheckedStringWith([NSFontAttributeName : NSFont(name:"Hellvetica", size: size!)!])
        let replacementRange = NSRange(location: index, length: 2)
        
        if textView!.shouldChangeTextInRange(replacementRange, replacementString: checkedBox.string) {
            textView?.textStorage?.beginEditing()
            textView?.textStorage?.replaceCharactersInRange(replacementRange, withAttributedString: checkedBox)
            textView?.textStorage?.endEditing()
        }
    }
    
    func uncheckCheckboxAt(index:Int) {
        
        let font = textView?.textStorage?.attribute(NSFontAttributeName, atIndex: index, effectiveRange: nil)
        let size = font?.pointSize
        
        let uncheckedBox = NSAttributedString.taskUncheckedStringWith([NSFontAttributeName : NSFont(name:"Hellvetica", size: size!)!])
        let replacementRange = NSRange(location: index, length: 2)
        
        if textView!.shouldChangeTextInRange(replacementRange, replacementString: uncheckedBox.string) {
            textView?.textStorage?.beginEditing()
            textView?.textStorage?.replaceCharactersInRange(replacementRange, withAttributedString: uncheckedBox)
            textView?.textStorage?.endEditing()
        }
    }
}