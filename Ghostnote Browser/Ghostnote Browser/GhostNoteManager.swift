//
//  GhostnoteManager.swift
//  GhostNote
//
//  Created by Jimmy Hough Jr on 5/12/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Cocoa
import Foundation
import RealmSwift

class GhostNoteManager: NSObject {
    
    static let shared = GhostNoteManager()
    
    override init() {
        var  config = Realm.Configuration()
        
        config.fileURL =  NSURL(fileURLWithPath: appSupportDir.first!).URLByAppendingPathComponent("com.ghostnoteapp.Ghostnote/Default.realm")
        store = try! Realm(configuration: config)
    }
    
    let store:Realm
    
    var appSupportDir = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .AllDomainsMask, true)
    
    var docsURL: NSURL {
        get {
            let path = appSupportDir.first!
            
            return NSURL(fileURLWithPath: path).URLByAppendingPathComponent("com.ghostnoteapp.Ghostnote").URLByAppendingPathComponent("GhostNotes", isDirectory: true)
        }
    }
    
    var ghostNotes:Results<GhostNote> {
        get {
            return store.objects(GhostNote)
        }
    }
    
    func allAppBundleIDs() -> Array<String> {
        var ids = Array<String>()
        for id in store.objects(GhostNote) {
            ids.append(id.appBundleID)
        }
        return ids
    }
    
    func docNotesForApp(bundleID:String) -> Array<GhostNote> {
        
        var notes = Array<GhostNote>()
        
        for note in store.objects(GhostNote) {
            if note.appBundleID == bundleID {
                notes.append(note)
            }
        }
        
        return notes
    }
    
    func appNoteForApp(bundleID:String) -> GhostNote? {
        
        for note in store.objects(GhostNote) {
            if note.appBundleID == bundleID {
                if note.docID == AppNameProvider.displayNameForBundleID(bundleID) {
                    return note
                }
            }
        }
        return nil
    }
    
    func createNote(bundleID:String, docID:String, content:NSAttributedString?) {
        print("Creating note for \(bundleID), \(docID), content \(content)")
        // attributes should come from somehwere else!
        
        if docID.isEmpty {
            return
        }
        
        let seed = content ?? NSAttributedString(string: "", attributes: nil)
        
        let fileURL = createFileFor(bundleID, docID:docID, content:seed)
        let note = GhostNote()
        
        // this should maybe bail if the file cant be created
        
        do {
            try store.write({
                note.appBundleID = bundleID
                note.docID = docID
                note.filePath = fileURL.path!
                store.add(note)
                print(note)
            })
        }
        catch {
            print(error)
        }
    }
    
    func deleteNote(note:GhostNote) {
        
        // this shouldmaybe bail if file cant be created
        removeFileForNote(note.appBundleID, docID: note.docID)
        
        do {
            try store.write({
                store.delete(note)
            })
        }
        catch {
            print(error)
        }
    }
    
    // file methods
    
    private func appcontainerURLForBundleID(bundleID:String) -> NSURL {
        let name = AppNameProvider.displayNameForBundleID(bundleID)
        return docsURL.URLByAppendingPathComponent(name, isDirectory: true)
    }
    
    private func createAppContainerFolderFor(bundleID:String) {
        
        let containerURL = appcontainerURLForBundleID(bundleID)
        
        if !NSFileManager.defaultManager().fileExistsAtPath(containerURL.path!) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtURL(containerURL,
                                                                        withIntermediateDirectories: true,
                                                                        attributes: nil)
            }
            catch {
                print(error)
            }
            
        }
    }
    
    private func createFileFor(bundleID:String, docID:String, content:NSAttributedString) -> NSURL {
        
        createAppContainerFolderFor(bundleID)
        
        
        let docIDtoUse = docID.stringByReplacingOccurrencesOfString("/", withString: " ")
        
        let fileURL = appcontainerURLForBundleID(bundleID).URLByAppendingPathComponent(docIDtoUse, isDirectory: false).URLByAppendingPathExtension("rtfd")
        
        if docIDtoUse.isEmpty {
            print("empty docID for \(bundleID)")
            
        }
        print("fileURL = \(fileURL)")
        
        
        do  {
            
            let wrapper = try  content.fileWrapperFromRange(NSRange(location: 0, length: content.length), documentAttributes: [NSDocumentTypeDocumentAttribute : NSRTFTextDocumentType])
            
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
    
    private func removeFileForNote(bundleID:String, docID:String) {
        
    }
}