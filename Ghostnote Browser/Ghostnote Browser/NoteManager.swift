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
    
    let searchController = NoteSearchController()
    
    let store = try! Realm()
    var appSupportDir = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .AllDomainsMask, true)

    var notes:Results<Note> {
        get {
            if searchController.isSearching {
                return searchController.results
            }
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
            print(error)
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
            print(error)
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