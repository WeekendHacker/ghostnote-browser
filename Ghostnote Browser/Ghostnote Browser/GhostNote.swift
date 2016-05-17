//
//  GhostNote.swift
//  GhostNote
//
//  Created by Jimmy Hough Jr on 5/12/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Cocoa
import RealmSwift

class GhostNote: Object {
    
    dynamic var docID = ""
    dynamic var themeName = ""
    dynamic var filePath = ""
    dynamic var appBundleID = ""
    
    func urlForFilePath() -> NSURL? {
        
        if filePath.isEmpty {
            return nil
        }
        return NSURL(fileURLWithPath: self.filePath)
    }
    
    func isAppNote() -> Bool {
        return appBundleID == docID
    }
}
