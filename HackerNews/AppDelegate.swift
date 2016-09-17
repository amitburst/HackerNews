//
//  AppDelegate.swift
//  HackerNews
//
//  Copyright (c) 2015 Amit Burstein. All rights reserved.
//  See LICENSE for licensing information.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  // MARK: Properties
  
  let GlobalTintColor = UIColor(red: 1.0, green: 0.4, blue: 0.0, alpha: 1.0)
  
  var window: UIWindow?
  
  // MARK: UIApplicationDelegate
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    configureUI()
    return true
  }
  
  // MARK: Functions
  
  func configureUI() {
    window?.tintColor = GlobalTintColor
  }
}
