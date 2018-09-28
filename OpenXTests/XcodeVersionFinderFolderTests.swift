//
//  Copyright © 2018 Squareheads. All rights reserved.
//

import XCTest
@testable import OpenX

class XcodeVersionFinderFolderTests: XCTestCase {

    func testFinder_WithEmptyFolder_ReturnsNoEntries() {
        let testFolder = createTestFolder()

        let finder = XcodeVersionFinderFolder(searchPath: testFolder.path)

        XCTAssertEqual(finder.find().count, 0)
    }

    func testFinder_WithSingleFolder_ReturnsSingleEntry() {

        let testFolder = createTestFolder()
        addTestXcode(to: testFolder, version: "9.0", icon: "Xcode")
        
        let finder = XcodeVersionFinderFolder(searchPath: testFolder.path)

        let expectedIconPath = testFolder.path
            .appendingPathComponent("Xcode9.0.app", isDirectory: true)
            .appendingPathComponent("Contents", isDirectory: true)
            .appendingPathComponent("Resources", isDirectory: true)
            .appendingPathComponent("Xcode.icns", isDirectory: false)

        let expectedAppPath = testFolder.path
            .appendingPathComponent("Xcode9.0.app", isDirectory: true)

        XCTAssertEqual(finder.find().count, 1)
        XCTAssertEqual(finder.find().first?.version, "9.0")
        XCTAssertEqual(finder.find().first?.icon, expectedIconPath)
        XCTAssertEqual(finder.find().first?.appPath, expectedAppPath)
    }

    func testFinder_WithTwoFoldersFolder_ReturnsTwoEntries() {

        let testFolder = createTestFolder()
        addTestXcode(to: testFolder, version: "9.0", icon: "Xcode")
        addTestXcode(to: testFolder, version: "9.1", icon: "BetaIcon")

        let finder = XcodeVersionFinderFolder(searchPath: testFolder.path)

        let expectedIconPathOne = testFolder.path
            .appendingPathComponent("Xcode9.0.app", isDirectory: true)
            .appendingPathComponent("Contents", isDirectory: true)
            .appendingPathComponent("Resources", isDirectory: true)
            .appendingPathComponent("Xcode.icns", isDirectory: false)


        let expectedIconPathTwo = testFolder.path
            .appendingPathComponent("Xcode9.1.app", isDirectory: true)
            .appendingPathComponent("Contents", isDirectory: true)
            .appendingPathComponent("Resources", isDirectory: true)
            .appendingPathComponent("BetaIcon.icns", isDirectory: false)

        let expectedAppPathOne = testFolder.path
            .appendingPathComponent("Xcode9.0.app", isDirectory: true)

        let expectedAppPathTwo = testFolder.path
            .appendingPathComponent("Xcode9.1.app", isDirectory: true)


        XCTAssertEqual(finder.find().count, 2)
        XCTAssertEqual(finder.find()[0].version, "9.0")
        XCTAssertEqual(finder.find()[0].icon, expectedIconPathOne)
        XCTAssertEqual(finder.find()[0].appPath, expectedAppPathOne)

        XCTAssertEqual(finder.find()[1].version, "9.1")
        XCTAssertEqual(finder.find()[1].icon, expectedIconPathTwo)
        XCTAssertEqual(finder.find()[1].appPath, expectedAppPathTwo)

    }
}
