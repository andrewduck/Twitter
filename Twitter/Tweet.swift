//
//  Tweet.swift
//  Twitter
//
//  Created by Andrew Duck on 26/3/16.
//  Copyright © 2016 Andrew Duck. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var id: Int
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var retweeted: Bool = false
    var favouritesCount: Int = 0
    var favourited: Bool = false
    var user: User
    
    init(dictionary: NSDictionary) {
        
        id = (dictionary["id"] as? Int)!
        text = dictionary["text"] as? String
        
        retweetCount = dictionary["retweet_count"] as? Int ?? 0
        favouritesCount = dictionary["favourites_count"] as? Int ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
        
        favourited = (dictionary["favorited"] as? Bool)!
        retweeted = (dictionary["retweeted"] as? Bool)!
        
        user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        
        return tweets
        
    }
}
