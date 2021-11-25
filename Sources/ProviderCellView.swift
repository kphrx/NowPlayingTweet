/**
 *  ProviderCellView.swift
 *  NowPlayingTweet
 *
 *  © 2019 kPherox.
**/

import Cocoa

class ProviderCellView: NSTableCellView {

    override var objectValue: Any? {
        didSet {
            guard let provider = self.objectValue as? Provider else {
                return
            }

            self.textField?.stringValue = String(describing: provider)
            self.imageView?.image = provider.brand

            if self.imageView?.image != nil {
                self.textField?.isHidden = true
            }
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }

}
