//
//  GNTheme.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 4/25/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import Cocoa

extension NSColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

class GNTheme: NSObject {
    
    static let themesByName:Dictionary<String,GNTheme> = ["Yellow" : GNTheme.yellowTheme(),
                                                          "Purple" : GNTheme.purpleTheme(),
                                                          "White" : GNTheme.whiteTheme(),
                                                          "Blue" : GNTheme.blueTheme(),
                                                          "Green" : GNTheme.greenTheme(),
                                                          "Pink" : GNTheme.pinkTheme()]
    var name:NSString = ""
    var boldButtonImage:NSImage?
    var italicButtonImage:NSImage?
    var bulletListButtonImage:NSImage?
    var numberedListButtonImage:NSImage?
    var todoListButtonImage:NSImage?
    var settingsButtonImage:NSImage?
    var appModeArrowImage:NSImage?
    var docModeArrowImage:NSImage?
    
    var backgroundColor:NSColor = NSColor()
    var gradientStartColor:NSColor = NSColor()
    var textColor:NSColor = NSColor()
    var lineColor:NSColor = NSColor()

    static func yellowTheme() -> GNTheme {

        let themeToReturn = GNTheme()
        themeToReturn.name = "Yellow"
        themeToReturn.backgroundColor = NSColor(netHex: 0xFFECAF) //GNYellow
        themeToReturn.gradientStartColor = NSColor(netHex:0xFFF5CC)
        themeToReturn.textColor = NSColor(netHex:0x443401)
        themeToReturn.lineColor = NSColor(netHex:0xA49876)
        return themeToReturn
    }
    
    static func blueTheme() -> GNTheme {
        let themeToReturn = GNTheme()
        themeToReturn.name = "Blue"
        themeToReturn.backgroundColor = NSColor(netHex: 0xBFFFFF) //GNBlue
        themeToReturn.gradientStartColor = NSColor(netHex:0xD0FFFF)
        themeToReturn.textColor = NSColor(netHex:0x1A5A5A)
        themeToReturn.lineColor = NSColor(netHex:0x6FA8A8)
        return themeToReturn
    }
    
    static func greenTheme() -> GNTheme {
        let themeToReturn = GNTheme()
        themeToReturn.name = "Green"
        themeToReturn.backgroundColor = NSColor(netHex: 0xDFFFBF) //GNGreen
        themeToReturn.gradientStartColor = NSColor(netHex:0xE5FFCB)
        themeToReturn.textColor = NSColor(netHex:0x385818)
        themeToReturn.lineColor = NSColor(netHex:0x8AA76E)
        return themeToReturn
    }
    
    static func pinkTheme() -> GNTheme {
        let themeToReturn = GNTheme()
        themeToReturn.name = "Pink"
        themeToReturn.backgroundColor = NSColor(netHex: 0xFFBFBF) //GNPink
        themeToReturn.gradientStartColor = NSColor(netHex:0xFFD8D8)
        themeToReturn.textColor = NSColor(netHex:0x743434)
        themeToReturn.lineColor = NSColor(netHex:0xBB8989)
        return themeToReturn
    }
    
    static func purpleTheme() -> GNTheme {
        let themeToReturn = GNTheme()
        themeToReturn.name = "Purple"
        themeToReturn.backgroundColor = NSColor(netHex: 0x323E58) //GNPurple
        themeToReturn.gradientStartColor = NSColor(netHex:0x465267)
        themeToReturn.textColor = NSColor(netHex:0x8D99B1)
        themeToReturn.lineColor = NSColor(netHex:0x29344C)
        return themeToReturn
    }
    
    static func whiteTheme() -> GNTheme {
        let themeToReturn = GNTheme()
        themeToReturn.name = "White"
        themeToReturn.backgroundColor = NSColor(netHex: 0xFEFDFE) //GNWhite
        themeToReturn.gradientStartColor = NSColor(netHex:0xFFFFFF)
        themeToReturn.textColor = NSColor(netHex:0x474747)
        themeToReturn.lineColor = NSColor(netHex:0x8D99B1)
        return themeToReturn
    }
}
