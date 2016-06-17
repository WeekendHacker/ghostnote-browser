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
    
    override public var intrinsicContentSize:NSSize{
        return NSMakeSize(self.attributedStringValue.size().width, 20)
    }

}
