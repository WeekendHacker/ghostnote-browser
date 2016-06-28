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
        
        if !(self is TaskCell) {
            if let superView = textField?.superview?.superview as? CustomRowView {
               superView.selected = true
            }

        }else {
            
            if let taskCell = self as? TaskCell {
                if isSelected {
                    taskCell.selected = true
                }else {
                    taskCell.selected = false
                }
            }
        }
       
    }
}
