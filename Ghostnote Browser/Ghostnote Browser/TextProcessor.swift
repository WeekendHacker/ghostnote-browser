//
//  NSTextViewExtensions.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 7/16/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Foundation
import Cocoa

class TextProcessor: NSObject, CustomTextViewDelegate, NSTextStorageDelegate {
    
    var tag:UInt = 0
    
    var textView:CustomTextView? {
        
        didSet {
            textView?.processor = self
            textView?.font = NSFont(name: "HelveticaNeue", size: 12.0)
            textView?.textStorage?.font = textView?.font
        }
    }
   
    func toggleBold() {

        let font = textView?.typingAttributes["NSFont"] as? NSFont

        if font!.isBold() {
            
            tag = NSFontTraitMask.UnboldFontMask.rawValue
            
        }else {
            tag = NSFontTraitMask.BoldFontMask.rawValue

        }
        
        NSFontManager.sharedFontManager().addFontTrait(self)
    }
    
    func toggleItalic() {

        
        let font = textView?.typingAttributes["NSFont"] as? NSFont
        
        if font!.isItalic() {
            
            tag = NSFontTraitMask.UnitalicFontMask.rawValue
            
        }else {
            tag = NSFontTraitMask.ItalicFontMask.rawValue
            
        }
        NSFontManager.sharedFontManager().addFontTrait(self)
    }
    
    func toggleBulletList() {
        
        if let ranges = textView?.selectedRanges {
            ranges.forEach({ (range) in
                
                if range.rangeValue.length > 0 {
                    toggleBulletOverRange(range.rangeValue)
                }
                else {
                    toggleBulletAtInsertionPoint()
                }
            })

        }
    }

