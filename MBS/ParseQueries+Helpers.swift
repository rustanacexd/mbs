//
//  ParseQueries+Helpers.swift
//  MBS
//
//  Created by Rustan Corpuz on 7/3/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import Foundation
import Parse


func pfObjectToAd(object: PFObject) -> Advertisement {
    return Advertisement(image: object["image"] as! PFFile, title: object["title"] as! String,
        description: object["description"] as? String, price: object["price"] as! Double,
        category: object["category"] as! String,
        condition: object["condition"] as? String, seller: object["seller"] as! PFUser,
        createdAt: object.createdAt!
    )
}


func fetchAds(parameter: String) -> [Advertisement] {
    var objects = PFQuery(className: "Advertisement")
        .orderByDescending(parameter)
        .findObjects()
    
    let ads = map(objects!, {pfObjectToAd($0 as! PFObject)})
    return ads
}




//func queryLatestAds() -> [Advertisement] {
//
//    var ads:[Advertisement] = []
//
//    PFQuery(className: "Advertisement")
//        .orderByDescending("createdAt")
//        .findObjectsInBackgroundWithBlock { (results: [AnyObject]?, error: NSError?) -> Void in
//            if error == nil {
//                if let objects = results as? [PFObject] {
//                    ads = map(objects, {pfObjectToAd($0)})
//                }
//            }
//    }
//
//    return ads
//}