//
//  Note.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/25/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Foundation
import RealmSwift

class Note:Object {
    dynamic var id = NSUUID().UUIDString
    dynamic var name = "Empty Note"
    dynamic var creationDate = NSDate()
    dynamic var filePath:String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    
    func urlForFilePath() -> NSURL? {
    
        if filePath.isEmpty {
            return nil
        }
        return NSURL(fileURLWithPath: self.filePath)
    }
    
    func rawText() -> String {
        let wrapper = NSFileWrapper(path: filePath)
        if let attributedText = NSAttributedString(RTFDFileWrapper: wrapper!,
                                                   documentAttributes: nil) {
            return attributedText.string
        }
        return ""
    }
    
}