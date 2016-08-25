//
//  MainWindowController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/24/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

//extension NSBundle {
//    
//    func plist() -> NSDictionary? {
//        
//        var releaseDict: NSDictionary?
//        var betaDict: NSDictionary?
//        
//        if let betaPath = NSBundle.mainBundle().pathForResource("Ghostnote Browser Beta-Info", ofType: "plist") {
//            betaDict = NSDictionary(contentsOfFile: betaPath)
//        }
//        
//        if let releasePath = NSBundle.mainBundle().pathForResource("Info", ofType: "plist") {
//            releaseDict = NSDictionary(contentsOfFile: releasePath)
//        }
//        
//        if betaDict != nil {
//            return betaDict
//        }else if releaseDict != nil {
//            return releaseDict
//        }
//        return nil
//    }
//}
class MainWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        window?.styleMask = (window?.styleMask)! | NSFullSizeContentViewWindowMask;
        window?.titlebarAppearsTransparent = true
        
        if let plist =  NSBundle.mainBundle().infoDictionary {
            if let title = plist["CFBundleDisplayName"] as? String {
                window?.title = title
            }
        }
        
    }
    
}
