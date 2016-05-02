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
    dynamic var name = ""
    dynamic var creationDate = NSDate()
    dynamic var filePath:String = ""
    
    func urlForFilePath() -> NSURL? {
    
        if filePath.isEmpty {
            return nil
        }
        return NSURL(fileURLWithPath: self.filePath)
    }
}