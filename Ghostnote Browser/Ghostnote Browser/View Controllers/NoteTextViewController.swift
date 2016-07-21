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
                                                         name: "NoteDeleted",
                                                         object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleEditNote),
                                                         name: "EditNote",
                                                         object: nil)
    }
    
    weak var placeholderLabel:NSTextField?
    
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
                loadTips()
            }
            applyPlaceHolderState()
        }
    }
    
    var noteTextView:NSTextView? {
        didSet {
            noteTextView?.delegate = self
            noteTextView?.wantsLayer = true
            noteTextView?.richText = true
            noteTextView?.font = NSFont(name: "HelveticaNeue", size: 12.0)
            noteTextView?.linkTextAttributes = [NSForegroundColorAttributeName : NSColor.gnBlue()]
        }
    }
    
    
    func applyPlaceHolderState() {
        if let text = noteTextView?.string {
            placeholderLabel?.hidden = !text.isEmpty
        }else {
            placeholderLabel?.hidden = false
        }
    }
    
    func textDidChange(notification: NSNotification) {
        if notification.object as? NSTextView == noteTextView {
            if let note = currentNote {
                if !note.invalidated {
                    noteTextView!.writeRTFDToFile(note.filePath, atomically: true)
                }
            }
            applyPlaceHolderState()
        }
    }
    
    func handleDeletedNote(notif:NSNotification) {
        
//        if currentNote?.invalidated == true {
            noteTextView?.string = ""
//        }
    }
    
    func handleEditNote() {
        noteTextView?.window?.makeFirstResponder(noteTextView)
    }
    
    func loadTips() {
//        let path = NoteManager.shared.appSupportDir.first!
//        let baseURL = NSURL(fileURLWithPath: path).URLByAppendingPathComponent("com.ghostnoteapp.Ghostnote-Browser")
//        
//        let tipsURL = baseURL.URLByAppendingPathComponent("Tips", isDirectory: true).URLByAppendingPathComponent("Tips.html")
//        
//
//        if let htmlData = NSData(contentsOfURL: tipsURL) {
//            noteTextView?.textStorage?.appendAttributedString(NSAttributedString(HTML: htmlData, baseURL: baseURL, documentAttributes: nil)!)
//        }
        
    }
}
