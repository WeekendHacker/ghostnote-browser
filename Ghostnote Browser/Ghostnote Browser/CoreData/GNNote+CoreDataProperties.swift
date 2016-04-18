//
//  GNNote+CoreDataProperties.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/18/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension GNNote {

    @NSManaged var appBundleID: String?
    @NSManaged var appName: String?
    @NSManaged var content: NSObject?
    @NSManaged var documentPath: String?
    @NSManaged var themeName: String?

}
