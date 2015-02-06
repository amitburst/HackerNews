//
//  SettingsViewController.swift
//  HackerNews
//
//  Created by Amit Burstein on 1/25/15.
//  Copyright (c) 2015 Amit Burstein. All rights reserved.
//

import UIKit

protocol NightModeSwitchChangedDelegate: class {
    func NightModeChanged(nightModeSwitcher: UISwitch)
}


class SettingsViewController: UITableViewController {
    
    var delegate : NightModeSwitchChangedDelegate?
    
    var isNightMode = false
    
    
    @IBOutlet weak var nightModeSwitch: UISwitch!
    // MARK: IBActions
    
    @IBAction func NightMode(sender: UISwitch) {
        delegate?.NightModeChanged(sender)
        if sender.on {
            NightModeConfiguration()
    
        } else {
            DayModeConfiguration()
        
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        
        if isNightMode {
            nightModeSwitch.on = true
            NightModeConfiguration()
        } else {
            nightModeSwitch.on = false
        }
    }
    
    
    
    @IBAction func closeModal(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func DayModeConfiguration() {
        view.backgroundColor = UIColor(red: 0.937255, green: 0.937255, blue: 0.956863, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.blackColor() ]
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        cell?.backgroundColor = UIColor.whiteColor()
        let label = cell?.viewWithTag(100) as UILabel
        label.textColor = UIColor.blackColor()
        

    }
    
    func NightModeConfiguration() {
        
        view.backgroundColor = UIColor.blackColor()
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        cell?.backgroundColor = UIColor.blackColor()
        let label = cell?.viewWithTag(100) as UILabel
        label.textColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor() ]
       
        
        
    }
    
    
}
