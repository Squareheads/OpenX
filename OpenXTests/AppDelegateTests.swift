//
//  Copyright © 2018 Squareheads. All rights reserved.
//

import XCTest
@testable import OpenX

class AppDelegateTests: XCTestCase {

    private var exitSpyCallCount: Int = 0
    private var appDelegate: AppDelegate!

    override func setUp() {
        super.setUp()
        appDelegate = AppDelegate()
        appDelegate.exitFunction = exitSpy
        exitSpyCallCount = 0
    }

    override func tearDown() {
        exitSpyCallCount = 0
        super.tearDown()
    }

    func testOpenFiles_MissingExtension_ExitsApp() {

        appDelegate.application(NSApplication.shared, openFiles: ["file"])

        XCTAssertEqual(exitSpyCallCount, 1)
    }

    func testOpenFiles_WrongExtension_ExitsApp() {

        appDelegate.application(NSApplication.shared, openFiles: ["file.txt"])

        XCTAssertEqual(exitSpyCallCount, 1)
    }

    func testOpenFiles_NonExistentProject_ExitsApp() {

        let folder = createTestFolder()
        let path = folder.path.appendingPathComponent("test123project.xcodeproj").path

        appDelegate.application(NSApplication.shared, openFiles: [path])

        XCTAssertEqual(exitSpyCallCount, 1)
    }

    func testOpenFiles_NonExistentWorkspace_ExitsApp() {

        let folder = createTestFolder()
        let path = folder.path.appendingPathComponent("test456project.xcworkspace").path

        appDelegate.application(NSApplication.shared, openFiles: [path])

        XCTAssertEqual(exitSpyCallCount, 1)
    }


    func testOpenFiles_ExistentProject_DoesNotExitApp() {

        let folder = createTestFolder()
        let path = addTestProject(to: folder, name: "testProject")

        appDelegate.application(NSApplication.shared, openFiles: [path])

        XCTAssertEqual(exitSpyCallCount, 0)
    }

    func testOpenFiles_ExistentWorkspace_DoesNotExitApp() {

        let folder = createTestFolder()
        let path = addTestWorkspace(to: folder, name: "testWorkspace")

        appDelegate.application(NSApplication.shared, openFiles: [path])

        XCTAssertEqual(exitSpyCallCount, 0)
    }

    func exitSpy() {
        exitSpyCallCount += 1
    }

}
