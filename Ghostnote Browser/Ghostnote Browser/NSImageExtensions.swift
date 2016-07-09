//
//  NSImageExtensions.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 7/9/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Foundation
import Cocoa

extension NSImage {
    func appIconIfGeneric(usingBundleID:String) -> NSImage {
        
        let appIcon = AppIconProvider.iconImagefor(usingBundleID)
        
        let genericAppIconTiff = NSWorkspace.sharedWorkspace().iconForFileType(NSFileTypeForHFSTypeCode(OSType(kGenericApplicationIcon))).TIFFRepresentation
        
        let genericDocImageTiff = NSWorkspace.sharedWorkspace().iconForFileType(NSFileTypeForHFSTypeCode(OSType(kGenericDocumentIcon))).TIFFRepresentation
        
        
        let proposedTiff = self.TIFFRepresentation
        
        if (proposedTiff == genericDocImageTiff) || (proposedTiff == genericAppIconTiff) {
            return appIcon
        }
        
        return self
    }
}

