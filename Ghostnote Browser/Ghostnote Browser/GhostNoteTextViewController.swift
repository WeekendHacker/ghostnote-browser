//
//  GhostNoteTextViewController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 5/13/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class GhostNoteTextViewController: NSObject, NSTextViewDelegate {

    
    let textProcessor = TextProcessor()
    
    @IBOutlet var noteTitleLabel:NSTextField?
    @IBOutlet var noteIconImageView:NSImageView?
    
    
    @IBOutlet weak var boldButton:NSButton?
    @IBOutlet weak var italicButton:NSButton?
    @IBOutlet weak var numberedListButton:NSButton?
    @IBOutlet weak var todoListButton:NSButton?
    
    @IBOutlet var noteTextView:NSTextView? {
        didSet {
            noteTextView?.delegate = self
            noteTextView?.horizontallyResizable = true
            NSDistributedNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloadCurrentNote), name: "GhostnoteChangedNote", object: nil)
            noteTextView?.linkTextAttributes = [NSForegroundColorAttributeName : NSColor.gnBlue()]
            textProcessor.textView = noteTextView
        }
    }
    
    var currentNote:GhostNote? {

        didSet {
            
            reloadCurrentNote()
            
        }
    }
    
    
    func enableUI() {
        noteTextView?.hidden = false
        boldButton?.enabled = true
        italicButton?.enabled = true
        numberedListButton?.enabled = true
        todoListButton?.enabled = true
    }
    
    func disableUI() {
        noteTextView?.hidden = true
        boldButton?.enabled = false
        italicButton?.enabled = false
        numberedListButton?.enabled = false
        todoListButton?.enabled = false
    }
    
    func reloadCurrentNote() {
        
        if let note = currentNote {
            
            enableUI()

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
            noteTitleLabel?.stringValue = ""
            noteIconImageView?.image = nil
            disableUI()
        }
    }
    
    func textDidChange(notification: NSNotification) {
        if let note = currentNote {
            noteTextView!.writeRTFDToFile(note.filePath, atomically: true)
            
            // This allows GN to reload the note file form disk
            NSDistributedNotificationCenter.defaultCenter().postNotificationName("GhostnoteBrowserChangedNote",
                                                                                 object: nil,
                                                                                 userInfo: nil,
                                                                                 deliverImmediately: true)
            

        }
    }
    
    
    // Actions
    
    func boldClicked(sender:AnyObject?) {
        textProcessor.toggleBold()
    }
    
    func italicClicked(sender:AnyObject?) {
        textProcessor.toggleItalic()

    }
    
    func numberedListClicked(sender:AnyObject?) {
        noteTextView?.changeAttributes(self)
    }
    
    func todoListClicked(sender:AnyObject?) {
        noteTextView?.changeAttributes(self)
    }
    
    //
    
//    func convertAttributes(attributes: [String : AnyObject]) -> [String : AnyObject]{
//        print("convert")
//        print(attributes)
//        return attributes
//    }

    
}
