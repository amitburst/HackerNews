//
//  HairlineView.swift
//  HackerNews
//
//  Created by Amit Burstein on 6/11/14.
//  Copyright (c) 2014 Amit Burstein. All rights reserved.
//

import UIKit

class HairlineView : UIView {
    
    override func awakeFromNib() {
        layer.borderColor = backgroundColor.CGColor
        layer.borderWidth = (1.0 / UIScreen.mainScreen().scale) / 2
        backgroundColor = UIColor.clearColor()
    }
    
}