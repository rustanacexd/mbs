//
//  SearchTableViewController.swift
//  MBS
//
//  Created by Rustan Corpuz on 6/27/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var searchController: UISearchController!
    var advertisements:[Advertisement] = []
    var filteredAdvertisements:[Advertisement] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if self.revealViewController() != nil {
//            menuBar = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain,
//                target: self.revealViewController(), action: "revealToggle:")
//            
//            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        }
        
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("adCell", forIndexPath: indexPath) as! AdTableViewCell
        
        let advertisement = searchController.active ? filteredAdvertisements[indexPath.row] : advertisements[indexPath.row]
//        cell.textLabel?.text = advertisement.title
        return cell
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
                searchString = advertisement.description
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
    
    
}
