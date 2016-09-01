//
//  DocumentIconProviderTests.swift
//  Ghostnote Browser
//
//  Created by Jimmy Hough Jr on 8/14/16.
//  Copyright © 2016 Ghostnnote HQ. All rights reserved.
//

import XCTest

@testable import Ghostnote_Browser

class DocumentIconProviderTests: XCTestCase {

    let genericDocImageTiff = NSWorkspace.sharedWorkspace().iconForFileType(NSFileTypeForHFSTypeCode(OSType(kGenericDocumentIcon))).TIFFRepresentation

}
