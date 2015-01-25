//
//  MainViewController.swift
//  HackerNews
//
//  Copyright (c) 2014 Amit Burstein. All rights reserved.
//  See LICENSE for licensing information.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties

    let PostCellIdentifier = "PostCell"
    let ShowBrowserIdentifier = "ShowBrowser"
    let PullToRefreshString = "Pull to Refresh"
    let ReadTextColor = UIColor(red: 0.467, green: 0.467, blue: 0.467, alpha: 1.0)
    let ReadDetailTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
    
    var postFilter = PostFilterType.Top
    var posts: [HNPost]!
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Initialization
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        posts = []
        refreshControl = UIRefreshControl()
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPosts()
    }
    
    // MARK: Functions
    
    func configureUI() {
        refreshControl.addTarget(self, action: "fetchPosts", forControlEvents: .ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: PullToRefreshString)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func fetchPosts() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        
        HNManager.sharedManager().loadPostsWithFilter(postFilter, completion: { posts in
            if posts.0.count > 0 {
                self.posts = posts.0 as [HNPost]
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
                    self.refreshControl.endRefreshing()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                })
            } else {
                println("Could not fetch posts!")
                self.refreshControl.endRefreshing()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
            }
        })
    }
    
    func stylePostCellAsRead(cell: UITableViewCell) {
        cell.textLabel?.textColor = ReadTextColor
        cell.detailTextLabel?.textColor = ReadDetailTextColor
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PostCellIdentifier) as UITableViewCell
        
        let post = posts[indexPath.row]
        
        if HNManager.sharedManager().hasUserReadPost(post) {
            stylePostCellAsRead(cell)
        }
        
        cell.textLabel?.text = post.Title
        cell.detailTextLabel?.text = "\(post.Points) points by \(post.Username)"
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: UIViewController
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == ShowBrowserIdentifier {
            let webView = segue.destinationViewController.childViewControllers[0] as BrowserViewController
            let cell = sender as UITableViewCell
            let post = posts[tableView.indexPathForSelectedRow()!.row]
            
            HNManager.sharedManager().setMarkAsReadForPost(post)
            stylePostCellAsRead(cell)

            webView.post = post
        }
    }
    
    // MARK: IBActions
    
    @IBAction func changePostFilter(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            postFilter = .Top
            fetchPosts()
        case 1:
            postFilter = .New
            fetchPosts()
        case 2:
            postFilter = .Ask
            fetchPosts()
        default:
            println("Bad segment index!")
        }
    }
}
