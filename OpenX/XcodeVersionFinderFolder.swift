//
//  Copyright © 2018 Squareheads. All rights reserved.
//

import Foundation

final class XcodeVersionFinderFolder {
    private let searchPath: URL
    private let fileManager: FileManager

    init(searchPath: URL) {
        self.searchPath = searchPath
        self.fileManager = FileManager.default
    }

    func find() -> [XcodeVersion] {

        do {
            let versions = try fileManager.contentsOfDirectory(atPath: searchPath.path)
                .filter {
                    fileIsDir(path: searchPath.appendingPathComponent($0, isDirectory: true).path)
                }
                .compactMap {
                    containsXcode(subfolder: $0)
                }
            return versions
        } catch {
            return []
        }
    }

    private func containsXcode(subfolder: String) -> XcodeVersion? {
        let absoluleFolder = self.searchPath.appendingPathComponent(subfolder, isDirectory: true)
        let binaryPath = absoluleFolder.appendingPathComponent("Contents", isDirectory: true).appendingPathComponent("MacOS", isDirectory: true).appendingPathComponent("Xcode", isDirectory: false)
        let versionPlistPath = absoluleFolder.appendingPathComponent("Contents", isDirectory: true).appendingPathComponent("version.plist", isDirectory: false)

        let binaryExists = fileManager.fileExists(atPath: binaryPath.path)

        guard binaryExists == true else {
            return nil
        }

        guard let versionString = versionOfXcode(readFromPlistAtPath: versionPlistPath) else {
            return nil
        }

        return XcodeVersion(version: versionString)
    }

    private func versionOfXcode(readFromPlistAtPath path: URL) -> String? {

        var format = PropertyListSerialization.PropertyListFormat.xml

        var version: String? = nil

        do {
            let data = try Data.init(contentsOf: path)
            let plistData = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: &format)
            let plistDict = plistData as? [String: String]
            version = plistDict?["CFBundleShortVersionString"]
        } catch {
            return nil
        }

        return version
    }

    private func fileIsDir(path: String) -> Bool {
        var isDir: ObjCBool = false;
        fileManager.fileExists(atPath: path, isDirectory: &isDir)
        return isDir.boolValue
    }
}
