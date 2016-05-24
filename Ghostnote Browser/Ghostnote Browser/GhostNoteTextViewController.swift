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
        }
    }
    
    var currentNote:GhostNote? {
        
        willSet {
            if let note = currentNote {
                noteTextView!.writeRTFDToFile(note.filePath, atomically: true)
            }
        }
        
        didSet {
            
            if let note = currentNote {
                noteTextView?.readRTFDFromFile(note.filePath)
            }
            
        }
    }
    
    func textDidChange(notification: NSNotification) {
        if let note = currentNote {
            noteTextView!.writeRTFDToFile(note.filePath, atomically: true)
        }
    }
}
