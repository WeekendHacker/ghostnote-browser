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
        
        if let tf = textField {
            
            if let text = (tf.attributedStringValue.mutableCopy()) as? NSMutableAttributedString {
                if isSelected {
                    
                    let range = NSRange(location: 0, length: text.length)
                    text.applyFontTraits(.BoldFontMask,
                                         range: range)
                    
                    tf.attributedStringValue = text
                    
                }else {
 
                    let range = NSRange(location: 0, length: text.length)
                    
                    text.applyFontTraits(.UnboldFontMask,
                                         range: range)
                    
                    tf.attributedStringValue = text
                }
            }
        }
    }
}
