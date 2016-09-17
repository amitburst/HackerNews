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
    layer.borderColor = backgroundColor?.cgColor
    layer.borderWidth = (1.0 / UIScreen.main.scale) / 2
    backgroundColor = UIColor.clear
  }
}
