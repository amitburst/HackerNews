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

import UIKit

class BrowserViewController : UIViewController, UIWebViewDelegate {
    
    // MARK: Properties
    
    @IBOutlet var webView: UIWebView
    var post = HNPost()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = post.Title
        loadUrl()
    }
    
    override func viewDidDisappear(animated: Bool) {
        if isMovingFromParentViewController() {
            webView.stopLoading()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    // MARK: Functions
    
    func loadUrl() {
        let url = NSURL(string: post.UrlString)
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }
    
    // MARK: IBActions
    
    @IBAction func showSharingOptions(sender : AnyObject) {
        let activityViewController = UIActivityViewController(activityItems: [String(post.Title), String(post.UrlString)], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypeAssignToContact, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll]
        navigationController.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: UIWebViewDelegate
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
}