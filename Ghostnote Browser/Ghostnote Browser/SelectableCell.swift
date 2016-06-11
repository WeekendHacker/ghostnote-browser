//
//  SelectableCell.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 6/11/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Foundation
import Cocoa

protocol SelectableCell {
    var textField:NSTextField? {get set}
    func select(isSelected:Bool)
}

extension SelectableCell {
    
    func select(isSelected:Bool)  {
        
        if isSelected {
            
            let text:NSMutableAttributedString = (textField?.attributedStringValue.mutableCopy())! as! NSMutableAttributedString
            
            let range = NSRange(location: 0, length: text.length)
            text.applyFontTraits(.BoldFontMask,
                                 range: range)

            textField?.attributedStringValue = text
            
        }else {
            let text:NSMutableAttributedString = (textField?.attributedStringValue.mutableCopy())! as! NSMutableAttributedString
            
            let range = NSRange(location: 0, length: text.length)
            
            text.applyFontTraits(.UnboldFontMask,
                                 range: range)

            textField?.attributedStringValue = text
        }
    }
}
