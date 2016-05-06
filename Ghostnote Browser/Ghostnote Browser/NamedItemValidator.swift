//
//  NamedItemValidator.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/4/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa
import RealmSwift

@objc protocol NamedItemValidator {
    optional func nameExists(name:String) -> Bool
    optional func nameExists(name:String, taskList:TaskList) -> Bool
}