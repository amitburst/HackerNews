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
open class CustomAd: UITableViewCell, NativeViewCell {
  
    @IBOutlet weak var adDescription: UILabel!
    @IBOutlet weak var adName: UILabel!
    @IBOutlet weak var adImage: UIImageView!
    @IBOutlet weak var callToAction: UIButton!
  
  /**
   Called to define what ad should be shown. Ad unit should call completion handler once static data like images or videos are downloaded. This is so that the automatic dimensions are recalculated.
   */
  public func render(_ nativeAd: NativeAd, completion handler: @escaping ((Bool) -> Void)) {
    self.adName?.text = nativeAd.campaignName
    self.adDescription?.text = nativeAd.campaignDescription
    self.adImage.nativeSetImageFromURL(nativeAd.campaignImage, completion: handler)
    self.callToAction.setTitle(nativeAd.callToActionText, for: UIControlState.normal)
  }
  
}
