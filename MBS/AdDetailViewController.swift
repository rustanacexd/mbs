//
//  AdDetailViewController.swift
//  MBS
//
//  Created by Rustan Corpuz on 7/6/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import UIKit
import ParseUI

class AdDetailViewController: UITableViewController {
    
    var advertisement: Advertisement!
    
    @IBOutlet weak var imageView: PFImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = advertisement.title
        imageView.file = advertisement.image
        imageView.loadInBackground()
    }

    
    @IBAction func dismissModal(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.detailTextLabel?.textColor = UIColor.lightBlue()
        
    }

  
}
