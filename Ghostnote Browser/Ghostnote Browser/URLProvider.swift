//
//  URLProvider.swift
//  GhostNote
//
//  Created by Jimmy Hough Jr on 5/23/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Cocoa

class URLProvider:NSObject {
    
    static func appStorageURL() -> NSURL {
        let appSupport =  NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .AllDomainsMask, true).first
        return NSURL(fileURLWithPath: appSupport!).URLByAppendingPathComponent("com.ghostnoteapp.Ghostnote-Paddle")
    }
    
    static func noteStorageURL() -> NSURL {
        return appStorageURL().URLByAppendingPathComponent("GhostNotes", isDirectory: true)
    }
    
    static func realmFileURL() -> NSURL {
        return appStorageURL().URLByAppendingPathComponent("Default.realm")
    }
    
}