//
//  Copyright © 2018 Squareheads. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    class func exitApp() {
        exit(0)
    }

    var exitFunction: (() -> Void) = AppDelegate.exitApp

    private let fileManager = FileManager.default

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func application(_ sender: NSApplication, openFiles filenames: [String]) {
        guard let file = filenames.first else { return exitFunction() }
        let fileURL = URL(fileURLWithPath: file)
        guard fileURL.pathExtension == "xcodeproj" || fileURL.pathExtension == "xcworkspace" else { return exitFunction() }
        guard fileManager.fileExists(atPath: fileURL.path) else { return exitFunction() }
    }


}

