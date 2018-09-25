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
        addTestXcode(to: testFolder, version: "9.0")
        
        let finder = XcodeVersionFinderFolder(searchPath: testFolder.path)

        XCTAssertEqual(finder.find().count, 1)
        XCTAssertEqual(finder.find().first?.version, "9.0")
    }

    func testFinder_WithTwoFoldersFolder_ReturnsTwoEntries() {

        let testFolder = createTestFolder()
        addTestXcode(to: testFolder, version: "9.0")
        addTestXcode(to: testFolder, version: "9.1")

        let finder = XcodeVersionFinderFolder(searchPath: testFolder.path)

        XCTAssertEqual(finder.find().count, 2)
        XCTAssertEqual(finder.find()[0].version, "9.0")
        XCTAssertEqual(finder.find()[1].version, "9.1")
    }
}
