//
//  GhostnotesSearchController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 6/20/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa
import RealmSwift

class GhostnotesSearchController: NSObject {
    
    let db:Realm
    var appSupportDir = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .AllDomainsMask, true)
    
    override init() {
        var  config = Realm.Configuration()
        config.fileURL =  NSURL(fileURLWithPath: appSupportDir.first!).URLByAppendingPathComponent("com.ghostnoteapp.Ghostnote-Paddle/Default.realm")
        db = try! Realm(configuration: config)
    }
    
    var isSearching:Bool = false
    
    var results:Array<GhostNote> {
        get {
            var sr = Array<GhostNote>()
            
            for gn in db.objects(GhostNote.self) {
                if gn.rawText().containsString(searchText) {
                    sr.append(gn)
                }
            }
            
            return sr
        }
    }
    
    var searchText:String = ""
}
