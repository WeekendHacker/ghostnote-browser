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
        window?.styleMask = (window?.styleMask)! | NSFullSizeContentViewWindowMask;
        window?.titlebarAppearsTransparent = true
    }
    
}
