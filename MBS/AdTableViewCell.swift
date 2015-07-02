//
//  AdTableViewCell.swift
//  MBS
//
//  Created by Rustan Corpuz on 6/30/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import UIKit

class AdTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var adImage: UIImageView!
    @IBOutlet weak var sellerLabel: UILabel!
    @IBOutlet weak var datePostedLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        titleLabel.sizeThatFits(titleLabel.frame.size)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
