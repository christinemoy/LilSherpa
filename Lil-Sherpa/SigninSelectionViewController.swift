//
//  SigninSelectionViewController.swift
//  Lil-Sherpa
//
//  Created by Christine Moy on 4/24/15.
//  Copyright (c) 2015 Christine Moy. All rights reserved.
//

import UIKit

class SigninSelectionViewController: UIViewController {

    @IBAction func pressFacebookButton(sender: AnyObject) {
        let settings = NSUserDefaults.standardUserDefaults()
        
        if let token = settings.stringForKey("fbToken") {
            performSegueWithIdentifier("login", sender: nil)
        } else {
            PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile"], block: { (user, error) -> Void in
                if let user = user {
                    let token = FBSDKAccessToken.currentAccessToken().tokenString
                    settings.setObject(token, forKey: "fbToken")
                    self.performSegueWithIdentifier("login", sender: nil)
                } else {
                    println("user cancelled; didn't get a token")
                }
            })
        }

        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
