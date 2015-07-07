//
//  ProfileViewController.swift
//  MBS
//
//  Created by Rustan Corpuz on 7/7/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import UIKit
import ParseUI
import Parse
import DZNSegmentedControl

class ProfileViewController: UIViewController, DZNSegmentedControlDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var profileImage: PFImageView!
    @IBOutlet weak var segmentControl: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var segmentedControl: DZNSegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
        profileImage.clipsToBounds = true
        
        segmentedControl = DZNSegmentedControl(items: ["Ads","Feedbacks"])
        segmentedControl.delegate = self
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: "selectedSegment:", forControlEvents: UIControlEvents.ValueChanged)
        segmentedControl.bouncySelectionIndicator = true
        segmentedControl.height = 70
        segmentedControl.showsCount = true
        segmentedControl.autoAdjustSelectionIndicatorWidth = false
        segmentedControl.tintColor = UIColor.facebookBlue()
        segmentedControl.font = UIFont(name: "Avenir", size: 20)
        segmentedControl.inverseTitles = true
        segmentedControl.selectionIndicatorHeight = 70
        segmentedControl.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
        segmentControl.addSubview(segmentedControl)
    }
    
    func selectedSegment(control: DZNSegmentedControl) {
        
    }
    
    //MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.Bottom
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
