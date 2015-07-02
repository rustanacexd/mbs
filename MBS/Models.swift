//
//  Models.swift
//  MBS
//
//  Created by Rustan Corpuz on 6/26/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import Foundation
import Parse

struct Category {
    let name: String
    let image: UIImage?
}

struct Advertisement {
    
//    enum Condition: String {
//        case BrandNew = "Brand New"
//        case SecondHand = "Second Hand"
//        case SlightyUsed = "Slightly Used"
//    }
    
    var title: String
    var description: String
    var price: Double
    let image: PFFile
    var category: Category
    var sold: Bool = false
    var condition: String
    let seller: PFUser
    
    func getDescription() -> String {
        return "\(self.title) \(self.description)"
    }
    
    init(imageData: NSData, title: String, description: String, price: Double, category: Category){
        self.title = title
        self.description = description
        self.price = price
        self.category = category
        self.sold = false
        self.condition = "Brand New"
        self.seller = PFUser.currentUser()!
        self.image = PFFile(name: "\(self.title)-\(self.seller.username!)-\(NSDate())", data: imageData, contentType: ".jpg")
    }
    
    func saveAd() {
        self.toPFObject().saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                
            } else {
                println(error?.description)
            }
        }
    }
    
    func toPFObject() -> PFObject{
        let adObject = PFObject(className: "Advertisement")
        adObject["title"] = self.title
        adObject["description"] = self.description
        adObject["category"] = self.category.name
        adObject["sold"] = self.sold
        adObject["condition"] = self.condition
        adObject["seller"] = self.seller
        adObject["image"] = self.image
        
        return adObject
    }
}


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