//
//  GhostNoteTextViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/13/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class GhostNoteTextViewController: NSObject, NSTextViewDelegate {

    @IBOutlet var noteTitleLabel:NSTextField?
    @IBOutlet var noteIconImageView:NSImageView?
    
    @IBOutlet var noteTextView:NSTextView? {
        didSet {
            noteTextView?.delegate = self
            noteTextView?.horizontallyResizable = true
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
            
            noteTextView?.hidden = false


            let read = noteTextView?.readRTFDFromFile(note.filePath)
            
            noteTextView?.backgroundColor = NSColor.clearColor()
            noteTextView?.textColor = NSColor.blackColor()
            
            let docID = note.docID
            let appID = note.appBundleID
            
            if note.isAppNote() {
                noteIconImageView?.image = AppIconProvider.iconImagefor(appID).appIconIfGeneric(appID)
                noteTitleLabel?.stringValue = AppNameProvider.displayNameForBundleID(appID)
                noteTitleLabel?.toolTip = appID
            }else {
                noteIconImageView?.image = DocumentIconProvider.iconImageForDocumentPath(docID).appIconIfGeneric(appID)
                noteTitleLabel?.stringValue = docID
                noteTitleLabel?.toolTip = docID
            }
            
            if !read! {
                
                noteTextView?.textStorage?.setAttributedString(NSAttributedString())
            }
            
        }
        else {
            noteTextView?.string = ""
            noteTextView?.hidden = true
            noteTitleLabel?.stringValue = ""
            noteIconImageView?.image = nil
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
