//
//  NoteTextViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/3/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class NoteTextViewController: NSObject, NSTextViewDelegate {

    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleDeletedNote(_:)),
                                                         name: "DeletedNote",
                                                         object: nil)
    }
    
    var currentNote:Note? {
        
        willSet {
            if let note = currentNote {
                if !note.invalidated  == true {
                    noteTextView!.writeRTFDToFile(note.filePath, atomically: true)
                }
            }
        }
        
        didSet {
            
            if let note = currentNote {
                noteTextView?.readRTFDFromFile(note.filePath)
            }
            else {
                noteTextView?.string = ""
            }
        }
    }
    
    var noteTextView:NSTextView? {
        didSet {
            noteTextView?.delegate = self
            noteTextView?.wantsLayer = true
            
            noteTextView?.font = NSFont.systemFontOfSize(12.0)
        }
    }
    
    
    func textDidChange(notification: NSNotification) {
        if notification.object as? NSTextView == noteTextView {
            if let note = currentNote {
                if !note.invalidated {
                    noteTextView!.writeRTFDToFile(note.filePath, atomically: true)
                }
            }
        }
    }
    
    func handleDeletedNote(notif:NSNotification) {
        
        if currentNote?.invalidated == true {
            noteTextView?.string = ""
        }
    }
}
