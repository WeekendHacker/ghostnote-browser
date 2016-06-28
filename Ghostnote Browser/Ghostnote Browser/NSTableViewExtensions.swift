//
//  NSTableViewExtensions.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 6/27/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Foundation
import Cocoa

extension NSTableView {

    public override func validateProposedFirstResponder(responder: NSResponder, forEvent event: NSEvent?) -> Bool {
        
        if responder is NSTextField {
            return true
        }
        return super.validateProposedFirstResponder(responder, forEvent: event)
    }
}
