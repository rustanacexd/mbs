//
//  ListTableViewController.swift
//  MBS
//
//  Created by Rustan Corpuz on 6/26/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import UIKit
import Parse
import DZNSegmentedControl
import MBProgressHUD

class ListTableViewController: AdsTableViewController {
    
    var selectedCategory: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        //Pull to refresh
        tableView.addPullToRefreshWithAction({
            NSOperationQueue().addOperationWithBlock {
                fetchAdsBy (key: "category", equalTo: self.selectedCategory){ (ads: [Advertisement]) -> () in
                    self.advertisements = ads
                    self.selectedSegment(self.segmentedControl)
                }
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.tableView.stopPullToRefresh()
                }
            }
            }, withAnimator: PacmanAnimator())

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        //Inital Fetch
        fetchAdsBy (key: "category", equalTo: selectedCategory) { (ads: [Advertisement]) -> () in
            self.advertisements = ads
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier {
            if identifier == "searchSegue" {
                let destinationVC = segue.destinationViewController as! SearchTableViewController
                destinationVC.advertisements = self.advertisements
            }
        }
    }
 
}
