//
//  UIColor+Convenience.swift
//  MBS
//
//  Created by Rustan Corpuz on 6/25/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func lightGreen() -> UIColor{
        return UIColor(red: 80.0 / 255.0, green: 227.0 / 225.0, blue: 194.0 / 225.0, alpha: 0.8)
    }
}

extension UILabel {
    var substituteFontName : String {
        get { return self.font.fontName }
        set {
            if self.font.fontName.rangeOfString("Medium") == nil {
                self.font = UIFont(name: newValue, size: self.font.pointSize)
            }
        }
    }
    
    var substituteFontNameBold : String {
        get { return self.font.fontName }
        set {
            if self.font.fontName.rangeOfString("Black") != nil {
                self.font = UIFont(name: newValue, size: self.font.pointSize)
            }
        }
    }
    
    
}


//-(void)changeFont:(UIView *) view{
//    for (id View in [view subviews]) {
//        if ([View isKindOfClass:[UILabel class]]) {
//            [View setFont:[UIFont fontWithName:@"Candara" size:26]];
//            View.textColor = [UIColor blueColor];
//            [View setBackgroundColor:[UIColor clearColor]];
//        }
//        if ([View isKindOfClass:[UIView class]]) {
//            [self changeFont:View];
//        }
//    }
//}

//extension UIView {
//    class func changeFont(view: UIView) {
//        for subViews in view.subviews  {
//            if subViews.isKindOfClass(UILabel) {
//                let label = subViews as! UILabel
//                label.font = UIFont(name: "Avenir", size: 26)
//                label.textColor = UIColor.redColor()
//            }
//            
//            if subViews.isKindOfClass(UIView) {
//                let view = subViews as! UIView
//                UIView.changeFont(view)
//                
//            }
//        }
//    }
//}

extension UIView {
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
            target: nil, action: nil)
        
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done,
            target: self, action: Selector("endEditing:"))
        
        doneBarButton.tintColor = UIColor.darkGrayColor()
        
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        
        if self.isKindOfClass(UITextField) {
            (self as! UITextField).inputAccessoryView  = keyboardToolbar
        }
        else if self.isKindOfClass(UITextView) {
            (self as! UITextView).inputAccessoryView  = keyboardToolbar
        }
    }
}


extension UIImage {
    public func resize(size:CGSize, completionHandler:(resizedImage:UIImage, data:NSData)->()) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
            var newSize:CGSize = size
            let rect = CGRectMake(0, 0, newSize.width, newSize.height)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            self.drawInRect(rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let imageData = UIImageJPEGRepresentation(newImage, 0.5)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(resizedImage: newImage, data:imageData)
            })
        })
    }
    
    func compress() -> NSData {
        var compression: CGFloat = 0.9
        let maxCompression: CGFloat = 0.1
        let maxFileSize = 250*1024
        var imageData = NSData(data: UIImageJPEGRepresentation(self, compression))
        
        while imageData.length > maxFileSize && compression > maxCompression {
            compression = compression -  maxCompression
            imageData = UIImageJPEGRepresentation(self, compression)
        }
        
        return imageData
    }
}





