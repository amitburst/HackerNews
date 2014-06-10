//
//  MainTableViewController.swift
//  HackerNews
//
//  Copyright (c) 2014 Amit Burstein. All rights reserved.
//  See LICENSE for licensing information.
//
//  Abstract:
//      Handles fetching and displaying posts from Hacker News.
//

import UIKit

class MainTableViewController: UITableViewController, UITableViewDataSource {
    
    // MARK: Properties

    let postCellIdentifier = "PostCell"
    let showBrowserIdentifier = "ShowBrowser"
    var posts = HNPost[]()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRefreshControl()
        fetchPosts()
    }
    
    // MARK: Configuration
    
    func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchPosts", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        self.refreshControl = refreshControl
    }
    
    // MARK: Post Fetching
    
    func fetchPosts() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        
        HNManager.sharedManager().loadPostsWithFilter(.Top, completion: { posts in
            self.posts = posts as HNPost[]
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
                self.refreshControl.endRefreshing()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
        })
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier(postCellIdentifier) as UITableViewCell
        
        let post = posts[indexPath.row]
        
        cell.textLabel.text = post.Title
        cell.detailTextLabel.text = "\(post.Points) points by \(post.Username)"
        
        return cell
    }
    
    // MARK: UIViewController
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == showBrowserIdentifier {
            let webView = segue.destinationViewController as BrowserViewController
            let cell = sender as UITableViewCell
            let post = posts[tableView.indexPathForCell(cell).row]

            webView.post = post
        }
    }
    
}
