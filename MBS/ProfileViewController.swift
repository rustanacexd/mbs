//
//  ProfileViewController.swift
//  MBS
//
//  Created by Rustan Corpuz on 7/7/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import UIKit
import DZNSegmentedControl

class ProfileViewController: UIViewController, DZNSegmentedControlDelegate {

    @IBOutlet weak var segmentControl: UIView!
     var segmentedControl: DZNSegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedControl = DZNSegmentedControl(items: ["Recent","Cheapest","Alphabetically"])
        segmentedControl.delegate = self
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: "selectedSegment:", forControlEvents: UIControlEvents.ValueChanged)
        segmentedControl.bouncySelectionIndicator = true
        segmentedControl.height = 70
        segmentedControl.showsCount = true
        segmentedControl.autoAdjustSelectionIndicatorWidth = false
        segmentedControl.tintColor = UIColor.facebookBlue()
        segmentedControl.font = UIFont(name: "Avenir", size: 14)
        segmentedControl.inverseTitles = true
        segmentedControl.selectionIndicatorHeight = 70
        segmentedControl.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
        segmentControl.addSubview(segmentedControl)
    }
    
    func selectedSegment(control: DZNSegmentedControl) {
        
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
