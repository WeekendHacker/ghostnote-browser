//
//  SplitViewCollapseable.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 6/23/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Foundation
import Cocoa

protocol SplitViewCollapseable: NSSplitViewDelegate {
    
    var splitView:CustomSplitView? { get set}
    var masterListExpandedWidth:CGFloat? { get set}
    
    func collapseMasterList()
    func expandMasterList()
}

extension SplitViewCollapseable {
    
    func expandMasterList() {
        if let width = masterListExpandedWidth {
            splitView?.setPosition(width, ofDividerAtIndex: 0)
        }
    }
    
    func collapseMasterList() {
        splitView?.setPosition(0, ofDividerAtIndex: 0)
    }
}