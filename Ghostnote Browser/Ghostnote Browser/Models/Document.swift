//
//  Document.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/18/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Foundation

class Document {
    
    var path = ""
    var note:GNNote
    
    init(note:GNNote) {
        self.note = note
        self.path = note.documentPath!
    }
}