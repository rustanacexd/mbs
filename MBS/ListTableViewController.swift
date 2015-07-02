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

class ListTableViewController: UITableViewController, DZNSegmentedControlDelegate {
    
    var advertisements:[Advertisement] = []
    var segmentedControl: DZNSegmentedControl!
   /* @IBOutlet weak var menuBarButton: UIBarButtonItem! */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
     /*   if self.revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = "revealToggle:"
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        } */
 
        segmentedControl = DZNSegmentedControl(items: ["Recent","Popular","Most Viewed"])
        segmentedControl.delegate = self
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: "selectedSegment:", forControlEvents: UIControlEvents.ValueChanged)
        segmentedControl.bouncySelectionIndicator = true
        segmentedControl.height = 40
        segmentedControl.showsCount = false
        segmentedControl.autoAdjustSelectionIndicatorWidth = false
        segmentedControl.tintColor = UIColor.lightGrayColor()
        segmentedControl.font = UIFont(name: "Avenir", size: 14)
        tableView.tableHeaderView = segmentedControl
        
        definesPresentationContext = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        tableView.registerNib(UINib(nibName: "AdTableCell", bundle: nil), forCellReuseIdentifier: "adCell")
        tableView.tableFooterView = UIView()

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
        tableView.reloadData()
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
        
        let advertisement = advertisements[indexPath.row]
//        cell.textLabel?.text = advertisement.title
        return cell
    }
    
    
}
