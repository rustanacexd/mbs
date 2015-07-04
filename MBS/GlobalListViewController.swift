//
//  GlobalListViewController.swift
//  MBS
//
//  Created by Rustan Corpuz on 6/30/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import UIKit
import Refresher
import MBProgressHUD

class GlobalListViewController: AdsTableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        //Setup Reveal Menu
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
        //            dispatch_async(dispatch_get_main_queue(), {
        //                MBProgressHUD.hideHUDForView(self.view, animated: true)
        //                self.tableView.reloadData()
        //            })
        //        })
        //
        fetchAdsBy { (ads: [Advertisement]) -> () in
            self.advertisements = ads
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
        
        //Pull to refresh
        tableView.addPullToRefreshWithAction({
            NSOperationQueue().addOperationWithBlock {
                fetchAdsBy { (ads: [Advertisement]) -> () in
                    self.advertisements = ads
                    self.selectedSegment(self.segmentedControl)
                }
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.tableView.stopPullToRefresh()
                }
            }
            }, withAnimator: PacmanAnimator())
        
    }

  
    
}
