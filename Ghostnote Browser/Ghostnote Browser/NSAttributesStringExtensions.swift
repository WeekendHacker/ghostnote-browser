//
//  NSAttributesStringExtensions.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 7/16/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Foundation
import Cocoa

extension NSAttributedString {
    
    static func taskCheckedStringWith(tailAttribs:[String:AnyObject]?, size:CGFloat) -> NSAttributedString {
        
        let headFont = NSFont(name:"Hellvetica", size: size)
        let headAttribs:[String:AnyObject] = [NSFontAttributeName : headFont!,
                                              NSFontSizeAttribute : size]
        
        let head = NSAttributedString(string: "\"", attributes: headAttribs)
        
        let tail = NSAttributedString(string: " ", attributes: tailAttribs)
        
        let symbol:NSMutableAttributedString = NSMutableAttributedString(attributedString: head)
        symbol.appendAttributedString(tail)
        return symbol
    }
    
    static func taskUncheckedStringWith(tailAttribs:[String:AnyObject]?, size:CGFloat) -> NSAttributedString {

        let headFont = NSFont(name:"Hellvetica", size: size)
        let headAttribs:[String:AnyObject] = [NSFontAttributeName : headFont!,
                                              NSFontSizeAttribute : size]
        
        let head = NSAttributedString(string: "!", attributes: headAttribs)
        
        let tail = NSAttributedString(string: " ", attributes: tailAttribs)
        
        let symbol:NSMutableAttributedString = NSMutableAttributedString(attributedString: head)
        symbol.appendAttributedString(tail)
        return symbol
    }
    
    
    static func bulletStringWith(tailAttribs:[String:AnyObject]?, size:CGFloat) -> NSAttributedString {
        let headFont = NSFont(name:"Hellvetica", size: size)
        let headAttribs:[String:AnyObject] = [NSFontAttributeName : headFont!,
                                              NSFontSizeAttribute : size]
        
        let head = NSAttributedString(string: "•", attributes: headAttribs)
        
        let tail = NSAttributedString(string: " ", attributes: tailAttribs)
        
        let symbol:NSMutableAttributedString = NSMutableAttributedString(attributedString: head)
        symbol.appendAttributedString(tail)
        return symbol
    }
    
    func rangeOfUncheckedBox() -> NSRange {
        
        let unchecked = NSAttributedString.taskUncheckedStringWith(nil,size:0)
        let range = (self.string as NSString).rangeOfString(unchecked.string)

        if range.location != NSNotFound {
            let string = self.attributedSubstringFromRange(range)
            let attribs = string.fontAttributesInRange(range)
            if let font = attribs[NSFontAttributeName] {
                if font.fontName == "Hellvetica-Regular" {
                    return range
                }
            }
        }
        
        return NSMakeRange(NSNotFound, 0)
    }
    
    func rangeOfCheckedBox() -> NSRange {
        
        let checked = NSAttributedString.taskCheckedStringWith(nil, size:0)
       
        let range = (self.string as NSString).rangeOfString(checked.string)
        
        if range.location != NSNotFound {
            let string = self.attributedSubstringFromRange(range)
            let attribs = string.fontAttributesInRange(range)
            if let font = attribs[NSFontAttributeName] {
                if font.fontName == "Hellvetica-Regular" {
                    return range
                }
            }
        }

        return NSRange(location: NSNotFound, length: 0)
    }
    
    func hasCheckBox() -> Bool {
        return rangeOfCheckedBox().location != NSNotFound || rangeOfUncheckedBox().location != NSNotFound
    }
    
    func hasBullet() -> Bool {
        return rangeOfBullet().location != NSNotFound
    }
    
    func mutableLines() -> [NSMutableAttributedString] {
        var lines = [NSMutableAttributedString]()
        let range = NSRange(location: 0, length: self.length)
        
        (self.string as NSString).enumerateSubstringsInRange(range, options:.ByLines) { (line, lineRange, rangeWithTerminators, nil) in
            
            let attributedLine = (self.attributedSubstringFromRange(rangeWithTerminators))
            
            lines.append((attributedLine.mutableCopy() as? NSMutableAttributedString)!)
            
        }
        return lines
    }
    
    func hasLineNumber() -> Bool {
        
        var numericCharCount = 0
        var newLineCount = 0
        var spaceCount = 0
        var otherCount = 0
        
        for c in string.characters {
            
            if "0"..."9" ~= c {
                numericCharCount += 1
            }else if c == " " {
                spaceCount += 1
            }else if c == "\n" {
                newLineCount += 1
            }else {
                otherCount += 1
            }
        }
        
        if numericCharCount > 0 && (spaceCount >= 1) {
            return true
        }

        
        return false
    }
    
    
    func hasOnlyBullet() -> Bool {

        var numericCharCount = 0
        var newLineCount = 0
        var spaceCount = 0
        var otherCount = 0
        var bulletCount = 0
        
        for c in string.characters {
            
            if "0"..."9" ~= c {
                numericCharCount += 1
            }else if c == " " {
                spaceCount += 1
            }else if c == "\n" {
                newLineCount += 1
            }else if c == "•" {
                bulletCount += 1
            }else {
                 otherCount += 1
            }
        }
        
        if otherCount == 0  && spaceCount >= 1 && bulletCount == 1 {
            return true
        }
        
        return false
    }
    
    func hasOnlyLineNumber() -> Bool {
        
        var numericCharCount = 0
        var newLineCount = 0
        var spaceCount = 0
        var otherCount = 0
        
        for c in string.characters {
            
            if "0"..."9" ~= c {
                numericCharCount += 1
            }else if c == " " {
                spaceCount += 1
            }else if c == "\n" {
                newLineCount += 1
            }else {
                otherCount += 1
            }
        }
        
        if otherCount == 0 && numericCharCount > 0 && spaceCount >= 1 {
            return true
        }
        
        return false
    }
   
    func lineNumber() -> NSAttributedString? {
        let decimalRange = self.rangeOfLineNumber()
        if (decimalRange.location == 0) && decimalRange.location != NSNotFound {
            return self.attributedSubstringFromRange(decimalRange)
        }
        return nil
    }
    
    
    //this needs some work
    
    func rangeOfLineNumber() -> NSRange {
        
        var endOfLineNumber = 0
        
        for c in self.string.characters {
            if "0"..."9" ~= c {
                endOfLineNumber += 1
            }else {
                break
            }
            
        }
        
        return NSRange(location: 0, length: endOfLineNumber)
    }
    
    func rangeOfBullet() -> NSRange {
        
        var endOfBullet = 0
        
        for c in self.string.characters {
            if c == "•" {
                endOfBullet += 1
                break
            }
        }
        
        if endOfBullet ==  0 {
            return NSRange(location: NSNotFound, length: 0)
        }
        
        return NSRange(location:endOfBullet , length: 1)
    }
}