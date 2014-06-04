//
//  BrowserViewController.swift
//  HackerNews
//
//  Created by Amit Burstein on 6/3/14.
//  Copyright (c) 2014 Amit Burstein. All rights reserved.
//

import Foundation
import UIKit

class BrowserViewController : UIViewController {
    
    // MARK: Properties
    
    @IBOutlet var webView : UIWebView
    var urlToLoad = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: self.urlToLoad)
        let request = NSURLRequest(URL: url)
        self.webView.loadRequest(request)
    }
    
    
}