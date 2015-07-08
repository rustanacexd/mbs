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
        
        self.revealViewController().rearViewRevealWidth = tableView.frame.size.width * 0.6
        self.revealViewController().frontViewShadowOpacity = 0
        menuBar = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain,
            target: self.revealViewController(), action: "revealToggle:")
        
        usernameLabel.text = currentUser()?.username
        profilePicture.layer.cornerRadius = 25.0
        profilePicture.clipsToBounds = true
        profilePicture.profileID = currentUser()?.facebookID
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.facebookBlue()
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 6 {
            PFUser.logOutInBackground()
            self.presentViewController(LoginConfigViewController(), animated: true, completion: nil)
        }
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.selectionStyle = UITableViewCellSelectionStyle.Default
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        backgroundView.backgroundColor = UIColor.lightBlue()
        cell.selectedBackgroundView =  backgroundView
        cell.backgroundColor = UIColor.facebookBlue()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont(name: "Avenir-Book", size: 16.0)
        //        let separatorLine = UIView(frame: CGRect(x: 0, y: cell.frame.height, width: cell.frame.width, height: 0.25))
        //        separatorLine.backgroundColor = UIColor.whiteColor()
        //        cell.contentView.addSubview(separatorLine)
        
    }
    
    
    
    
    
}
