//
//  DocumentIconProvider.swift
//  timetracker
//
//  Created by Jimmy Hough Jr on 2/2/16.
//  Copyright © 2016 Jimmy Hough Jr. All rights reserved.
//

import Cocoa

class DocumentIconProvider: NSObject {

    static func iconImageForDocumentPath(path:String) -> NSImage {
        let url = NSURL.fileURLWithPath(path)
        
        return  NSWorkspace.sharedWorkspace().iconForFileType((url.pathExtension)!)
    }
}
