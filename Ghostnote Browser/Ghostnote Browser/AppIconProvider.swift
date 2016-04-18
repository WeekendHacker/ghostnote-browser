//
//  AppIconProvider.swift
//  timetracker
//
//  Created by Jimmy Hough Jr on 12/7/15.
//  Copyright © 2015 Jimmy Hough Jr. All rights reserved.
//

import Cocoa

class AppIconProvider: NSObject {

    static func iconImagefor(bundleID:String) -> NSImage {
        
        if let path = NSWorkspace.sharedWorkspace().absolutePathForAppBundleWithIdentifier(bundleID) {
            let image = NSWorkspace.sharedWorkspace().iconForFile(path)
            return image
        }else {
            return NSWorkspace.sharedWorkspace().iconForFileType(kUTTypeApplication as String)
        }
   }
}
