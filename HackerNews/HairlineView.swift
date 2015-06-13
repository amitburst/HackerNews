//
//  HairlineView.swift
//  HackerNews
//
//  Copyright (c) 2015 Amit Burstein. All rights reserved.
//  See LICENSE for licensing information.
//

import UIKit

class HairlineView : UIView {
    
    // MARK: UINibLoading
    
    override func awakeFromNib() {
        layer.borderColor = backgroundColor?.CGColor
        layer.borderWidth = (1.0 / UIScreen.mainScreen().scale) / 2
        backgroundColor = UIColor.clearColor()
    }
    
}
