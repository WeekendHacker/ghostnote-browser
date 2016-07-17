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
    
    static func taskCheckedStringWith(attribs:[String:AnyObject]?) -> NSAttributedString {
        let foo =  NSAttributedString(string: "\" ", attributes: attribs)
        return foo
    }
    
    static func taskUncheckedStringWith(attribs:[String:AnyObject]?) -> NSAttributedString {
        let foo =  NSAttributedString(string: "! ", attributes: attribs)
        return foo
    }
    
    func rangeOfUncheckedBox() -> NSRange {
        
        let unchecked = NSAttributedString.taskUncheckedStringWith(nil)
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
        
        let checked = NSAttributedString.taskCheckedStringWith(nil)
       
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
    
    func mutableLines() -> [NSMutableAttributedString] {
        var lines = [NSMutableAttributedString]()
        let range = NSRange(location: 0, length: self.length)
        
        (self.string as NSString).enumerateSubstringsInRange(range, options:.ByLines) { (line, lineRange, rangeWithTerminators, nil) in
            
            let attributedLine = (self.attributedSubstringFromRange(lineRange))
            
            lines.append((attributedLine.mutableCopy() as? NSMutableAttributedString)!)
            
        }
        return lines
    }
}