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
import XCGLogger

class NoteManager {
    
    static let shared = NoteManager()
    
    let searchController = NoteSearchController()
    
    let store = try! Realm()
    var appSupportDir = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .AllDomainsMask, true)

    var notes:Array<Note> {
        get {
            if searchController.isSearching {
                return searchController.results
            }
            return Array<Note>(store.objects(Note))
        }
    }
    
    func copyWelcomeNoteFile() {

        createNotesFolderIfNeeded()
        let path = appSupportDir.first!
        
        let docsURL = NSURL(fileURLWithPath: path).URLByAppendingPathComponent("com.ghostnoteapp.Ghostnote-Browser").URLByAppendingPathComponent("Notes", isDirectory: true)
        let welcomeBundleURL = NSBundle.mainBundle().URLForResource("Welcome to Ghostnote!", withExtension: "rtfd")
        
        let destinationURL = docsURL.URLByAppendingPathComponent("Welcome to Ghostnote!").URLByAppendingPathExtension("rtfd")
        do {
            try NSFileManager.defaultManager().copyItemAtURL(welcomeBundleURL!, toURL: destinationURL)
        }
        catch {
            XCGLogger.error("\(error)")
        }
        
        
        let note = Note()
        // this should maybe bail if the file cant be created
        
        do {
            try store.write({
                note.name = "Welcome to Ghostnote!"
                note.creationDate = NSDate()
                note.filePath = destinationURL.path!
                store.add(note)
                
            })
        }
        catch {
            XCGLogger.error("\(error)")
        }
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasCreatedWelcomeNote")
        
        NSNotificationCenter.defaultCenter().postNotificationName("NoteAdded", object: note)

        
        
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
                
            })
        }
        catch {
            XCGLogger.error("\(error)")
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("NoteAdded", object: note)
    }
    
    func deleteNote(note:Note) {
        
        // this shouldmaybe bail if file cant be created
        removeFileForNoteNamed(note.name)
        
        do {
            try store.write({ 
                store.delete(note)
            })
            NSNotificationCenter.defaultCenter().postNotificationName("NoteDeleted", object: nil)

        }
        catch {
            XCGLogger.error("\(error)")
        }
        
    }
    
    func renameNote(note:Note, toName:String) {
        
        let newPath = renameNoteFileForNote(note, to: toName)
    
        do {
            try store.write({ 
                note.filePath = newPath.path!
                note.name = toName
                
                store.add(note, update: true)
            })
        }
        catch {
            
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
                XCGLogger.error("\(error)")
            }

        }
    }
    
    
    //
    
    func newNoteNameSuffix() -> String {
        
        let count = notes.filter { (note) -> Bool in
                if note.name.containsString("New Note") {
                    return true
                }else {
                    return false
                }
            }.count
        if count > 0 {
            return "\(count + 1)"
        }
        return ""
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
                XCGLogger.error("\(error)")
            }
           
        }
        catch {
            XCGLogger.error("\(error)")
        }

        return fileURL
    }
    
    private func renameNoteFileForNote(note:Note, to:String) -> NSURL {
        
        
        let fileManager = NSFileManager.defaultManager()
        
        let currentName = note.filePath as NSString
        
        let file = currentName.stringByDeletingPathExtension as NSString
        let path = file.stringByDeletingLastPathComponent
        
        let newPath = path.stringByAppendingString("/").stringByAppendingString(to).stringByAppendingString(".rtfd")
//            path
        
        if fileManager.fileExistsAtPath(newPath) == true {
            
        }
        
        do {
            try fileManager.moveItemAtPath(note.filePath, toPath: newPath )
        }
        catch {
            XCGLogger.error("\(error)")
        }
        return NSURL(fileURLWithPath: newPath)
    }
    
    private func removeFileForNoteNamed(name:String) {
        let path = appSupportDir.first!
        
        let docsURL = NSURL(fileURLWithPath: path).URLByAppendingPathComponent("com.ghostnoteapp.Ghostnote-Browser").URLByAppendingPathComponent("Notes", isDirectory: true)
        
        let fileURL = docsURL.URLByAppendingPathComponent(name).URLByAppendingPathExtension("rtfd")
        
        do {
            try NSFileManager.defaultManager().removeItemAtURL(fileURL)
        }
        catch {
            XCGLogger.error("\(error)")
        }
    }
    
    func canName(name:String) -> Bool {
        let fileManager = NSFileManager.defaultManager()
        
        let path = appSupportDir.first!
        
        let docsURL = NSURL(fileURLWithPath: path).URLByAppendingPathComponent("com.ghostnoteapp.Ghostnote-Browser").URLByAppendingPathComponent("Notes", isDirectory: true)
        
        let filePath = docsURL.path
        
        let newPath = filePath!.stringByAppendingString("/").stringByAppendingString(name).stringByAppendingString(".rtfd")
        //            path
        
        return !fileManager.fileExistsAtPath(newPath)
    }

}