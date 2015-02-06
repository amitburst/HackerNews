//
//  MainViewController.swift
//  HackerNews
//
//  Copyright (c) 2014 Amit Burstein. All rights reserved.
//  See LICENSE for licensing information.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NightModeSwitchChangedDelegate {
    
    // MARK: Properties

    let PostCellIdentifier = "PostCell"
    let ShowBrowserIdentifier = "ShowBrowser"
    let PullToRefreshString = "Pull to Refresh"
    let ShowSettingIdentifier = "ShowSetting"
    let ReadTextColor = UIColor(red: 0.467, green: 0.467, blue: 0.467, alpha: 1.0)
    let ReadDetailTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
    let ReadTextColorNight = UIColor(red: 0.533, green: 0.533, blue: 0.533, alpha: 1.0)
    let ReadDetailTextColorNight = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
    let FetchErrorMessage = "Could Not Fetch Posts"
    let NoPostsErrorMessage = "No More Posts to Fetch"
    let ErrorMessageLabelTextColor = UIColor.grayColor()
    let ErrorMessageFontSize: CGFloat = 16
    
    var postFilter = PostFilterType.Top
    var posts: [HNPost]!
    var nextPageId: String!
    var scrolledToBottom: Bool!
    var refreshControl: UIRefreshControl!
    var errorMessageLabel: UILabel!
    
    var isNightMode = false
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Initialization
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        posts = []
        nextPageId = ""
        scrolledToBottom = false
        refreshControl = UIRefreshControl()
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPosts()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: Functions
    
    func configureUI() {
        refreshControl.addTarget(self, action: "fetchPosts", forControlEvents: .ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: PullToRefreshString)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        // Have to initialize this UILabel here because the view does not exist in init() yet.
        errorMessageLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        errorMessageLabel.textColor = ErrorMessageLabelTextColor
        errorMessageLabel.textAlignment = .Center
        errorMessageLabel.font = UIFont.systemFontOfSize(ErrorMessageFontSize)
    }
    
    func fetchPosts() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let postUrlAddition = HNManager.sharedManager().postUrlAddition
        if !scrolledToBottom {
            HNManager.sharedManager().loadPostsWithFilter(postFilter, { posts, _ in
                if posts != nil && posts.count > 0 {
                    self.posts = posts as [HNPost]
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.separatorStyle = .SingleLine
                        self.tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    })
                } else {
                    self.posts = []
                    self.tableView.reloadData()
                    if posts == nil {
                        self.showErrorMessage(self.FetchErrorMessage)
                    } else {
                        self.showErrorMessage(self.NoPostsErrorMessage)
                    }
                    self.scrolledToBottom = false
                    self.refreshControl.endRefreshing()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }
            })
        } else if postUrlAddition != nil {
            HNManager.sharedManager().loadPostsWithUrlAddition(postUrlAddition, { posts, _ in
                if posts != nil && posts.count > 0 {
                    self.posts.extend(posts as [HNPost])
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.separatorStyle = .SingleLine
                        self.tableView.reloadData()
                        self.tableView.flashScrollIndicators()
                        self.scrolledToBottom = false
                        self.refreshControl.endRefreshing()
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    })
                } else {
                    self.posts = []
                    self.tableView.reloadData()
                    if posts == nil {
                        self.showErrorMessage(self.FetchErrorMessage)
                    } else {
                        self.showErrorMessage(self.NoPostsErrorMessage)
                    }
                    self.scrolledToBottom = false
                    self.refreshControl.endRefreshing()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }
            })
        }
    }
    
    func showErrorMessage(message: String) {
        errorMessageLabel.text = message
        self.tableView.backgroundView = errorMessageLabel
        self.tableView.separatorStyle = .None
    }
    
    func stylePostCellAsRead(cell: UITableViewCell) {
        
        if !isNightMode {
            cell.textLabel?.textColor = ReadTextColor
            cell.detailTextLabel?.textColor = ReadDetailTextColor
        } else {
            cell.textLabel?.textColor = ReadTextColorNight
            cell.detailTextLabel?.textColor = ReadDetailTextColorNight
        }
        
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PostCellIdentifier) as UITableViewCell
        
        let post = posts[indexPath.row]
        
  
        
        cell.textLabel?.text = post.Title
        cell.detailTextLabel?.text = "\(post.Points) points by \(post.Username)"
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let post = posts[indexPath.row]
        
        if isNightMode {
            cell.backgroundColor = UIColor.blackColor()
            
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.detailTextLabel?.textColor = UIColor.whiteColor()
            
        
            
            if HNManager.sharedManager().hasUserReadPost(post) {
                stylePostCellAsRead(cell)
            }
            
        } else {
            cell.backgroundColor = UIColor.whiteColor()
            
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            
            if HNManager.sharedManager().hasUserReadPost(post) {
                stylePostCellAsRead(cell)
            }
            
        }
        
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        
        let reloadDistance: CGFloat = 10
        if y > h + reloadDistance && !scrolledToBottom && posts.count > 0 {
            scrolledToBottom = true
            fetchPosts()
        }
    }
    
    // MARK: UIViewController
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == ShowBrowserIdentifier {
            let webView = segue.destinationViewController.childViewControllers[0] as BrowserViewController
            let cell = sender as UITableViewCell
            let post = posts[tableView.indexPathForSelectedRow()!.row]
            let NaviVC = segue.destinationViewController as UINavigationController
            NaviVC.navigationBar.barTintColor = navigationController?.navigationBar.barTintColor
            NaviVC.toolbar.barTintColor = navigationController?.navigationBar.barTintColor
            NaviVC.navigationBar.titleTextAttributes = navigationController?.navigationBar.titleTextAttributes
        

            HNManager.sharedManager().setMarkAsReadForPost(post)
            stylePostCellAsRead(cell)

            webView.post = post
        } else if segue.identifier == ShowSettingIdentifier {
            let settingView = segue.destinationViewController.childViewControllers[0] as SettingsViewController
            settingView.delegate = self
            settingView.isNightMode = isNightMode
        }
    }
    
    // MARK: IBActions
    
    @IBAction func changePostFilter(sender: UISegmentedControl) {
        HNManager.sharedManager().postUrlAddition = nil
        
        if sender.selectedSegmentIndex == 0 {
            postFilter = .Top
        } else if sender.selectedSegmentIndex == 1 {
            postFilter = .New
        } else if sender.selectedSegmentIndex == 2 {
            postFilter = .Ask
        } else {
            println("Bad segment index!")
        }
        
        fetchPosts()
    }
    
    //MARK: NightModeDelegate
    
    func NightModeChanged(nightModeSwitcher: UISwitch) {
        if nightModeSwitcher.on {
            NightModeConfiguration()
            isNightMode = true
        } else {
            DayModeConfiguration()
            isNightMode = false
        }
    }
    
    func DayModeConfiguration() {
        view.backgroundColor = UIColor(red: 0.937255, green: 0.937255, blue: 0.956863, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.blackColor() ]
        tableView.backgroundColor = UIColor.whiteColor()
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)

    }
    
    func NightModeConfiguration() {
        
        view.backgroundColor = UIColor.blackColor()
        navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor() ]
        tableView.backgroundColor = UIColor.blackColor()
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        
    }

}
