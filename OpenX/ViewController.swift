//
//  Copyright © 2018 Squareheads. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var collectionView: NSCollectionView!
    var openedFilePath: URL?

    lazy var xcodeVersions: [XcodeVersion] = {
        XcodeVersionFinderFolder(searchPath: URL(fileURLWithPath: "/Applications", isDirectory: true)).find()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    private func configureCollectionView() {

        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 128, height: 128)
        flowLayout.sectionInset = NSEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0
        collectionView.collectionViewLayout = flowLayout

        view.wantsLayer = true

        collectionView.layer?.backgroundColor = NSColor.black.cgColor
    }
}

extension ViewController : XcodeCollectionItemDelegate {
    func didSelectXcodeItem(_ item: XcodeCollectionItem) {
        let versions = xcodeVersions
        guard let indexPath = collectionView.indexPath(for: item) else { return }
        guard indexPath.item >= 0 && indexPath.item <= versions.count else { return }
        let version = versions[indexPath.item]


        if let fileToOpen = openedFilePath {
            if NSWorkspace.shared.openFile(fileToOpen.path, withApplication: version.appPath.path, andDeactivate: true) {
                exit(0)
            } else {
                dialogOK(message: "Error", informative: "Error running xcode \(version.version)")

            }
        } else {
            if NSWorkspace.shared.launchApplication(version.appPath.path) {
                exit(0)
            } else {
                dialogOK(message: "Error", informative: "Error running xcode \(version.version)")
            }
        }
    }

    func dialogOK(message: String, informative: String) {
        let alert = NSAlert()
        alert.messageText = message
        alert.informativeText = informative
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}

extension ViewController : NSCollectionViewDataSource {

    func numberOfSectionsInCollectionView(collectionView: NSCollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return xcodeVersions.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let xcodeVersion = xcodeVersions[indexPath.item]
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "XcodeCollectionItem"), for: indexPath as IndexPath)
        item.textField?.stringValue = xcodeVersion.version

        item.textField?.font = NSFont.boldSystemFont(ofSize: 32)

        let shadow = NSShadow()
        shadow.shadowBlurRadius = 1
        shadow.shadowOffset = NSMakeSize(2, 2)
        shadow.shadowColor = NSColor.black
        item.textField?.shadow = shadow

        if let imagePath = xcodeVersion.icon {
            let image = NSImage(byReferencing: imagePath)
            item.imageView?.image = image
        }

        guard let collectionViewItem = item as? XcodeCollectionItem else {return item}
        collectionViewItem.delegate = self
        return collectionViewItem
    }

}
