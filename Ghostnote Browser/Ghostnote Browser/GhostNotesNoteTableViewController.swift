//
//  GhostNotesNoteTableViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 6/4/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class GhostNotesDocTableViewController: NSObject, NSTableViewDelegate, NSTableViewDataSource {

    var currentApp:App?
    
    var docs = Array<Document>()
    @IBOutlet weak var docsTableView:NSTableView?
    
    
    
    
}
