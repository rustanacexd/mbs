//
//  LoginViewController.swift
//  MBS
//
//  Created by Rustan Corpuz on 6/24/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import UIKit
import ParseUI
//import ParseFacebookUtilsV4

class LoginViewController: PFLogInViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logInView?.backgroundColor = UIColor.blackColor()
        
        //Temporary Logo
        let temporaryLogo = UILabel(frame: CGRect(origin: logInView!.center,
            size: CGSize(width: 50, height: 50)))
        temporaryLogo.text = "Mobile Buy and Sell"
        temporaryLogo.font = UIFont.systemFontOfSize(30)
        temporaryLogo.numberOfLines = 0
        temporaryLogo.sizeToFit()
        temporaryLogo.textColor = UIColor.whiteColor()
        logInView?.logo = temporaryLogo
        
        //Facebook Button
        logInView!.facebookButton!.setImage(nil, forState: UIControlState.Normal)
        logInView?.facebookButton?.setImage(nil, forState: UIControlState.Highlighted)
        logInView?.facebookButton?.setBackgroundImage(nil, forState: UIControlState.Normal)
        logInView?.facebookButton?.setBackgroundImage(nil, forState: UIControlState.Highlighted)
        logInView?.facebookButton!.setTitle("", forState: UIControlState.Normal)
        logInView?.facebookButton!.setTitle("", forState: UIControlState.Highlighted)
    }
    
    override func viewDidLayoutSubviews() {
        let facebookButtonSize = self.logInView?.facebookButton?.frame.size
        
        logInView?.facebookButton?.frame = CGRect(x: 0,
            y: logInView!.frame.height - facebookButtonSize!.height - 5, width: view.frame.width,
            height: facebookButtonSize!.height + 5)
        
        logInView?.facebookButton?.backgroundColor = UIColor.facebookBlue()
        
    }
    
}
