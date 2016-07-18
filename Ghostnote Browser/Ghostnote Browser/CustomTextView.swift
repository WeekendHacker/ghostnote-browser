//
//  NSTextViewExtensions.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 7/8/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Foundation
import Cocoa

protocol CustomTextViewDelegate {
    
    func shouldMoveInsertionPointForClick(clickedIndex:Int) -> Bool
    func clickedCharacterAtIndex(index:Int)
    func newLineEntered()
}

class CustomTextView: NSTextView {
    
    var processor:TextProcessor?
    
    override func preferredPasteboardTypeFromArray(availableTypes: [String], restrictedToTypesFromArray allowedTypes: [String]?) -> String? {
        if availableTypes.contains(NSPasteboardTypeString) {
            return NSPasteboardTypeString
        }else {
            return super.preferredPasteboardTypeFromArray(availableTypes, restrictedToTypesFromArray: allowedTypes)
        }
    }
    
    override func mouseDown(theEvent: NSEvent) {
        
        let point = convertPoint(theEvent.locationInWindow, fromView:nil)
        let clickedCharIndex = characterIndexForInsertionAtPoint(point)

        if processor!.shouldMoveInsertionPointForClick(clickedCharIndex) {
            super.mouseDown(theEvent)
        }else {
            processor?.clickedCharacterAtIndex(clickedCharIndex)
        }
    }
    
    override func insertNewline(sender: AnyObject?) {
        super.insertNewline(sender)
        processor?.newLineEntered()
    }
}