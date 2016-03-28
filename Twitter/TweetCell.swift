//
//  TweetCell.swift
//  Twitter
//
//  Created by Andrew Duck on 26/3/16.
//  Copyright © 2016 Andrew Duck. All rights reserved.
//

import UIKit
import DateTools

class TweetCell: UITableViewCell {


    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweetView: UIView!
    @IBOutlet weak var retweetViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            
            print("retweeted: \(tweet.retweeted)")
            
            if tweet.retweeted == false {
                retweetView.hidden = true
                retweetViewHeightConstraint.constant = 0;
            }
            
            tweetLabel.text = tweet.text as? String
            userNameLabel.text = tweet.user.name as? String
            screenNameLabel.text = "@\(tweet.user.screenname as! String)"
            
            createdAtLabel.text = tweet.timestamp?.shortTimeAgoSinceNow()
            
            if tweet.user.profileUrlBigger != nil {
                userImageView.setImageWithURL(tweet.user.profileUrlBigger!)
                print(tweet.user.profileUrlBigger!)
            }
            
            if (tweet.favourited == true) {
                //likeImageView.image = UIImage(named: "like-on")
            } else {
                //likeImageView.image = UIImage(named: "like")
            }
            
            if (tweet.favouritesCount > 0) {
                likeCountLabel.text = String(tweet.favouritesCount)
            } else {
                likeCountLabel.hidden = true
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.cornerRadius = 3
        userImageView.clipsToBounds = true
        tweetLabel.preferredMaxLayoutWidth = tweetLabel.frame.size.width

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tweetLabel.preferredMaxLayoutWidth = tweetLabel.frame.size.width
    }
    
    @IBAction func onReplyButton(sender: AnyObject) {
        print("starting reply function")
        var selectionInfo: [NSObject : AnyObject] = [:]
        selectionInfo["tweet"] = tweet
        NSNotificationCenter.defaultCenter().postNotificationName("tweetReply", object: self, userInfo: selectionInfo)
        // Switch to new tweet screen
        // Add reply_to id for tweet
        // Add @username at beginning of tweet string
    }
    
    @IBAction func onFavouriteButton(sender: AnyObject) {
        // Favourite the tweet in question.
        TwitterClient.sharedInstance.favoriteTweet(tweet.id)
        
        // There is a bug here on pull to refresh, the state is persisted on reload of new tweets
        
        // Update favourite button to show favourite. 
        likeButton.setImage(UIImage(named: "like-on"), forState: UIControlState.Normal)
    }

    @IBAction func onRetweetButton(sender: AnyObject) {
        TwitterClient.sharedInstance.retweetTweet(tweet.id)
        
        // Need to update retweet button image, not completed yet
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
