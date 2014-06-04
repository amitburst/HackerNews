//
//  MainTableViewController.swift
//  HackerNews
//
//  Copyright (c) 2014 Amit Burstein. All rights reserved.
//  See LICENSE for licensing information.
//
//  Abstract:
//      Handles fetching and displaying stories from Hacker News.
//

import Foundation
import UIKit

class MainTableViewController: UITableViewController, UITableViewDataSource {
    
    // MARK: Properties
    
    let hackerNewsApiUrl = "http://hn.amitburst.me/news"
    let storyCellIdentifier = "StoryCell"
    let showBrowserIdentifier = "ShowBrowser"
    var stories = []
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchStories", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        self.refreshControl = refreshControl
        
        fetchStories()
    }
    
    // MARK: Story Fetching
    
    func fetchStories() {
        let url = NSURL.URLWithString(hackerNewsApiUrl)
        let request = NSURLRequest(URL: url)
        let queue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: { response, data, error in
            if error {
                println(error)
                self.refreshControl.endRefreshing()
            } else {
                let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                self.stories = json["posts"] as NSArray
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                })
            }
        })
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.stories.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier(storyCellIdentifier) as UITableViewCell
        
        let story : NSDictionary = self.stories[indexPath.row] as NSDictionary
        let user = story["user"] as NSDictionary
        
        let title = story["title"] as String
        let points = story["points"] as Int
        let username = user["username"] as String
        
        cell.textLabel.text = title
        cell.detailTextLabel.text = "\(points) points by \(username)"
        
        return cell
    }
    
    // MARK: UIViewController
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == self.showBrowserIdentifier {
            let webView = segue.destinationViewController as BrowserViewController
            let cell = sender as UITableViewCell
            let row = self.tableView.indexPathForCell(cell).row
            let story = self.stories[row] as NSDictionary
            
            webView.title = story["title"] as String
            webView.storyTitle = webView.title
            webView.urlToLoad = story["url"] as String
        }
    }
    
}
