//
//  Copyright © 2018 Squareheads. All rights reserved.
//

import Foundation
import XCTest

class TestFolder {

    let path: URL

    private let fileManager: FileManager

    init(rootPath: URL) {
        let folderUUID = UUID.init()
        let folderUUIDString = folderUUID.uuidString
        let pathToTestFolder = rootPath.appendingPathComponent(folderUUIDString, isDirectory: true)
        self.fileManager = FileManager.default
        do {
            try fileManager.createDirectory(at: pathToTestFolder, withIntermediateDirectories: true, attributes: nil)
        } catch {
            fatalError("Could not create test folder")
        }

        path = pathToTestFolder
    }

    deinit {
        cleanup()
    }

    func cleanup() {
        do {
            try fileManager.removeItem(at: path)
        } catch {
            fatalError("Error cleaning up test folder at path \(path)")
        }
    }
}


func createTestFolder() -> TestFolder {
    guard let cachesDirectory: URL = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first else {
        fatalError("Could not get cache folder for tests")
    }

    return TestFolder(rootPath: cachesDirectory)
}

func addTestXcode(to folder: TestFolder, version: String, icon: String? = nil) {
    let fileManager = FileManager.default
    let appPath = folder.path.appendingPathComponent("Xcode\(version).app", isDirectory: true)
    let contentsPath = appPath.appendingPathComponent("Contents", isDirectory: true)
    let macOSPath = contentsPath.appendingPathComponent("MacOS", isDirectory: true)
    let xcodeBinaryPath = macOSPath.appendingPathComponent("Xcode", isDirectory: false)
    let versionPlistPath = contentsPath.appendingPathComponent("version.plist", isDirectory: false)
    let infoPlistPath = contentsPath.appendingPathComponent("Info.plist", isDirectory: false)


    let propertyListWithVersion = ["CFBundleShortVersionString":version]
    let propertyListWithIcon = ["CFBundleIconFile":icon]
    let format = PropertyListSerialization.PropertyListFormat.xml

    do {
        try fileManager.createDirectory(at: macOSPath, withIntermediateDirectories: true, attributes: nil)
        let data = "Fake Xcode".data(using: .utf8)
        fileManager.createFile(atPath: xcodeBinaryPath.path, contents: data, attributes: nil)

        let propertyListVersionData = try PropertyListSerialization.data(fromPropertyList: propertyListWithVersion, format: format, options: PropertyListSerialization.WriteOptions())
        try propertyListVersionData.write(to: versionPlistPath)

        let propertyListIconData = try PropertyListSerialization.data(fromPropertyList: propertyListWithIcon, format: format, options: PropertyListSerialization.WriteOptions())
        try propertyListIconData.write(to: infoPlistPath)


    } catch {
        fatalError("Could not create test xcode files")
    }
}

func addTestProject(to folder: TestFolder, name: String) -> String {
    let fileManager = FileManager.default
    let outputPath = folder.path.appendingPathComponent("\(name).xcodeproj")

    do {
        try fileManager.createDirectory(at: outputPath, withIntermediateDirectories: true, attributes: nil)
        return outputPath.path
    } catch {
        fatalError("Could not create test xcode files")
    }
}

func addTestWorkspace(to folder: TestFolder, name: String) -> String {
    let fileManager = FileManager.default
    let outputPath = folder.path.appendingPathComponent("\(name).xcworkspace")


    do {
        try fileManager.createDirectory(at: outputPath, withIntermediateDirectories: true, attributes: nil)
        return outputPath.path
    } catch {
        fatalError("Could not create test xcode files")
    }
}

