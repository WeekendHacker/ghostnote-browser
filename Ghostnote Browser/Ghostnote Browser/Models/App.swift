//
//  App.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/18/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Foundation

// Equatable

func ==(lhs:App, rhs:App) -> Bool {
    return lhs.bundleID == rhs.bundleID 
}

class App:Hashable, Equatable {
    var bundleID = ""
    var note:GhostNote?
    
    init(bundleID:String, note:GhostNote?) {
        self.note = note
        self.bundleID = bundleID
    }
    
    // Hashable
    
    var hashValue: Int {
        return bundleID.hashValue
    }
   
}