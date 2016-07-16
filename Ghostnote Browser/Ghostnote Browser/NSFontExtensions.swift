//
//  NSFontExtensions.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 7/16/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Foundation
import Cocoa

extension NSFont {
    
    func isBold() -> Bool {
        return NSFontManager.sharedFontManager().traitsOfFont(self).contains(.BoldFontMask)
    }
    
    func isItalic() -> Bool {
        return NSFontManager.sharedFontManager().traitsOfFont(self).contains(.ItalicFontMask)
    }
    
    func boldFont() -> NSFont {
        return NSFontManager.sharedFontManager().convertFont(self, toHaveTrait: .BoldFontMask)
    }
    
    func italicFont() -> NSFont {
        return NSFontManager.sharedFontManager().convertFont(self, toHaveTrait: .ItalicFontMask)
    }
    
    func nonBoldFont() -> NSFont {
        return NSFontManager.sharedFontManager().convertFont(self, toHaveTrait: .UnboldFontMask)
    }
    
    func nonItalicFont() -> NSFont {
        return NSFontManager.sharedFontManager().convertFont(self, toHaveTrait: .UnitalicFontMask)
    }
    
}