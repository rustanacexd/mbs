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


func fetchAds() -> [Advertisement] {
    
    var ads = [Advertisement]()
    let query = PFQuery(className: "Advertisement")

    
    var objects = query.findObjects()
    
    if let unwrappedObjects = objects {
        ads = map(objects!, {pfObjectToAd($0 as! PFObject)})
    }
    
    return ads
}


//func fetchAds(parameter: String? = nil) -> [Advertisement] {
//    
//    var ads = [Advertisement]()
//    let query = PFQuery(className: "Advertisement")
//    
//    if let predicate = parameter {
//        if predicate == "createdAt" {
//            query.orderByDescending("createdAt")
//        }
//        else if predicate == "price" {
//            query.orderByAscending("price")
//        }
//    }
//    
//    var objects = query.findObjects()
//    
//    if let unwrappedObjects = objects {
//        ads = map(objects!, {pfObjectToAd($0 as! PFObject)})
//    }
//    
//    return ads
//}


