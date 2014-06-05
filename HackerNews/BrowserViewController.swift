//
//  BrowserViewController.swift
//  HackerNews
//
//  Copyright (c) 2014 Amit Burstein. All rights reserved.
//  See LICENSE for licensing information.
//
//  Abstract:
//      Handles loading URLs for stories.
//

import Foundation
import UIKit

class BrowserViewController : UIViewController {
    
    // MARK: Properties
    
    @IBOutlet var webView : UIWebView
    var urlToLoad = ""
    var storyTitle = ""
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: urlToLoad)
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }
    
    // MARK: IBActions
    
    @IBAction func showSharingOptions(sender : AnyObject) {
        let activityViewController = UIActivityViewController(activityItems: [storyTitle, urlToLoad], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypeAssignToContact, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll]
        navigationController.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
}