    func toggleNumberedList() {

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
                    if textView!.shouldChangeTextInRange(range, replacementString: string.string) {
                        
                        textView?.textStorage?.beginEditing()
                        textView?.textStorage?.applyFontTraits(.UnboldFontMask, range: range)
                        textView?.textStorage?.endEditing()

                    }
                }else {
                    
                    if textView!.shouldChangeTextInRange(range, replacementString: string.string) {
                        textView?.textStorage?.beginEditing()
                        textView?.textStorage?.applyFontTraits(.BoldFontMask, range: range)
                        textView?.textStorage?.endEditing()

                    }
                }
            }
        }
    }
    
    func toggleItalicOverRange(range:NSRange) {
        
        if let string = textView?.textStorage?.attributedSubstringFromRange(range) {
            
            let attribs = string.fontAttributesInRange(NSRange(location: 0, length: string.length))
            
            if let font = attribs["NSFont"] as? NSFont {
                
                if font.isItalic() {
                    if textView!.shouldChangeTextInRange(range, replacementString: string.string) {
                        textView?.textStorage?.applyFontTraits(.UnitalicFontMask, range: range)
                     }
                }else {
                    if textView!.shouldChangeTextInRange(range, replacementString: string.string) {
                        textView?.textStorage?.applyFontTraits(.ItalicFontMask, range: range)
                    }
                }
            }
        }
    }
    
    func toggleBulletOverRange(range:NSRange) {
        if let lines = textView?.textStorage?.attributedSubstringFromRange(range).mutableLines() where !lines.isEmpty {
            
            let replacementString = NSMutableAttributedString()
            
            lines.forEach { (attributedString) in
                
                if attributedString.hasBullet() {

                    attributedString.deleteCharactersInRange(NSRange(location: 0, length: 2))
                    replacementString.appendAttributedString(attributedString)
                    
                }else {
                    
                    if !attributedString.string.isEmpty {
                        var mutableAttribs = attributedString.attributesAtIndex(0, effectiveRange: nil)
                        
                        if let currentFont = mutableAttribs[NSFontAttributeName] as? NSFont {
                            let size = currentFont.pointSize
                            let bullet = NSAttributedString.bulletStringWith(mutableAttribs, size: size)
                            attributedString.insertAttributedString(bullet, atIndex: 0)
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
    
    func toggleBulletAtInsertionPoint() {
        if let range = textView?.selectedRange() {
            
            let lineRange = (textView?.textStorage?.string as! NSString).lineRangeForRange(NSRange(location: range.location, length: 0))
            
            if let currentLine = textView?.textStorage?.attributedSubstringFromRange(lineRange) {
                
                if currentLine.hasBullet() {
                    
                    removeBulletFromLine(lineRange)
                    
                }else {
                    
                    addBulletToLine(lineRange)
                    
                }
            }
        }

    }
    
    func toggleTaskListOverRange(range:NSRange) {

        if let lines = textView?.textStorage?.attributedSubstringFromRange(range).mutableLines() where !lines.isEmpty {
            
            let replacementString = NSMutableAttributedString()
            
            lines.forEach { (attributedString) in
                
                if attributedString.hasCheckBox() {

                    attributedString.deleteCharactersInRange(NSRange(location: 0, length: 2))
                    replacementString.appendAttributedString(attributedString)
                    
                }else {
                    
                    if !attributedString.string.isEmpty {
                        var mutableAttribs = attributedString.attributesAtIndex(0, effectiveRange: nil)
                        
                        if let currentFont = mutableAttribs[NSFontAttributeName] as? NSFont {
                            
                            let size = currentFont.pointSize
                            let box = NSAttributedString.taskUncheckedStringWith(mutableAttribs, size: size)
                            attributedString.insertAttributedString(box, atIndex: 0)
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

            let box = NSAttributedString.taskUncheckedStringWith(mutableAttribs, size: size)
            
            if textView!.shouldChangeTextInRange(range, replacementString: box.string) {
                textView?.textStorage?.beginEditing()
                textView?.textStorage?.insertAttributedString(box, atIndex: range.location)
                textView?.textStorage?.endEditing()
                textView?.didChangeText()
            }

        }
    }
    
    func addBulletToLine(range:NSRange) {
        var mutableAttribs = textView?.typingAttributes
        
        if let currentFont = mutableAttribs![NSFontAttributeName] as? NSFont {
            
            let size = currentFont.pointSize
            let bullet = NSAttributedString.bulletStringWith(mutableAttribs, size: size)
            
            if textView!.shouldChangeTextInRange(range, replacementString: bullet.string) {
                textView?.textStorage?.beginEditing()
                textView?.textStorage?.insertAttributedString(bullet, atIndex: range.location)
                textView?.textStorage?.endEditing()
                textView?.didChangeText()
            }
        }
    }
    
    func removeBulletFromLine(range:NSRange) {
        
        if textView!.shouldChangeTextInRange(range, replacementString: "") {
            
            let rangeToDelete = NSRange(location: range.location, length: 2)
            
            
            textView?.textStorage?.beginEditing()
            textView?.textStorage?.deleteCharactersInRange(rangeToDelete)
            
            textView?.textStorage?.endEditing()
            textView?.didChangeText()
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
        
        if let lines = textView?.textStorage?.attributedSubstringFromRange(range).mutableLines() where !lines.isEmpty {
            let replacementString = NSMutableAttributedString()
            
            var index = 1
            
            for attributedString in lines {
                
                if attributedString.hasLineNumber() {
                    
                    attributedString.deleteCharactersInRange(attributedString.rangeOfLineNumber())

                    replacementString.appendAttributedString(attributedString)
                    
                }else {
                    
                    let lineNumber = NSAttributedString(string: "\(index) ")
                    
                    attributedString.insertAttributedString(lineNumber, atIndex: 0)

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
            // remove attrib for ol?
            let rangeToDelete = NSRange(location: range.location, length: 2)
            textView?.textStorage?.beginEditing()
            textView?.textStorage?.deleteCharactersInRange(rangeToDelete)
            textView?.textStorage?.endEditing()
            textView?.didChangeText()
        }
    }
    
    
    //
    // should make methods to add
    // and remove list attributes to the whole range
    // should maybe use text list?
    // not sure
    //

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
        let selection = textView?.selectedRange()
        let index = selection?.location
        let rangeToSelection = NSRange(location: 0, length: index!)
        let attributedString = textView?.textStorage?.attributedSubstringFromRange(rangeToSelection)
        
        let lines = attributedString!.mutableLines()
        let previousLine = lines.last!
        
        // should probably trimt whitespace form the line
        // to see if it is just the line symbol
        if previousLine.hasCheckBox() {

            if previousLine.length == NSAttributedString.taskUncheckedStringWith(nil,size: 0).length + 1 {
                removeCheckboxFromLine(NSRange(location: index! - 3, length: 3))
            }else {
                toggleTaskListAtInsertionPoint()
            }
            
        }else if previousLine.hasLineNumber() {
            
            if let lineNumberString = previousLine.lineNumber() {
                
                if let lineNumber = Int(lineNumberString.string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())) {
                    
                    if previousLine.hasOnlyLineNumber() {
                        let loc:Int
                        if index == 0 {
                           loc = 0
                        }else {
                           loc = index! - lineNumberString.length - 2
                        }
                        let range = NSRange(location: loc , length: lineNumberString.length +  1)
                        removeLineNumberFromLine(range)
                    }else {
                        let range = NSRange(location: index!, length: 0)
                        addLineNumberToLine(lineNumber + 1, range: range)
                    }
                }
            }
        }else if previousLine.hasBullet() {
            
            if previousLine.hasOnlyBullet() {
                
                let loc:Int
                if index == 0 {
                    loc = 0
                }else {
                    loc = index! - previousLine.rangeOfBullet().length - 2
                }
                let range = NSRange(location: loc , length: 3)
                removeBulletFromLine(range)
            }else {
                toggleBulletAtInsertionPoint()
            }
        }
        
    }
    
    func checkCheckboxAt(index:Int) {
        
        let font = textView?.textStorage?.attribute(NSFontAttributeName, atIndex: index, effectiveRange: nil)
        let size = font?.pointSize
        
        
        let checkedBox = NSAttributedString.taskCheckedStringWith(textView?.typingAttributes, size: size!)
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
        
        let uncheckedBox = NSAttributedString.taskUncheckedStringWith(textView!.typingAttributes, size: size!)
        let replacementRange = NSRange(location: index, length: 2)
        
        if textView!.shouldChangeTextInRange(replacementRange, replacementString: uncheckedBox.string) {
            textView?.textStorage?.beginEditing()
            textView?.textStorage?.replaceCharactersInRange(replacementRange, withAttributedString: uncheckedBox)
            textView?.textStorage?.endEditing()
        }
    }
    
}