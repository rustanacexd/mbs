//
//  GlobalSearchViewController.swift
//  MBS
//
//  Created by Rustan Corpuz on 6/30/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import UIKit
import MBProgressHUD

class GlobalSearchViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var searchController: UISearchController!
    
    var advertisements:[Advertisement] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var filteredAdvertisements:[Advertisement] = []
    
    @IBOutlet weak var menuBar: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuBar.target = self.revealViewController()
            menuBar.action = "revealToggle:"
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //Initial Fetch
        
        //Initial Fetch
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "loading"
        hud.detailsLabelText = "fetching ads"
        
        fetchAdsBy { (ads: [Advertisement]) -> () in
            self.advertisements = ads
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.tintColor = UIColor.blackColor()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = ["Title", "Description"]
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        tableView.registerNib(UINib(nibName: "AdTableCell", bundle: nil), forCellReuseIdentifier: "adCell")
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.active ? filteredAdvertisements.count : advertisements.count
    }
    
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        //stripe leading and trailing whitespaces
        let searchText = searchController.searchBar.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        filterContentForSearchText(searchText, scope: searchController.searchBar.selectedScopeButtonIndex)
        
        tableView.reloadData()
        
    }
    
    func filterContentForSearchText(searchText: String, scope: Int){
        
        var searchItems = []
        var searchMatch:Range<String.Index>? = nil
        
        if (count(searchText) > 0) {
            searchItems = searchText.componentsSeparatedByString(" ")
        }
        
        filteredAdvertisements = advertisements.filter({ ( advertisement: Advertisement) -> Bool in
            var nameMatch = false
            var searchString = ""
            
            if scope == 0 {
                searchString = advertisement.title
            }
            else if scope == 1 {
                searchString = advertisement.description!
            }
            
            for searchTerms in searchItems {
                searchMatch = searchString.rangeOfString(searchTerms as! String,
                    options: NSStringCompareOptions.CaseInsensitiveSearch)
                
                if searchMatch != nil {
                    nameMatch = true
                    break
                }
            }
            
            return nameMatch
        })
        
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.updateSearchResultsForSearchController(searchController)
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        tableView.scrollRectToVisible(searchController.searchBar.frame, animated: false)
        return nil
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
        
        let ad = searchController.active ? filteredAdvertisements[indexPath.row] : advertisements[indexPath.row]
        cell.titleLabel.text = ad.title
        cell.priceLabel.text = "\(ad.price) PHP"
        cell.adImage.file = ad.image
        cell.adImage.loadInBackground()
        cell.datePostedLabel.text = ad.createdAt.timeAgoSinceNow()
        cell.sellerLabel.text = ad.sellerUsername
        
        return cell
    }
    
}
