//
//  MenuTableViewController.swift
//  MBS
//
//  Created by Rustan Corpuz on 6/26/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

class MenuTableViewController: UITableViewController {
    
    var menuBar: UIBarButtonItem!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePicture: FBSDKProfilePictureView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        
        
        self.revealViewController().rearViewRevealWidth = tableView.frame.size.width * 0.8
        self.revealViewController().frontViewShadowOpacity = 0
        menuBar = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain,
            target: self.revealViewController(), action: "revealToggle:")
        
        usernameLabel.text = CurrentUser.sharedInstance.username
        profilePicture.layer.cornerRadius = 25.0
        profilePicture.clipsToBounds = true
        profilePicture.profileID = CurrentUser.sharedInstance.facebookID
        tableView.tableFooterView = UIView()
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 6 {
            PFUser.logOutInBackground()
            self.presentViewController(LoginConfigViewController(), animated: true, completion: nil)
        }
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let separatorLine = UIView(frame: CGRect(x: 0, y: cell.frame.height, width: cell.frame.width, height: 0.25))
        separatorLine.backgroundColor = UIColor.lightGrayColor()
        cell.contentView.addSubview(separatorLine)
    
    }
    
    
    
    
    
}
