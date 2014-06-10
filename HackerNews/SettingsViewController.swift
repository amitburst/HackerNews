//
//  SettingsViewController.swift
//  HackerNews
//
//  Copyright (c) 2014 Amit Burstein. All rights reserved.
//  See LICENSE for licensing information.
//
//  Abstract:
//      Handles displaying and controlling settings for the app.
//

import UIKit

class SettingsViewController : UITableViewController {
    
    // MARK: Properties
    
    @IBOutlet var markStoryReadOnOpenSwitch: UISwitch
    @IBOutlet var hideReadItemsSwitch: UISwitch
    @IBOutlet var sharingAirdropSwitch: UISwitch
    @IBOutlet var sharingEmailSwitch: UISwitch
    @IBOutlet var sharingMessageSwitch: UISwitch
    @IBOutlet var sharingFacebookSwitch: UISwitch
    @IBOutlet var sharingTwitterSwitch: UISwitch
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}