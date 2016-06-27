//
//  StringExtensions.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 6/27/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Foundation

extension String {
    
    public func withoutUniquePart() -> String {
        if let part = self.componentsSeparatedByString("<!").first {
            return part
        }
        return self
    }
}