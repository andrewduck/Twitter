//
//  TwitterClient.swift
//  Twitter
//
//  Created by Andrew Duck on 26/3/16.
//  Copyright © 2016 Andrew Duck. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "HeraL7d9Kc5XhbI55O0zI2v9e", consumerSecret: "2tsoB7tNUjGka3j2cn8JSno0BtmNsYPZbhE7QBRWDEwqMaWvsB")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: ()->(), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterapp://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("I got a token")
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
        }) { (error: NSError!) -> Void in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken:BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: NSError) -> () in
                    self.loginFailure?(error)
            })
            
            self.loginSuccess?()
            
        }) { (error: NSError!) -> Void in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }

    }
    
    func homeTimeline(success: ([Tweet] -> ()), failure: (NSError) -> ()) {
        
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        })
        
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        
        GET("1.1/account/verify_credentials.json", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        })
    }
    
    func createTweet(post: String, replyId: Int?) {
        
        
        if replyId != nil {
            print("posting tweet in reply to id: \(replyId!)")
            let path = ("1.1/statuses/update.json?status=\(post)&in_reply_to_status_id=\(replyId!)").stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            POST(path!, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
                print("successfully posted tweet")
            }) { (task: NSURLSessionDataTask?, error: NSError) in
                print("failed posting tweet, let the user know")
            }
        } else {
            print("posting new tweet")
            let path = ("1.1/statuses/update.json?status=\(post)").stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            POST(path!, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
                print("successfully posted tweet")
            }) { (task: NSURLSessionDataTask?, error: NSError) in
                print("failed posting tweet, let the user know")
            }
        }
        
    }
    
    func favoriteTweet(postId: Int) {
        
        POST("1.1/favorites/create.json?id=\(postId)", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            print("tweet favourited successfully")
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("tweet could not be favourited.")
        }
    }
    
    
    func retweetTweet(postId: Int) {
        POST("1.1/statuses/retweet/\(postId).json", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            print("successfully retweeted id: \(postId)")
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("unsuccessfully retweeted id: \(postId)")
        }
    }
}
