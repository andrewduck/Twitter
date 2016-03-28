//
//  TweetDetailsCell.swift
//  Twitter
//
//  Created by Andrew Duck on 26/3/16.
//  Copyright © 2016 Andrew Duck. All rights reserved.
//

import UIKit

class TweetDetailsCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var retweetsCountLabel: UILabel!
    @IBOutlet weak var favouritesCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet.user.name as? String
            screenNameLabel.text = "@\(tweet.user.screenname as! String)"
            tweetLabel.text = tweet.text as? String
            
            if tweet.user.profileUrlBigger != nil {
                userImageView.setImageWithURL(tweet.user.profileUrlBigger!)
                print(tweet.user.profileUrlBigger!)
            }
            
            //print(tweet.retweetCount)
            retweetsCountLabel.text = String(tweet.retweetCount)
            //print(tweet.favouritesCount)
            favouritesCountLabel.text = String(tweet.favouritesCount)
            likeCountLabel.hidden = true
            
            createdAtLabel.text = tweet.timestamp?.formattedDateWithFormat("MM/dd/YY HH:mm a")
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

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
