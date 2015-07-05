//
//  AdsTableViewController.swift
//  MBS
//
//  Created by Rustan Corpuz on 7/4/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import UIKit
import DZNSegmentedControl
import DateTools
import ParseUI

class AdsTableViewController: UITableViewController, DZNSegmentedControlDelegate {
    
    var advertisements:[Advertisement] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    let adImage = PFImageView(image: UIImage(named: "image-placeholder"))

    
    var segmentedControl: DZNSegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedControl = DZNSegmentedControl(items: ["Recent","Cheapest","Alphabetically"])
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
        
        //scroll to top
        tableView.scrollsToTop = true
    }
    
    func selectedSegment(control: DZNSegmentedControl) {
        
        switch control.selectedSegmentIndex {
        case 1:
            advertisements.sort {$0.price < $1.price}
        case 2:
            advertisements.sort {$0.title.lowercaseString < $1.title.lowercaseString}
        default:
            advertisements.sort {$0.createdAt!.compare($1.createdAt!) == NSComparisonResult.OrderedDescending}
        }
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.Bottom
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        cell.priceLabel.text = "\(ad.price) PHP"
        
        adImage.file = ad.image
        adImage.loadInBackground { (image: UIImage?, error: NSError?) -> Void in
            if error == nil {
                cell.adImage.image = image
            }
        }

        cell.datePostedLabel.text = ad.createdAt!.timeAgoSinceNow()
        cell.sellerLabel.text = ad.displayName
        
        return cell
    }

}
