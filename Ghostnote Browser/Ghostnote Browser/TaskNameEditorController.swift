//
//  TaskNameEditorController.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 6/14/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

class TaskNameEditorController: NSObject, TextEditingVCClient {

    var editVC:TextEditingVC? = nil
    var hostingViewController:NSViewController? = nil
    
    var editingTask:Task? = nil
    
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleEditTaskTitle(_:)),
                                                         name: "EditTaskTitle",
                                                         object: nil)
    }

    // Notifcation Handlers
    
    func handleEditTaskTitle(notifcation:NSNotification) {
        
        if editVC == nil {
            if let taskCell = notifcation.object as? TaskCell {
                if let task = taskCell.task {
                    editingTask = task
                    if let editButton = taskCell.editButton {
                        
                        editVC = TextEditingVC(nibName: "TextEditingVC",
                                               bundle: nil)
                        editVC?.client = self
                        editVC?.currentTitle = task.title
                        
                        hostingViewController?.presentViewController(editVC!,
                                                                     asPopoverRelativeToRect: editButton.bounds,
                                                                     ofView: editButton,
                                                                     preferredEdge: .MaxY,
                                                                     behavior: .ApplicationDefined)
                    }
                    
                }
                
            }
        }
    }
    
    // TextEditingVCClient
    func choseText(text: String) {
        print("chose \(text)")
        
        if text != editingTask?.title {
            TaskListManager.shared.changeTask(editingTask!, to: text)
        }
        dismiss()
    }
    
    func canceled() {
        dismiss()
    }
    
    
    func dismiss() {
        if let vc = editVC {
            hostingViewController?.dismissViewController(vc)
            cleanUp()
        }
    }
    
    func cleanUp() {
        editVC = nil
        editingTask = nil
    }
}
