//
//  AppNameProvider.swift
//  timetracker
//
//  Created by Jimmy Hough Jr on 1/21/16.
//  Copyright © 2016 Jimmy Hough Jr. All rights reserved.
//

import Cocoa

class AppNameProvider: NSObject {

    static func displayNameForBundleID(bundleID:String) -> String {
        
        var name = bundleID.componentsSeparatedByString(".").last!

        if let appPath = NSWorkspace().absolutePathForAppBundleWithIdentifier(bundleID) {
            if let bundle = NSBundle(path: appPath) {
                
                if let betterName = bundle.infoDictionary!["CFBundleName"] {
                    name = betterName as! String
                }
            }
        }

        return name
    }
}
