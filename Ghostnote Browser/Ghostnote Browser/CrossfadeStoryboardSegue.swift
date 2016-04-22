//
//  CrossfadeStoryboardSegue.swift
//  View Controller Transition Demo
//
//  Created by John Marstall on 3/20/15.
//  Copyright (c) 2015 John Marstall. All rights reserved.
//

import Cocoa

class CrossfadeStoryboard: NSStoryboardSegue {
    
    // make references to the source controller and destination controller
    override init(identifier: String?,
        source sourceController: AnyObject,
        destination destinationController: AnyObject) {
            var myIdentifier : String
            if identifier == nil {
                myIdentifier = ""
            } else {
                myIdentifier = identifier!
            }
            super.init(identifier: myIdentifier, source: sourceController, destination: destinationController)
    }
    
    
    override func perform() {
        
        // build from-to and parent-child view controller relationships
        let sourceViewController  = self.sourceController as! NSViewController
        let destinationViewController = self.destinationController as! NSViewController
        let containerViewController = sourceViewController.parentViewController! as! MainViewController
        
        // add destinationViewController as child
        containerViewController.insertChildViewController(destinationViewController, atIndex: 1)
        
        // get the size of destinationViewController
        var targetSize = destinationViewController.view.frame.size
        var targetWidth = destinationViewController.view.frame.size.width
        var targetHeight = destinationViewController.view.frame.size.height
        
        // prepare for animation
        sourceViewController.view.wantsLayer = true
        destinationViewController.view.wantsLayer = true
        
        //perform transition
        containerViewController.transitionFromViewController(sourceViewController, toViewController: destinationViewController, options: NSViewControllerTransitionOptions.Crossfade, completionHandler: nil)
        
        //resize view controllers
        sourceViewController.view.animator().setFrameSize(targetSize)
        destinationViewController.view.animator().setFrameSize(targetSize)
        
        //resize and shift window
        var currentFrame = containerViewController.view.window?.frame
        var currentRect = NSRectToCGRect(currentFrame!)
        var horizontalChange = (targetWidth - containerViewController.view.frame.size.width)/2
        var verticalChange = (targetHeight - containerViewController.view.frame.size.height)/2
        var newWindowRect = NSMakeRect(currentRect.origin.x - horizontalChange, currentRect.origin.y - verticalChange, targetWidth, targetHeight)
        containerViewController.view.window?.setFrame(newWindowRect, display: true, animate: true)
        
        // lose the sourceViewController, it's no longer visible
        containerViewController.removeChildViewControllerAtIndex(0)
    }
    
    
}

