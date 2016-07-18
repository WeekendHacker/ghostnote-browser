//
//  NSTextViewExtensions.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 7/8/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Foundation
import Cocoa

class CustomTextView: NSTextView {
    
    override func preferredPasteboardTypeFromArray(availableTypes: [String], restrictedToTypesFromArray allowedTypes: [String]?) -> String? {
        if availableTypes.contains(NSPasteboardTypeString) {
            return NSPasteboardTypeString
        }else {
            return super.preferredPasteboardTypeFromArray(availableTypes, restrictedToTypesFromArray: allowedTypes)
        }
    }
    
    override func mouseDown(theEvent: NSEvent) {
        NSNotificationCenter.defaultCenter().postNotificationName("CustomTextViewGotClick",
                                                                  object: self,
                                                                  userInfo: nil)
        super.mouseDown(theEvent)
    }
    
    override func insertNewline(sender: AnyObject?) {
        NSNotificationCenter.defaultCenter().postNotificationName("CustomTextViewGotNewLine",
                                                                  object: self,
                                                                  userInfo: nil)
        super.insertNewline(sender)
    }
}