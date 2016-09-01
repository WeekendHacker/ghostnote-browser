//
//  DocumentIconProvider.swift
//  timetracker
//
//  Created by Jimmy Hough Jr on 2/2/16.
//  Copyright © 2016 Jimmy Hough Jr. All rights reserved.
//

import Cocoa
import XCGLogger

class DocumentIconProvider: NSObject {
    
    static let log = XCGLogger(identifier: "DocProvider",
                        includeDefaultDestinations: true)
    
    static func iconImageForDocumentPath(path:String, bundleID:String) -> NSImage {
        log.addLogDestination(XCGNSLogDestination(owner: log, identifier: "advancedLogger.systemLogDestination"))
        log.info("path = \(path)")
    
        if bundleID == "com.apple.finder" {
            
            let fileURL = NSURL(fileURLWithPath: path)
            if let pathExtension = fileURL.pathExtension where !pathExtension.isEmpty {
                return NSWorkspace.sharedWorkspace().iconForFileType(NSFileTypeForHFSTypeCode(OSType(kGenericDocumentIcon)))
            }else if path.hasSuffix(":") {
                return NSWorkspace.sharedWorkspace().iconForFileType(NSFileTypeForHFSTypeCode(OSType(kGenericFolderIcon)))
            }
        }
        else if bundleID == "com.bohemiancoding.sketch3" {
            return NSWorkspace.sharedWorkspace().iconForFileType("sketch")
        }
        else {
            
            if let url = NSURL(string: path) {

                if url.isWebURL() {
                    log.info("isWebURL")
                    if url.scheme == "http" || url.scheme == "https" {
                        return NSWorkspace.sharedWorkspace().iconForFileType(NSFileTypeForHFSTypeCode(OSType(kInternetLocationHTTPIcon)))
                    }else if url.scheme == "ftp" {
                        return NSWorkspace.sharedWorkspace().iconForFileType(NSFileTypeForHFSTypeCode(OSType(kInternetLocationFTPIcon)))
                    }else {
                        log.info("generic internet location")
                        return NSWorkspace.sharedWorkspace().iconForFileType(NSFileTypeForHFSTypeCode(OSType(kInternetLocationGenericIcon)))
                    }
                }
                else {
                    log.info("not a web URL")
                    let fileURL = NSURL.fileURLWithPath(path)
                    if let p = fileURL.path where !path.isEmpty {
                        log.info("\(p)")
                        if let pathExtension = fileURL.pathExtension {
                            return NSWorkspace.sharedWorkspace().iconForFileType(pathExtension)
                        }
                    }
                }
                
                log.info("is this branch ever reached?")
                return NSWorkspace.sharedWorkspace().iconForFileType(NSFileTypeForHFSTypeCode(OSType(kInternetLocationHTTPIcon)))
            }
        }
        log.info("should never reach this")
        return NSWorkspace.sharedWorkspace().iconForFileType(NSFileTypeForHFSTypeCode(OSType(kGenericDocumentIcon)))
    }
}