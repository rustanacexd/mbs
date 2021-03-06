//
//  SearchViewController.swift
//  MBS
//
//  Created by Rustan Corpuz on 7/4/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import UIKit
import MBProgressHUD
import ParseUI

class SearchViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {

    var searchController: UISearchController!
    
    var advertisements:[Advertisement] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailView") as! AdDetailViewController
 
    var filteredAdvertisements:[Advertisement] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.tintColor = UIColor.facebookBlue()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = ["Title", "Description"]
        searchController.searchBar.sizeToFit()
        searchController.delegate = self
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        tableView.registerNib(UINib(nibName: "AdTableCell", bundle: nil), forCellReuseIdentifier: "adCell")
        
        tableView.scrollsToTop = true
        
        tableView.separatorStyle = .None
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.active ? filteredAdvertisements.count : advertisements.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("adCell", forIndexPath: indexPath) as! AdTableViewCell
     
        let ad = advertisements[indexPath.row]
        cell.titleLabel.text = ad.title
        cell.priceLabel.text = "\(ad.price) PHP"
        cell.adImage.file = ad.image
        cell.adImage.loadInBackground()
        cell.datePostedLabel.text = ad.createdAt!.timeAgoSinceNow()
        cell.sellerLabel.text = ad.displayName
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let ad = advertisements[indexPath.row]
        detailVC.advertisement = ad
        presentViewController(detailVC, animated: true, completion: nil)
        
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
                searchString = advertisement.shortDescription
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

    // MARK: - UISearchControllerDelegate
    
    func willPresentSearchController(searchController: UISearchController) {
        self.navigationController?.navigationBar.translucent = true
    }
    
    func willDismissSearchController(searchController: UISearchController) {
        self.navigationController?.navigationBar.translucent = false
    }
    
    
}
