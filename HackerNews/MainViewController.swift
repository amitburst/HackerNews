//
//  MainViewController.swift
//  HackerNews
//
//  Copyright (c) 2015 Amit Burstein. All rights reserved.
//  See LICENSE for licensing information.
//

import UIKit
import SafariServices

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SFSafariViewControllerDelegate {
    
    // MARK: Properties

    let PostCellIdentifier = "PostCell"
    let ShowBrowserIdentifier = "ShowBrowser"
    let PullToRefreshString = "Pull to Refresh"
    let FetchErrorMessage = "Could Not Fetch Posts"
    let ErrorMessageLabelTextColor = UIColor.grayColor()
    let ErrorMessageFontSize: CGFloat = 16
    let FirebaseRef = "https://hacker-news.firebaseio.com/v0/"
    let ItemChildRef = "item"
    let StoryTypeChildRefMap = [StoryType.Top: "topstories", .New: "newstories", .Show: "showstories"]
    let StoryLimit: UInt = 30
    let DefaultStoryType = StoryType.Top
    
    var firebase: Firebase!
    var stories: [Story]!
    var storyType: StoryType!
    var retrievingStories: Bool!
    var refreshControl: UIRefreshControl!
    var errorMessageLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Enums
    
    enum StoryType {
        case Top, New, Show
    }
    
    // MARK: Structs
    
    struct Story {
        var title: String
        var url: String
        var by: String
        var score: Int
    }
    
    // MARK: Initialization
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        firebase = Firebase(url: FirebaseRef)
        stories = []
        storyType = DefaultStoryType
        retrievingStories = false
        refreshControl = UIRefreshControl()
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        retrieveStories()
    }
    
    // MARK: Functions
    
    func configureUI() {
        refreshControl.addTarget(self, action: "retrieveStories", forControlEvents: .ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: PullToRefreshString)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        // Have to initialize this UILabel here because the view does not exist in init() yet.
        errorMessageLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        errorMessageLabel.textColor = ErrorMessageLabelTextColor
        errorMessageLabel.textAlignment = .Center
        errorMessageLabel.font = UIFont.systemFontOfSize(ErrorMessageFontSize)
    }
    
    func retrieveStories() {
        if retrievingStories! {
            return
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        stories = []
        retrievingStories = true
        var storiesMap = [Int:Story]()
        
        let query = firebase.childByAppendingPath(StoryTypeChildRefMap[storyType]).queryLimitedToFirst(StoryLimit)
        query.observeSingleEventOfType(.Value, withBlock: { snapshot in
            let storyIds = snapshot.value as! [Int]
            for storyId in storyIds {
                let query = self.firebase.childByAppendingPath(self.ItemChildRef).childByAppendingPath(String(storyId))
                query.observeSingleEventOfType(.Value, withBlock: { snapshot in
                    let title = snapshot.value["title"] as! String
                    let url = snapshot.value["url"] as! String
                    let by = snapshot.value["by"] as! String
                    let score = snapshot.value["score"] as! Int
                    let story = Story(title: title, url: url, by: by, score: score)
                    storiesMap[storyId] = story
                    
                    if storiesMap.count == Int(self.StoryLimit) {
                        var sortedStories = [Story]()
                        for storyId in storyIds {
                            sortedStories.append(storiesMap[storyId]!)
                        }
                        self.stories = sortedStories
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                        self.retrievingStories = false
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    }
                    }, withCancelBlock: { error in
                        self.retrievingStories = false
                        self.showErrorMessage(self.FetchErrorMessage)
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                })
            }
        }, withCancelBlock: { error in
            self.retrievingStories = false
            self.showErrorMessage(self.FetchErrorMessage)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    func showErrorMessage(message: String) {
        errorMessageLabel.text = message
        self.tableView.backgroundView = errorMessageLabel
        self.tableView.separatorStyle = .None
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let story = stories[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(PostCellIdentifier) as UITableViewCell!
        cell.textLabel?.text = story.title
        cell.detailTextLabel?.text = "\(story.score) points by \(story.by)"
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let story = stories[indexPath.row]
        let url = NSURL(string: story.url)!
        
        let webViewController = SFSafariViewController(URL: url)
        webViewController.delegate = self
        presentViewController(webViewController, animated: true, completion: nil)
    }
    
    // MARK: SFSafariViewControllerDelegate
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: IBActions
    
    @IBAction func changeStoryType(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            storyType = .Top
        } else if sender.selectedSegmentIndex == 1 {
            storyType = .New
        } else if sender.selectedSegmentIndex == 2 {
            storyType = .Show
        } else {
            print("Bad segment index!")
        }
        
        retrieveStories()
    }

}
