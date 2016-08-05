//
//  MainWindowController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/24/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        if #available(OSX 10.10, *) {
            window?.styleMask = (window?.styleMask)! | NSFullSizeContentViewWindowMask;
            window?.titlebarAppearsTransparent = true
        } else {
            // Fallback on earlier versions
        }
    }
    
}
