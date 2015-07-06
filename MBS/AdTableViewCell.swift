//
//  AdTableViewCell.swift
//  MBS
//
//  Created by Rustan Corpuz on 6/30/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import UIKit
import ParseUI

class AdTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var adImage: PFImageView!
    @IBOutlet weak var sellerLabel: UILabel!
    @IBOutlet weak var datePostedLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        titleLabel.sizeThatFits(titleLabel.frame.size)
        
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = CGRect(x: 0, y: contentView.frame.height - 40,
            width: bounds.width, height: 40)
        
        contentView.insertSubview(blurEffectView, aboveSubview: adImage)
        
        if self.respondsToSelector("separatorInset:") {
            self.separatorInset = UIEdgeInsetsZero
        }
        
        // Prevent the cell from inheriting the Table View's margin settings
        if self.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            self.preservesSuperviewLayoutMargins = false
        }
        
        if self.respondsToSelector("setLayoutMargins:") {
            self.layoutMargins = UIEdgeInsetsZero
        }
        
        self.selectionStyle = .None
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        contentView.setNeedsLayout()
//        contentView.layoutIfNeeded()
//    }
    
}
