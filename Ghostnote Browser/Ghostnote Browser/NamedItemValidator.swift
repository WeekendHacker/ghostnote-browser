//
//  NamedItemValidator.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/4/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa
import RealmSwift

protocol NamedItemValidator {
    func nameExists(name:String) -> Bool
}