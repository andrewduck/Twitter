//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Andrew Duck on 26/3/16.
//  Copyright © 2016 Andrew Duck. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var tweets: [Tweet]!
    var isMoreDataLoading = false
    var replyTweet: Tweet?
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Default table view sizing
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        // Initial timeline request
        updateTimeline()
        
        // Update nav bar styling
        navigationController?.navigationBar.barTintColor = UIColor(red:0.332,  green:0.673,  blue:0.932, alpha:1)
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        // Update tweet list every 90 seconds, try to avoid rate-limiting
        NSTimer.scheduledTimerWithTimeInterval(90, target: self, selector: #selector(TweetsViewController.onTimer), userInfo: nil, repeats: true)
        
        // Provide pull to refresh controls
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TweetsViewController.refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        // Receive notification from tableView Cell for reply to a specific tweet
        NSNotificationCenter.defaultCenter().addObserverForName("tweetReply", object: nil, queue: NSOperationQueue.mainQueue()) { (notification: NSNotification) -> Void in
            print("receiving tweetReply notification")
            let userInfo = notification.userInfo
            self.replyTweet = userInfo!["tweet"] as! Tweet
            self.performSegueWithIdentifier("newTweetSegue", sender: nil)
        }

    }

    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func updateTimeline() {
        TwitterClient.sharedInstance.homeTimeline( { (tweets: [Tweet]) -> () in
            print("got here")
            self.tweets = tweets
            print(tweets[0])
            for tweet in tweets {
                print(tweet)
            }
            self.tableView.reloadData()
        }) { (error: NSError) -> () in
            print(error.localizedDescription)
        }
    }
    
    func onTimer() {
        // Refresh tweet list
        updateTimeline()
        
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        // While this works, it should not call endRefreshing until the data return is successful, to be improved.
        updateTimeline()
        refreshControl.endRefreshing()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let scrollViewContentHeight = tableView.contentSize.height
        let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
        
        if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
            isMoreDataLoading = true
            
            // If twitter api is rate limited, error 429, then calling maxId will crash.
            if let tweets = tweets {
                let maxId = tweets.last!.id
                
                TwitterClient.sharedInstance.homeTimeline( { (tweets:[Tweet]) in
                    
                    }, failure: { (error: NSError) in
                        print(error.localizedDescription)
                })
            }
            
            
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailsSegue" {
            let vc = segue.destinationViewController as! TweetDetailsViewController
            
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            
            vc.tweet = tweets[indexPath!.row]
        }
        
        // Passing data through a navigation controller, so need to pull topViewController.
        if segue.identifier == "newTweetSegue" {
            let vc = segue.destinationViewController as! UINavigationController
            let newTweetController = vc.topViewController as! NewTweetViewController
            
            if replyTweet != nil {
                newTweetController.replyTweet = replyTweet
            }
        }
    }
    

}
