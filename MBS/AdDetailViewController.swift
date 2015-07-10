//
//  AdDetailViewController.swift
//  MBS
//
//  Created by Rustan Corpuz on 7/6/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import UIKit
import ParseUI
import DateTools

class AdDetailViewController: UITableViewController {
    
    var advertisement: Advertisement!
    
    @IBOutlet weak var imageView: PFImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = advertisement.title
        descriptionLabel.text = advertisement.shortDescription.isEmpty ? "No Description" : advertisement.shortDescription
        timeLabel.text = advertisement.createdAt!.timeAgoSinceNow()
        usernameLabel.text = advertisement.displayName
        priceLabel.text = "\(advertisement.price)"
        categoryLabel.text = advertisement.category
        conditionLabel.text = advertisement.condition.isEmpty ?  "Not Specified" : advertisement.condition
        imageView.file = advertisement.image
        imageView.loadInBackground()
        
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // Remove seperator inset
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
        
        if indexPath.row == 0 {
            cell.backgroundColor = UIColor.lightBlue()
            var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            var blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = CGRect(x: 0, y: cell.contentView.frame.height - 43, width: cell.contentView.frame.width, height: 43)
            cell.contentView.insertSubview(blurEffectView, aboveSubview: imageView)
            
        }
        
        if indexPath.row == 4 {
            cell.backgroundColor = UIColor.facebookBlue()
        }
        
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.detailTextLabel?.textColor = UIColor.facebookBlue()
        
    }
    
    

  
}
