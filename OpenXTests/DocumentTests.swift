//
//  Copyright © 2018 Squareheads. All rights reserved.
//

import XCTest
@testable import OpenX

class DocumentTests: XCTestCase {

    private var exitSpyCallCount: Int = 0
    private var document: Document!

    override func setUp() {
        super.setUp()
        document = Document()
        document.exitFunction = exitSpy
        exitSpyCallCount = 0
    }

    override func tearDown() {
        exitSpyCallCount = 0
        super.tearDown()
    }

    func testOpenFiles_MissingExtension_ExitsApp() {
        let url = URL.init(fileURLWithPath: "file")
        try? document.read(from: url, ofType: "")

        XCTAssertEqual(exitSpyCallCount, 1)
    }

    func testOpenFiles_WrongExtension_ExitsApp() {

        let url = URL.init(fileURLWithPath: "file.txt")
        try? document.read(from: url, ofType: "")

        XCTAssertEqual(exitSpyCallCount, 1)
    }

    func testOpenFiles_NonExistentProject_ExitsApp() {

        let folder = createTestFolder()
        let path = folder.path.appendingPathComponent("test123project.xcodeproj").path
        let url = URL.init(fileURLWithPath: path)

        try? document.read(from: url, ofType: "")

        XCTAssertEqual(exitSpyCallCount, 1)
    }

    func testOpenFiles_NonExistentWorkspace_ExitsApp() {

        let folder = createTestFolder()
        let path = folder.path.appendingPathComponent("test456project.xcworkspace").path

        let url = URL.init(fileURLWithPath: path)

        try? document.read(from: url, ofType: "")

        XCTAssertEqual(exitSpyCallCount, 1)
    }


    func testOpenFiles_ExistentProject_DoesNotExitApp() {

        let folder = createTestFolder()
        let path = addTestProject(to: folder, name: "testProject")

        let url = URL.init(fileURLWithPath: path)

        try? document.read(from: url, ofType: "")

        XCTAssertEqual(exitSpyCallCount, 0)
    }

    func testOpenFiles_ExistentWorkspace_DoesNotExitApp() {

        let folder = createTestFolder()
        let path = addTestWorkspace(to: folder, name: "testWorkspace")

        let url = URL.init(fileURLWithPath: path)

        try? document.read(from: url, ofType: "")

        XCTAssertEqual(exitSpyCallCount, 0)
    }

    func exitSpy() {
        exitSpyCallCount += 1
    }

}
