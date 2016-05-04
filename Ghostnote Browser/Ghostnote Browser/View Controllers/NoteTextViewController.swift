//
//  NoteTextViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/3/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class NoteTextViewController: NSObject, NSTextViewDelegate {

    var currentNote:Note? {
        
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
    
    var noteTextView:NSTextView? { didSet {
            noteTextView?.delegate = self
        }
    }
    
    
    func textDidChange(notification: NSNotification) {
        if notification.object as? NSTextView == noteTextView {
            if let note = currentNote {
                noteTextView!.writeRTFDToFile(note.filePath, atomically: true)
            }
        }
    }
}
