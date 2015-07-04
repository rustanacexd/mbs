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

class ListTableViewController: UITableViewController, DZNSegmentedControlDelegate {
    
    var advertisements:[Advertisement] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var segmentedControl: DZNSegmentedControl!
    var selectedCategory: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
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
        
        definesPresentationContext = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        tableView.registerNib(UINib(nibName: "AdTableCell", bundle: nil), forCellReuseIdentifier: "adCell")
        tableView.tableFooterView = UIView()
        
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
    
    //MARK: - SegmentedControl
    
    func selectedSegment(control: DZNSegmentedControl) {
        switch control.selectedSegmentIndex {
        case 1:
            advertisements.sort {$0.price < $1.price}
        case 2:
            advertisements.sort {$0.title.lowercaseString < $1.title.lowercaseString}
        default:
            advertisements.sort {$0.createdAt.compare($1.createdAt) == NSComparisonResult.OrderedDescending}
        }
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.Bottom
    }
    

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return advertisements.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("adCell", forIndexPath: indexPath) as! AdTableViewCell
        
        let ad = advertisements[indexPath.row]
        cell.titleLabel.text = ad.title
        cell.priceLabel.text = "\(ad.price) PHP"
        cell.adImage.image = UIImage(named: "sample-category")
        cell.adImage.file = ad.image
        cell.adImage.loadInBackground()
        cell.datePostedLabel.text = ad.createdAt.timeAgoSinceNow()
        cell.sellerLabel.text = ad.sellerUsername
        
        return cell
    }
    
    
}
