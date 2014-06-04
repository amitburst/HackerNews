//
//  MainTableViewController.swift
//  HackerNews
//
//  Created by Amit Burstein on 6/2/14.
//  Copyright (c) 2014 Amit Burstein. All rights reserved.
//

import Foundation
import UIKit

class MainTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    let hackerNewsApiUrl = "http://hn.amitburst.me/news"
    let storyCellIdentifier = "StoryCell"
    let showWebViewIdentifier = "ShowBrowser"
    var stories = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStories()
    }
    
    func fetchStories() {
        let url = NSURL.URLWithString(hackerNewsApiUrl)
        let request = NSURLRequest(URL: url)
        let queue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: { response, data, error in
            if error {
                println(error)
            } else {
                let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                 self.stories = json.objectForKey("posts") as NSArray
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.stories.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier(storyCellIdentifier) as UITableViewCell
        
        let story : NSDictionary = self.stories[indexPath.row] as NSDictionary
        let title = story["title"] as String
        let points = story["points"] as Int
        let user = (story["user"] as NSDictionary)["username"] as String
        
        cell.textLabel.text = title
        cell.detailTextLabel.text = "\(points) points by \(user)"
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == self.showWebViewIdentifier {
            let webView = segue.destinationViewController as BrowserViewController
            let cell = sender as UITableViewCell
            let row = self.tableView.indexPathForCell(cell).row
            
            webView.title = (self.stories[row] as NSDictionary)["title"] as String
            webView.urlToLoad = (self.stories[row] as NSDictionary)["url"] as String
        }
    }
    
}
