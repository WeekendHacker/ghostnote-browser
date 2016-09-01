//
//  NSURLExtensions.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 8/28/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Foundation
extension NSURL {
    
    func isWebURL() -> Bool {
        print(self)
        let p = self.absoluteString
        return p.containsString("://")
    }
}
