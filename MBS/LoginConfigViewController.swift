//
//  LoginConfigViewController.swift
//  MBS
//
//  Created by Rustan Corpuz on 6/24/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import UIKit
import ParseUI
import ParseFacebookUtilsV4

class LoginConfigViewController: UIViewController, PFLogInViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if PFUser.currentUser() == nil {
            var loginViewController = LoginViewController()
            loginViewController.delegate = self
            loginViewController.fields = .Facebook
            loginViewController.facebookPermissions = ["public_profile", "email"]
            
            self.presentViewController(loginViewController, animated: false, completion: nil)
            
        }
    }
    
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        
        if user.isNew {
            var request = FBSDKGraphRequest(graphPath: "me",
                parameters: nil)
            request.startWithCompletionHandler({
                (connection: FBSDKGraphRequestConnection!, result: AnyObject!,error: NSError!) -> Void in
                if error == nil {
                    var userData = result as! NSDictionary
                    user["firstName"] = userData["first_name"]
                    user["lastName"] = userData["last_name"]
                    user["username"] = userData["name"]
                    user["gender"] = userData["gender"]
                    user["email"] = userData["email"]
                    user["verified"] = userData["verified"] as! Bool
                    user["facebookID"] = userData["id"] as! String
                    
                    user.saveInBackground()

                }
            })
        }
        
        
        
        self.dismissViewControllerAnimated(false, completion: nil)
        
        let vc:UIViewController = UIStoryboard(name: "Main",
            bundle: nil).instantiateViewControllerWithIdentifier("rootController") as! SWRevealViewController
        
        self.presentViewController(vc, animated: true, completion: nil)
        
        
    }
    
    
}
