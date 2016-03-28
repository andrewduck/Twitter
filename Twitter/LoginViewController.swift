//
//  LoginViewController.swift
//  Twitter
//
//  Created by Andrew Duck on 24/3/16.
//  Copyright © 2016 Andrew Duck. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Push to loginSegue on success
    @IBAction func onLoginButton(sender: AnyObject) {
        let client = TwitterClient.sharedInstance
        
        client.login({ () -> () in
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        }) { (error: NSError) -> () in
                print("Error: \(error.localizedDescription)")
        }
    }
    
}
