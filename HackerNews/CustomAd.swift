//
//  customAd.swift
//  HackerNews
//
//  Created by Iain Munro on 04/01/2017.
//  Copyright © 2017 Amit Burstein. All rights reserved.
//

import Foundation
import PocketMediaNativeAds

/**
 Standard AdUnit for TableView
 **/
open class CustomAd: AbstractAdUnitTableViewCell {
  
    @IBOutlet weak var adDescription: UILabel!
    @IBOutlet weak var adName: UILabel!
    @IBOutlet weak var adImage: UIImageView!
    @IBOutlet weak var callToAction: UIButton!
    
    open override func render(_ nativeAd: NativeAd) {
        super.render(nativeAd)
        self.adName?.text = nativeAd.campaignName
        self.adDescription?.text = nativeAd.campaignDescription
        self.adImage.nativeSetImageFromURL(nativeAd.campaignImage)
        self.callToAction.setTitle(nativeAd.callToActionText, for: UIControlState.normal)
    }
  
}
