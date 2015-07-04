//
//  GlobalSearchViewController.swift
//  MBS
//
//  Created by Rustan Corpuz on 6/30/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import UIKit
import MBProgressHUD

class GlobalSearchViewController: SearchViewController {
    
    @IBOutlet weak var menuBar: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuBar.target = self.revealViewController()
            menuBar.action = "revealToggle:"
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
                
        //Initial Fetch
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "loading"
        hud.detailsLabelText = "fetching ads"
        
        fetchAdsBy { (ads: [Advertisement]) -> () in
            self.advertisements = ads
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
    
}
