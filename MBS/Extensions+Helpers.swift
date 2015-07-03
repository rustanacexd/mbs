//
//  UIColor+Convenience.swift
//  MBS
//
//  Created by Rustan Corpuz on 6/25/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import Foundation
import UIKit
import Parse

extension UIColor {
    class func lightBlue() -> UIColor {
        return UIColor(red: 139/255.0, green: 157/255.0, blue: 195/255.0, alpha: 1.0)
    }

    class func facebookBlue() -> UIColor {
        return  UIColor(red: 59/255.0, green: 89/255.0, blue: 152/255.0, alpha: 1.0)
    }
}

extension UIView {
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
            target: nil, action: nil)
        
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done,
            target: self, action: Selector("endEditing:"))
        
        doneBarButton.tintColor = UIColor.facebookBlue()
        
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        
        if self.isKindOfClass(UITextField) {
            (self as! UITextField).inputAccessoryView  = keyboardToolbar
        }
        else if self.isKindOfClass(UITextView) {
            (self as! UITextView).inputAccessoryView  = keyboardToolbar
        }
    }
}
