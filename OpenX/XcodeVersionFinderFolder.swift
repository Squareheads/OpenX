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
                .sorted(by: { (first, second) -> Bool in
                    return first.version.compare(second.version) == .orderedAscending
                })
            return versions
        } catch {
            return []
        }
    }

    private func containsXcode(subfolder: String) -> XcodeVersion? {
        let absoluleFolder = self.searchPath.appendingPathComponent(subfolder, isDirectory: true)
        let binaryPath = absoluleFolder.appendingPathComponent("Contents", isDirectory: true).appendingPathComponent("MacOS", isDirectory: true).appendingPathComponent("Xcode", isDirectory: false)
        let versionPlistPath = absoluleFolder.appendingPathComponent("Contents", isDirectory: true).appendingPathComponent("version.plist", isDirectory: false)
        let infoPlistPath = absoluleFolder.appendingPathComponent("Contents", isDirectory: true).appendingPathComponent("Info.plist", isDirectory: false)

        let binaryExists = fileManager.fileExists(atPath: binaryPath.path)

        guard binaryExists == true else {
            return nil
        }

        guard let versionString = versionOfXcode(readFromPlistAtPath: versionPlistPath) else {
            return nil
        }

        let iconName = iconOfXcode(readFromPlistAtPath: infoPlistPath, inBaseFolder: absoluleFolder)

        return XcodeVersion(version: versionString, icon: iconName, appPath: absoluleFolder)
    }

    private func versionOfXcode(readFromPlistAtPath path: URL) -> String? {

        return stringValue(forKey: "CFBundleShortVersionString", inPlistAtPath: path)
    }

    private func iconOfXcode(readFromPlistAtPath path: URL, inBaseFolder baseFolder: URL) -> URL? {

        guard let iconName = stringValue(forKey: "CFBundleIconFile", inPlistAtPath: path) else { return nil }

        return baseFolder
            .appendingPathComponent("Contents", isDirectory: true)
            .appendingPathComponent("Resources", isDirectory: true)
            .appendingPathComponent(iconName, isDirectory: false)
            .appendingPathExtension("icns")
    }

    private func stringValue(forKey key: String, inPlistAtPath path: URL) -> String? {
        var format = PropertyListSerialization.PropertyListFormat.xml

        var value: String? = nil

        do {
            let data = try Data.init(contentsOf: path)
            let plistData = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: &format)
            let plistDict = plistData as? [String: Any]
            if let stringValue = plistDict?[key] as? String {
                value = stringValue
            }
        } catch {
            return nil
        }

        return value

    }

    private func fileIsDir(path: String) -> Bool {
        var isDir: ObjCBool = false;
        fileManager.fileExists(atPath: path, isDirectory: &isDir)
        return isDir.boolValue
    }
}
