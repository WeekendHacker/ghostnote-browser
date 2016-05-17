//
//  File.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/25/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa
import Foundation
import RealmSwift

class NoteManager {
    
    static let shared = NoteManager()
    
    let store = try! Realm()
    var appSupportDir = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .AllDomainsMask, true)

    var notes:Results<Note> {
        get {
            return store.objects(Note)
        }
    }
    
    func createNoteWithName(name:String) {
        
        let note = Note()
        let fileURL = createFileForNoteNamed(name)
        // this should maybe bail if the file cant be created
        
        do {
            try store.write({ 
                note.name = name
                note.creationDate = NSDate()
                note.filePath = fileURL.path!
                store.add(note)
                print(note)
            })
        }
        catch {
            print(error)
        }
    }
    
    func deleteNote(note:Note) {
        
        // this shouldmaybe bail if file cant be created
        removeFileForNoteNamed(note.name)
        
        do {
            try store.write({ 
                store.delete(note)
            })
        }
        catch {
            print(error)
        }
        
    }
    
    func createNotesFolderIfNeeded() {
        let path = appSupportDir.first!
        let docsURL = NSURL(fileURLWithPath: path).URLByAppendingPathComponent("com.ghostnoteapp.Ghostnote-Browser").URLByAppendingPathComponent("Notes", isDirectory: true)
        
        if !NSFileManager.defaultManager().fileExistsAtPath(docsURL.path!, isDirectory: nil) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtURL(docsURL, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                print(error)
            }

        }
    }
    
    // file methods
    private func createFileForNoteNamed(name:String) -> NSURL {
        createNotesFolderIfNeeded()
        let path = appSupportDir.first!
        
        let docsURL = NSURL(fileURLWithPath: path).URLByAppendingPathComponent("com.ghostnoteapp.Ghostnote-Browser").URLByAppendingPathComponent("Notes", isDirectory: true)
        
        let fileURL = docsURL.URLByAppendingPathComponent(name).URLByAppendingPathExtension("rtfd")
        let seed = NSAttributedString(string: "", attributes: nil)
        
        do  {
            
           let wrapper = try  seed.fileWrapperFromRange(NSRange(location: 0, length: seed.length), documentAttributes: [NSDocumentTypeDocumentAttribute : NSRTFTextDocumentType])

            do {
                 try wrapper.writeToURL(fileURL, options: .Atomic, originalContentsURL: nil)
            }
            catch{
                print(error)
            }
           
        }
        catch {
            print(error)
        }

        return fileURL
    }
    
    private func removeFileForNoteNamed(name:String) {
        let path = appSupportDir.first!
        
        let docsURL = NSURL(fileURLWithPath: path).URLByAppendingPathComponent("com.ghostnoteapp.Ghostnote-Browser").URLByAppendingPathComponent("Notes", isDirectory: true)
        
        let fileURL = docsURL.URLByAppendingPathComponent(name).URLByAppendingPathExtension("rtfd")
        
        do {
            try NSFileManager.defaultManager().removeItemAtURL(fileURL)
        }
        catch {
            print(error)
        }
    }
}