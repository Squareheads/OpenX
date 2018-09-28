//
//  Copyright © 2018 Squareheads. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var collectionView: NSCollectionView!

    private let xcodeFinder: XcodeVersionFinderFolder = XcodeVersionFinderFolder(searchPath: URL(fileURLWithPath: "/Applications", isDirectory: true))

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    private func configureCollectionView() {

        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 160.0, height: 140.0)
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
        let versions = xcodeFinder.find()
        guard let indexPath = collectionView.indexPath(for: item) else { return }
        guard indexPath.item >= 0 && indexPath.item <= versions.count else { return }
        let version = versions[indexPath.item]
        NSLog("Did select xcode version \(version.version)")
    }
}

extension ViewController : NSCollectionViewDataSource {

    func numberOfSectionsInCollectionView(collectionView: NSCollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return xcodeFinder.find().count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let xcodeVersion = xcodeFinder.find()[indexPath.item]
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
