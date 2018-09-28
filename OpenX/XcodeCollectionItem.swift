//
//  Copyright © 2018 Squareheads. All rights reserved.
//

import Cocoa

protocol XcodeCollectionItemDelegate: class {
    func didSelectXcodeItem(_ item: XcodeCollectionItem)
}

class XcodeCollectionItem: NSCollectionViewItem {

    weak var delegate: XcodeCollectionItemDelegate?

    override func prepareForReuse() {
        super.prepareForReuse()
        textField?.stringValue = ""
        imageView?.image = nil
        delegate = nil
    }

    override func mouseDown(with event: NSEvent) {
        delegate?.didSelectXcodeItem(self)
    }
}
