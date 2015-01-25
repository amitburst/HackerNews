//
//  BrowserViewController.swift
//  HackerNews
//
//  Copyright (c) 2014 Amit Burstein. All rights reserved.
//  See LICENSE for licensing information.
//

import UIKit

class BrowserViewController : UIViewController, UIWebViewDelegate {
    
    // MARK: Properties
    
    var post: HNPost!
    var toolbarBarButtonItems: [UIBarButtonItem]?
    
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: Initialization
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        post = HNPost()
        toolbarBarButtonItems = toolbarItems as? [UIBarButtonItem]
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI();
        loadUrl()
    }
    
    override func viewDidDisappear(animated: Bool) {
        if isMovingFromParentViewController() {
            webView.stopLoading()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    // MARK: Functions
    
    func configureUI() {
        title = post.Title
    }
    
    func loadUrl() {
        let url = NSURL(string: post.UrlString)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
    
    // MARK: IBActions
    
    @IBAction func closeModal(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func showSharingOptions(sender : AnyObject) {
        let activityViewController = UIActivityViewController(activityItems: [String(post.Title), String(post.UrlString)], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypeAssignToContact, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll]
        navigationController?.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: UIWebViewDelegate
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        toolbarBarButtonItems?[0].enabled = webView.canGoBack
        toolbarBarButtonItems?[2].enabled = webView.canGoForward
    }
    
}
