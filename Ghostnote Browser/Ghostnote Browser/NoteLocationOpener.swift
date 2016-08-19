//
//  NoteLocationOpener.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 8/16/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Foundation
import Cocoa

class NoteSourceOpener {
    
    static func openSourceOf(note:GhostNote) {
        if note.isAppNote() {
            open(note.appBundleID)
        }else {
            
            let fileURL = NSURL(fileURLWithPath:note.docID)
            if let path = fileURL.path {
                if !path.isEmpty {
                    do {
                        try NSWorkspace.sharedWorkspace().openURL(fileURL,
                                                                  options: .Default,
                                                                  configuration: [:])
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    static func open(app:String) {
        NSWorkspace.sharedWorkspace().launchAppWithBundleIdentifier(app,
                                                                    options: NSWorkspaceLaunchOptions.Default, additionalEventParamDescriptor: nil,
                                                                    launchIdentifier: nil)
    }
}