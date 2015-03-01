//
//  AppDelegate.swift
//  HackerNews
//
//  Copyright (c) 2014 Amit Burstein. All rights reserved.
//  See LICENSE for licensing information.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Properties
    
    let GlobalTintColor = UIColor(red: 1.0, green: 0.4, blue: 0.0, alpha: 1.0)
    
    var window: UIWindow?

    // MARK: UIApplicationDelegate
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        HNManager.sharedManager().startSession()
        configureUI()
        return true
    }
    
    // MARK: Functions
    
    func configureUI() {
        window?.tintColor = GlobalTintColor
        UISwitch.appearance().onTintColor = window?.tintColor
    }

}
