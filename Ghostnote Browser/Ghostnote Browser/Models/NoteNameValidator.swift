//
//  NoteNameValidator.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/2/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class NoteNameValidator: NSObject {

    static func nameExists(name:String) -> Bool {
        
        var exists = false
        // unique name check
        let predicate = NSPredicate(format: "name == %@", argumentArray: [name])
        if (NoteManager.shared.notes.filter(predicate).count > 0) {
            exists = true
        }
        
        return exists
    }
}
