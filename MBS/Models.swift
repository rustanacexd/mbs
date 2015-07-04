//
//  Models.swift
//  MBS
//
//  Created by Rustan Corpuz on 6/26/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import Foundation
import Parse

struct Advertisement {
    
    var title: String
    var description: String?
    var price: Double
    let image: PFFile
    var category: String
    var sold: Bool = false
    var condition: String?
    let seller: PFUser
    let sellerUsername: String
    let createdAt: NSDate
    
    func getDescription() -> String {
        return "\(self.title) \(self.description)"
    }
    
    //    func getSellerUsername () -> String {
    //        var username = ""
    //
    //        (self.toPFObject()["seller"]! as! PFUser).fetchIfNeededInBackgroundWithBlock({
    //            (seller: PFObject?, error: NSError?) -> Void in
    //            username = (seller as! PFUser).username!
    //        })
    //
    //        return username
    //    }
    
    
    init(imageData: NSData, title: String, description: String?, price: Double,
        category: String, condition: String?){
            
            self.title = title
            self.description = description != nil ? description! : ""
            self.price = price
            self.category = category
            self.sold = false
            self.condition = condition != nil ? condition! : ""
            self.seller = PFUser.currentUser()!
            self.sellerUsername = PFUser.currentUser()!.username!
            self.image = PFFile(name: "\(self.seller.username!)",
                data: imageData, contentType: ".jpg")
            self.createdAt = NSDate()
    }
    
    init(image: PFFile, title: String, description: String?, price: Double, category: String,
        condition: String?, seller: PFUser,sellerUsername: String, createdAt: NSDate){
            
            self.title = title
            self.description = description != nil ? description! : ""
            self.price = price
            self.category = category
            self.sold = false
            self.condition = condition != nil ? condition! : ""
            self.seller = seller
            self.sellerUsername = sellerUsername
            self.image = image
            self.createdAt = createdAt
    }
    
    func saveAd() -> Bool{
        var status = false
        self.toPFObject().saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                status = true
                println("done")
            } else {
                println(error?.description)
            }
        }
        return status
    }
    
    func toPFObject() -> PFObject{
        let adObject = PFObject(className: "Advertisement")
        adObject["title"] = self.title
        adObject["description"] = self.description
        adObject["price"] = self.price
        adObject["category"] = self.category
        adObject["sold"] = self.sold
        adObject["condition"] = self.condition
        adObject["seller"] = self.seller
        adObject["sellerUsername"] = self.sellerUsername
        adObject["image"] = self.image
        return adObject
    }
}

func pfObjectToAd(object: PFObject) -> Advertisement {
    return Advertisement(image: object["image"] as! PFFile, title: object["title"] as! String,
        description: object["description"] as? String, price: object["price"] as! Double,
        category: object["category"] as! String,
        condition: object["condition"] as? String, seller: object["seller"] as! PFUser,
        sellerUsername: object["sellerUsername"] as! String,createdAt: object.createdAt!)
}


func fetchAdsBy (key: String? = nil, equalTo: String? = nil, callback: ([Advertisement]) -> ()) {
    let query = PFQuery(className: "Advertisement")
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



//func fetchAds() -> [Advertisement] {
//    var ads = [Advertisement]()
//    let query = PFQuery(className: "Advertisement")
//    query.cachePolicy = PFCachePolicy.CacheThenNetwork
//    query.findObjectsInBackgroundWithBlock {
//        objects, error in
//        
//        if error == nil {
//            if let pfObjects = objects as? [PFObject]{
//                ads = map(pfObjects, {pfObjectToAd ($0)})
//            }
//        }
//    }
//    
//    //    if let unwrappedObjects = objects {
//    //        ads = map(objects!, {pfObjectToAd($0 as! PFObject)})
//    //    }
//    
//    return ads
//}

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

class CurrentUser {
    static let sharedInstance = CurrentUser()
    let firstName = PFUser.currentUser()!["firstName"] as! String
    //    let lastName = PFUser.currentUser()!["lastName"] as! String
    let username = PFUser.currentUser()!["username"] as! String
    let email = PFUser.currentUser()!["gender"] as! String
    //    let verified = PFUser.currentUser()!["verified"] as! Bool
    let gender = PFUser.currentUser()!["gender"] as! String
    let facebookID = PFUser.currentUser()!["facebookID"] as! String
    
}