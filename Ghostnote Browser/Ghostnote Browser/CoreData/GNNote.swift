//
//  GNNote.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/18/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Foundation
import CoreData

@objc(GNNote)
class GNNote: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    func infoString() -> String {
        return "app:\(self.appName)\ndocPath:\(self.documentPath)\nthemeName:\(self.themeName)\ncontent:\(self.content as! NSAttributedString)"
    }
    
    func isEmpty() -> Bool {
        var val = true
        if let myContent = content as! NSAttributedString? {
            let myString = myContent.string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
            
            val = myString.length == 0
        }
        return val
    }
    
    func isAppNote() -> Bool {
        let doc = documentPath
        let app = appName
        
        return app! == doc!
    }
}
