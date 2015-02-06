//
//  MyNavigationController.swift
//  MyLocation
//
//  Created by wangchi on 14/12/4.
//  Copyright (c) 2014年 wangchi. All rights reserved.
//

import Foundation
import UIKit

class MyNavigationController: UINavigationController {
    
    var isNightMode : Bool {
        let MainVC = presentingViewController as MainViewController
        return MainVC.isNightMode
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        if isNightMode {
            return UIStatusBarStyle.LightContent
            
        } else {
            return UIStatusBarStyle.Default
        }
    }
    
}
