//
//  SettingsViewController.swift
//  HackerNews
//
//  Created by Amit Burstein on 1/25/15.
//  Copyright (c) 2015 Amit Burstein. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    // MARK: IBActions
    
    @IBAction func closeModal(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
