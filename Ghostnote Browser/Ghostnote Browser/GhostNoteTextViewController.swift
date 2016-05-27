//
//  GhostNoteTextViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/13/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class GhostNoteTextViewController: NSObject, NSTextViewDelegate {

    @IBOutlet var noteTextView:NSTextView? {
        didSet {
            noteTextView?.delegate = self
            NSDistributedNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloadCurrentNote), name: "GhostnoteChangedNote", object: nil)
        }
    }
    
    var currentNote:GhostNote? {

        didSet {
            
            reloadCurrentNote()
            
        }
    }
    
    func reloadCurrentNote() {
        
        if let note = currentNote {
            
            noteTextView?.backgroundColor = NSColor.clearColor()
            noteTextView?.textColor = NSColor.blackColor()
             let read = noteTextView?.readRTFDFromFile(note.filePath)
            if !read! {
                
                noteTextView?.textStorage?.setAttributedString(NSAttributedString())
            }
            
        }
    }
    
    func textDidChange(notification: NSNotification) {
        if let note = currentNote {
            noteTextView!.writeRTFDToFile(note.filePath, atomically: true)
            NSDistributedNotificationCenter.defaultCenter().postNotificationName("GhostnoteBrowserChangedNote",
                                                                                 object: nil,
                                                                                 userInfo: nil,
                                                                                 deliverImmediately: true)
            

        }
    }
}
