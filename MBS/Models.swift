//
//  Models.swift
//  MBS
//
//  Created by Rustan Corpuz on 6/26/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import Foundation
import Parse
import ParseUI

class Advertisement: PFObject, PFSubclassing {
    
    @NSManaged var title: String
    @NSManaged var shortDescription: String
    @NSManaged var price: Double
    @NSManaged var image: PFFile
    @NSManaged var category: String
    @NSManaged var condition: String
    @NSManaged var sold: Bool
    @NSManaged var seller: User
    @NSManaged var displayName: String
    
    override init() {
        super.init()
    }
    
    override init(className newClassName: String) {
        super.init(className: newClassName)
        self.sold = false
        self.seller = currentUser()!
        self.displayName = currentUser()!.username!
    }
    
    func imageView() -> UIImage {
        let view = PFImageView(image: UIImage(named: "image-placeholder"))
        view.file = image
        view.loadInBackground()
        return view.image!
    }
    

    static func parseClassName() -> String {
        return "Advertisement"
    }
    
}

func fetchAdsBy (key: String? = nil, equalTo: String? = nil, callback: ([Advertisement]) -> ()) {
    let query = PFQuery(className: "Advertisement")
    query.orderByDescending("createdAt")
    query.cachePolicy = PFCachePolicy.CacheThenNetwork

    if let k = key {
        if let e = equalTo {
            query.whereKey(k, equalTo: e)
        }
    }

    query.findObjectsInBackgroundWithBlock {
        objects, error in

        if error == nil {
            if let pfObjects = objects as? [PFObject]{
                let ads = map(pfObjects, {pfObjectToAd ($0)})
                callback(ads)
            }
        }
    }
}

class User: PFUser, PFSubclassing {
    @NSManaged var contactNumber: String
    @NSManaged var facebookID: String
}

func pfObjectToAd(object: PFObject) -> Advertisement {
    return (object as? Advertisement)!
}


func currentUser() -> User? {
    if let user = PFUser.currentUser() {
        return user as? User
    }
    return nil
}


