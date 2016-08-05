//
//  Note.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/25/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyBeaver

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
        if let url = urlForFilePath() {
            do {
                let wrapper = try NSFileWrapper(URL: url, options: NSFileWrapperReadingOptions.Immediate)
                if let attributedText = NSAttributedString(RTFDFileWrapper: wrapper,
                                                           documentAttributes: nil) {
                    return attributedText.string
                }
            }
            catch {
                SwiftyBeaver.error(error)
            }
        }
        return ""
    }
    
}