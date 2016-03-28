//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Andrew Duck on 26/3/16.
//  Copyright © 2016 Andrew Duck. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {

    var replyTweet: Tweet?
    var replyId: Int?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var tweetText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = User.currentUser
        
        nameLabel.text = user?.name as? String
        screenNameLabel.text = "@\(user?.screenname as! String)"
        if ((user?.profileUrl = user?.profileUrl) != nil) {
            userImageView.setImageWithURL((user?.profileUrl)!)
        }
        
        tweetText.becomeFirstResponder()
        if replyTweet != nil {
            tweetText.text = "@\(replyTweet!.user.screenname as! String) "
            replyId = replyTweet?.id
        } else {
            tweetText.text = ""
        }

        tweetText.editable = true
    }
    
    @IBAction func onTweetButton(sender: AnyObject) {
        if replyId != nil {
            TwitterClient.sharedInstance.createTweet(tweetText.text, replyId: replyId!)
        } else {
            TwitterClient.sharedInstance.createTweet(tweetText.text, replyId: nil)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
        // don't dismiss if the tweet fails
        // add tweet to tweet list, or force refresh on network
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
