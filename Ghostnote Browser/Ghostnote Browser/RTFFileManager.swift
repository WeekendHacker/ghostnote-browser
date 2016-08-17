//
//  RTFFileManager.swift
//  GhostNote
//
//  Created by Jimmy Hough Jr on 5/23/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Cocoa

class RTFFileManager:NSObject {
    
    static let shared = RTFFileManager()
    
    // file methods
    
    private func appcontainerURLForBundleID(bundleID:String) -> NSURL {
        let name = AppNameProvider.displayNameForBundleID(bundleID)
        return URLProvider.noteStorageURL().URLByAppendingPathComponent(name, isDirectory: true)
    }
    
    private func createAppContainerFolderFor(bundleID:String) {
        
        let containerURL = appcontainerURLForBundleID(bundleID)
        
        if !NSFileManager.defaultManager().fileExistsAtPath(containerURL.path!) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtURL(containerURL,
                                                                        withIntermediateDirectories: true,
                                                                        attributes: nil)
            }
            catch {
                print(error)
            }
            
        }
    }
    
    func fileURLFor(bundleID:String, docID:String) -> NSURL {
        
        let docIDtoUse = docID.stringByReplacingOccurrencesOfString("/", withString: " ")
        
        let fileURL = appcontainerURLForBundleID(bundleID).URLByAppendingPathComponent(docIDtoUse, isDirectory: false).URLByAppendingPathExtension("rtfd")
        print("fileURL = \(fileURL)")
        
        return fileURL
    }
    
    func createFileFor(bundleID:String, docID:String, content:NSAttributedString) -> NSURL {
        
        createAppContainerFolderFor(bundleID)
        
        let fileURL = fileURLFor(bundleID, docID: docID)
        
        do  {
            let seed = content ?? NSAttributedString(string: "", attributes: nil)
            
            let wrapper = try  seed.fileWrapperFromRange(NSRange(location: 0, length: seed.length), documentAttributes: [NSDocumentTypeDocumentAttribute : NSRTFTextDocumentType])
            
            do {
                try wrapper.writeToURL(fileURL, options: .Atomic, originalContentsURL: nil)
            }
            catch{
                print("fuck \(error)")
            }
        }
        catch {
            print(error)
        }
        
        return fileURL
    }
    
    func removeFileForNote(bundleID:String, docID:String) -> Bool {
        do {
            try NSFileManager.defaultManager().removeItemAtURL(fileURLFor(bundleID,
                docID: docID))
            return true
            
        }
        catch {
            print(error)
            return false
        }
    }
}