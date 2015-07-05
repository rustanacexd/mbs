//
//  CreateTableViewController.swift
//  MBS
//
//  Created by Rustan Corpuz on 6/29/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import UIKit
import Parse
import ActionSheetPicker_3_0

class CreateTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fbShareSwitch: UISwitch!
    
    var condition: String = ""
    var category: String = ""
    
    let categories = ["Gadgets", "Vehicles" ,"Real Estate", "Jobs", "Applicanes","Others"]
    let conditions = ["Brand New", "Slightly Used", "Second Hand", "Old"]
    
    let titleTextViewTag = 0
    let descriptonTextViewTag = 1
    let titleTextViewPlaceholder = "Add Title Here *"
    let descriptionTextViewPlaceholder = "\r\n\r\n\r\n Add Description Here *"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let button = UIButton(frame: CGRect(x: view.frame.width - 55, y: 240, width: 50, height: 50))
        button.setImage(UIImage(named: "submit-add"), forState: UIControlState.Normal)
        button.addTarget(self, action: "submitAd", forControlEvents: UIControlEvents.TouchUpInside)
        tableView.addSubview(button)
        
        priceTextField.delegate = self
        titleTextView.delegate = self
        descriptionTextView.delegate = self
        contactTextField.delegate = self
        
        priceTextField.addDoneButton()
        descriptionTextView.addDoneButton()
        titleTextView.addDoneButton()
        contactTextField.addDoneButton()
        
        titleTextView.tag = titleTextViewTag
        descriptionTextView.tag = descriptonTextViewTag
        
        titleTextView.text = titleTextViewPlaceholder
        descriptionTextView.text = descriptionTextViewPlaceholder
        titleTextView.textColor = UIColor.whiteColor()
        
        priceTextField.textColor = UIColor.facebookBlue()
        contactTextField.textColor = UIColor.facebookBlue()
        fbShareSwitch.onTintColor = UIColor.facebookBlue()

        
        
        let pricePlaceholder = NSAttributedString(string: "Price",
            attributes: [NSForegroundColorAttributeName:UIColor.lightBlue()])
        
        let contactPlaceholder =  NSAttributedString(string: "Mobile Number",
            attributes: [NSForegroundColorAttributeName:UIColor.lightBlue()])
        
        priceTextField.attributedPlaceholder = pricePlaceholder
        contactTextField.attributedPlaceholder  = contactPlaceholder

        
    }
    
    @IBAction func dismissModal(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pickImage(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            imagePicker.sourceType = .PhotoLibrary
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func submitAd() {
        if validateFields() {
            let ad = Advertisement(className: Advertisement.parseClassName())
            ad.image = PFFile(data: UIImageJPEGRepresentation(imageView.image, 0.1), contentType: ".jpg")
            ad.title = titleTextView.text
            ad.shortDescription = descriptionTextView.text
            ad.price = (priceTextField.text as NSString).doubleValue
            ad.category = category
            ad.condition = condition
            ad.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                if error == nil {
                    println("done")
                }
            })
        }
    }
    
    private func validateFields() -> Bool {
        var errorMessage = ""
        
        if imageView.image == nil {
            errorMessage = "Image is required"
        }
            
        else if titleTextView.text == titleTextViewPlaceholder {
            errorMessage = "Title is not set"
        }
            
        else if priceTextField.text.isEmpty {
            errorMessage = "Price is required"
        }
            
        else if category.isEmpty {
            errorMessage = "Category is required"
        }
            
        else if contactTextField.text.isEmpty {
            errorMessage = "Contact number is required"
        }
        
        
        let alertController = UIAlertController(title: "Missing Fields",
            message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "Ok I'll fix it", style: UIAlertActionStyle.Default, handler: nil)
        alertController.view.tintColor = UIColor.facebookBlue()
        alertController.addAction(okAction)
        
        if !errorMessage.isEmpty {
            presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        return true
        
    }
    //MARK: - UITableView DataSource
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // Remove seperator inset
        if cell.respondsToSelector("separatorInset:") {
            cell.separatorInset = UIEdgeInsetsZero
        }
        
        // Prevent the cell from inheriting the Table View's margin settings
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        
        if indexPath.row == 0 {
            cell.backgroundColor = UIColor.lightBlue()
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.detailTextLabel?.textColor = UIColor.lightBlue()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 3 || indexPath.row == 4 {
            
            let doneButton = UIBarButtonItem(barButtonSystemItem: .Done,
                target: self, action: "endEditing:")
            
            let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel,
                target: self, action: "endEditing:")
            
            doneButton.tintColor = UIColor.facebookBlue()
            cancelButton.tintColor = UIColor.facebookBlue()
            
            let currentCell = tableView.cellForRowAtIndexPath(indexPath)!
            
            var action:ActionSheetStringPicker!
            
            if indexPath.row == 3 {
                action = ActionSheetStringPicker(title: "Select a category", rows: categories,
                    initialSelection: 0, doneBlock: { (pciker, selectedIndex, value) -> Void in
                        
                        currentCell.detailTextLabel?.text = "\(value)"
                        self.category = "\(value)"
                        
                    }, cancelBlock: nil, origin: self.view)
            }
            
            if indexPath.row == 4 {
                action = ActionSheetStringPicker(title: "Select condition", rows: conditions,
                    initialSelection: 0, doneBlock: { (pciker, selectedIndex, value) -> Void in
                        currentCell.detailTextLabel?.text = "\(value)"
                        self.condition  = "\(value)"
                    }, cancelBlock: nil, origin: self.view)
            }
            
            action.setDoneButton(doneButton)
            action.setCancelButton(cancelButton)
            action.showActionSheetPicker()
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.alpha = 0.5
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let cell = textField.superview!.superview as! UITableViewCell
        tableView.scrollToRowAtIndexPath(tableView.indexPathForCell(cell)!,
            atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if (range.length + range.location > count(textField.text) )
        {
            return false;
        }
        
        let newLength = count(textField.text) + count(string) - range.length
        return newLength <= 11
    }
    
    //MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        let cell = textView.superview!.superview as! UITableViewCell
        tableView.scrollToRowAtIndexPath(tableView.indexPathForCell(cell)!,
            atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
        
        if textView.text == titleTextViewPlaceholder || textView.text == descriptionTextViewPlaceholder{
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        if textView.text.isEmpty && textView.tag == titleTextViewTag {
            textView.text = titleTextViewPlaceholder
            //            textView.textColor = UIColor.lightGrayColor()
            
        }
        
        if textView.text.isEmpty && textView.tag == descriptonTextViewTag {
            textView.text = descriptionTextViewPlaceholder
            //            textView.textColor = UIColor.lightGrayColor()
        }
        
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (range.length + range.location > count(textView.text)) {
            return false;
        }
        
        let newLength = count(textView.text) + count(text) - range.length
        
        return textView.tag == titleTextViewTag ? newLength <= 57 : newLength <= 320
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func navigationController(navigationController: UINavigationController,
        willShowViewController viewController: UIViewController, animated: Bool) {
            UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    }
    
    override func childViewControllerForStatusBarHidden() -> UIViewController? {
        return nil
    }
    
    
}
