//
//  Copyright © 2018 Squareheads. All rights reserved.
//

import Cocoa

class Document: NSDocument {

    class func exitApp() {
        exit(0)
    }

    var exitFunction: (() -> Void) = Document.exitApp
    private let fileManager = FileManager.default

    override class var autosavesInPlace: Bool {
        return true
    }

    override var isEntireFileLoaded: Bool {
        return false
    }

    override func makeWindowControllers() {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController
        self.addWindowController(windowController)
    }

    override func data(ofType typeName: String) throws -> Data {
        // Insert code here to write your document to data of the specified type, throwing an error in case of failure.
        // Alternatively, you could remove this method and override fileWrapper(ofType:), write(to:ofType:), or write(to:ofType:for:originalContentsURL:) instead.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    override func read(from url: URL, ofType typeName: String) throws {
        let fileURL = url
        guard fileURL.pathExtension == "xcodeproj" || fileURL.pathExtension == "xcworkspace" else { return exitFunction() }
        guard fileManager.fileExists(atPath: fileURL.path) else { return exitFunction() }
        AppDelegate.GlobalFileBeingOpened = fileURL

    }


}

