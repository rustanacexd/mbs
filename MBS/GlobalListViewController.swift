//
//  GlobalListViewController.swift
//  MBS
//
//  Created by Rustan Corpuz on 6/30/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import UIKit
import Refresher
import DZNSegmentedControl
import MBProgressHUD
import DateTools

class GlobalListViewController: UITableViewController, DZNSegmentedControlDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var advertisements:[Advertisement] = []
    var segmentedControl: DZNSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup Reveal Menu
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //Setup HUD
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "loading"
        hud.detailsLabelText = "fetching ads"
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            self.advertisements = fetchAds("createdAt")
            sleep(5)
            dispatch_async(dispatch_get_main_queue(), {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.tableView.reloadData()
            })
        })
        
        //Setup Segmented Control
        segmentedControl = DZNSegmentedControl(items: ["Recent","Popular","Most Viewed"])
        segmentedControl.delegate = self
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: "selectedSegment:", forControlEvents: UIControlEvents.ValueChanged)
        segmentedControl.bouncySelectionIndicator = true
        segmentedControl.height = 40
        segmentedControl.showsCount = false
        segmentedControl.autoAdjustSelectionIndicatorWidth = false
        segmentedControl.tintColor = UIColor.facebookBlue()
        segmentedControl.font = UIFont(name: "Avenir", size: 14)
        tableView.tableHeaderView = segmentedControl
        
        //Register Custom Cell from xib
        tableView.registerNib(UINib(nibName: "AdTableCell", bundle: nil), forCellReuseIdentifier: "adCell")
        
        //Do not show empty rows
        tableView.tableFooterView = UIView()
        
        //Pull to refresh
        tableView.addPullToRefreshWithAction({
            NSOperationQueue().addOperationWithBlock {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.tableView.stopPullToRefresh()
                }
            }
        }, withAnimator: PacmanAnimator())
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    
    func selectedSegment(control: DZNSegmentedControl) {
        
        tableView.reloadData()
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.Bottom
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return advertisements.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("adCell", forIndexPath: indexPath) as! AdTableViewCell
        
        if cell.respondsToSelector("separatorInset:") {
            cell.separatorInset = UIEdgeInsetsZero
        }
        
        // Prevent the cell from inheriting the Table View's margin settings
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        
        
        let ad = advertisements[indexPath.row]
        cell.titleLabel.text = ad.title
        cell.priceLabel.text = "\(ad.price)"
        cell.adImage.image = UIImage(named: "sample-category")
        cell.adImage.file = ad.image
        cell.adImage.loadInBackground()
        cell.datePostedLabel.text = ad.createdAt.timeAgoSinceNow()
        
        return cell
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
