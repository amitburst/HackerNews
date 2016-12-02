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
  let ErrorMessageLabelTextColor = UIColor.gray
  let ErrorMessageFontSize: CGFloat = 16
  let FirebaseRef = "https://hacker-news.firebaseio.com/v0/"
  let ItemChildRef = "item"
  let StoryTypeChildRefMap = [StoryType.top: "topstories", .new: "newstories", .show: "showstories"]
  let StoryLimit: UInt = 30
  let DefaultStoryType = StoryType.top
  
  var firebase: Firebase!
  var stories: [Story]! = []
  var storyType: StoryType!
  var retrievingStories: Bool!
  var refreshControl: UIRefreshControl!
  var errorMessageLabel: UILabel!
  
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: Enums
  
  enum StoryType {
    case top, new, show
  }
  
  // MARK: Structs
  
  struct Story {
    let title: String
    let url: String?
    let by: String
    let score: Int
  }
  
  // MARK: Initialization
  
  required init?(coder aDecoder: NSCoder) {
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
    refreshControl.addTarget(self, action: #selector(MainViewController.retrieveStories), for: .valueChanged)
    refreshControl.attributedTitle = NSAttributedString(string: PullToRefreshString)
    tableView.insertSubview(refreshControl, at: 0)
    
    // Have to initialize this UILabel here because the view does not exist in init() yet.
    errorMessageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
    errorMessageLabel.textColor = ErrorMessageLabelTextColor
    errorMessageLabel.textAlignment = .center
    errorMessageLabel.font = UIFont.systemFont(ofSize: ErrorMessageFontSize)
  }
  
  func retrieveStories() {
    if retrievingStories! {
      return
    }
    
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    retrievingStories = true
    var storiesMap = [Int:Story]()
    
    let query = firebase.child(byAppendingPath: StoryTypeChildRefMap[storyType]).queryLimited(toFirst: StoryLimit)
    query?.observeSingleEvent(of: .value, with: { snapshot in
      let storyIds = snapshot?.value as! [Int]
      
      for storyId in storyIds {
        let query = self.firebase.child(byAppendingPath: self.ItemChildRef).child(byAppendingPath: String(storyId))
        query?.observeSingleEvent(of: .value, with: { snapshot in
          storiesMap[storyId] = self.extractStory(snapshot!)
          
          if storiesMap.count == Int(self.StoryLimit) {
            var sortedStories = [Story]()
            for storyId in storyIds {
              sortedStories.append(storiesMap[storyId]!)
            }
            self.stories = sortedStories
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            self.retrievingStories = false
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
          }
          }, withCancel: self.loadingFailed)
      }
      }, withCancel: self.loadingFailed)
  }
  
  func extractStory(_ snapshot: FDataSnapshot) -> Story {
    let data = snapshot.value as! Dictionary<String, Any>
    let title = data["title"] as! String
    let url = data["url"] as? String
    let by = data["by"] as! String
    let score = data["score"] as! Int
    
    return Story(title: title, url: url, by: by, score: score)
  }
  
  func loadingFailed(_ error: Error?) -> Void {
    self.retrievingStories = false
    self.stories.removeAll()
    self.tableView.reloadData()
    self.showErrorMessage(self.FetchErrorMessage)
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
  
  func showErrorMessage(_ message: String) {
    errorMessageLabel.text = message
    self.tableView.backgroundView = errorMessageLabel
    self.tableView.separatorStyle = .none
  }
  
  // MARK: UITableViewDataSource
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return stories.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let story = stories[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: PostCellIdentifier) as UITableViewCell!
    cell?.textLabel?.text = story.title
    cell?.detailTextLabel?.text = "\(story.score) points by \(story.by)"
    return cell!
  }
  
  // MARK: UITableViewDelegate
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let story = stories[indexPath.row]
    if let url = story.url {
      let webViewController = SFSafariViewController(url: URL(string: url)!)
      webViewController.delegate = self
      present(webViewController, animated: true, completion: nil)
    }
  }
  
  // MARK: SFSafariViewControllerDelegate
  
  func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    controller.dismiss(animated: true, completion: nil)
  }
  
  // MARK: IBActions
  
  @IBAction func changeStoryType(_ sender: UISegmentedControl) {
    if sender.selectedSegmentIndex == 0 {
      storyType = .top
    } else if sender.selectedSegmentIndex == 1 {
      storyType = .new
    } else if sender.selectedSegmentIndex == 2 {
      storyType = .show
    } else {
      print("Bad segment index!")
    }
    
    retrieveStories()
  }
}
