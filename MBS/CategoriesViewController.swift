//
//  CategoriesViewController.swift
//  MBS
//
//  Created by Rustan Corpuz on 6/25/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import UIKit

//let reuseIdentifier = "Cell"

class CategoriesViewController: UICollectionViewController{
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let categories = ["Gadgets", "Vehicles" ,"Real Estate", "Jobs", "Applicanes","Others"]
    let feedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FeedTable") as! ListTableViewController
    
    var selectedCategory: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize =
            CGSize(width: self.view.frame.size.width * 0.45, height: 190)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    
    }
    
    private func goToFeedController(){
        feedVC.navigationItem.title = selectedCategory
        feedVC.selectedCategory = selectedCategory
        self.navigationController?.pushViewController(feedVC, animated: true)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //
    //        if let identifier = segue.identifier {
    //            if identifier == "toFeed" {
    //                let destinationVC = segue.destinationViewController as! ListTableViewController
    //                destinationVC.navigationItem.title = selectedCategory
    //            }
    //        }
    //    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("categoryCell", forIndexPath: indexPath) as! CategoryViewCell
        
        cell.categoryNameLabel.text = categories[indexPath.row]
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedCategory = categories[indexPath.row]
        goToFeedController()
    }
    
    
    
    
    
}
