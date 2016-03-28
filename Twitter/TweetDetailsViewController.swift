//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by Andrew Duck on 26/3/16.
//  Copyright © 2016 Andrew Duck. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tweet: Tweet?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Debug only
        print(tweet?.text)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetDetailsCell", forIndexPath: indexPath) as! TweetDetailsCell
        
        cell.tweet = tweet!
        
        return cell
    }
    
}
