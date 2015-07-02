//
//  CreateTableViewController.swift
//  MBS
//
//  Created by Rustan Corpuz on 6/29/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class CreateTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var condition: String!
    var category = ""
    
    let categories = ["Gadgets", "Vehicles" ,"Real Estate", "Jobs", "Applicanes","Others"]
    let conditions = ["Brand New", "Slightly Used", "Second Hand", "Old"]
    
    let titleTextViewTag = 0
    let descriptonTextViewTag = 1
    let titleTextViewPlaceholder = "Add Title Here"
    let descriptionTextViewPlaceholder = "\r\n\r\n\r\n Add Description Here"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let button = UIButton(frame: CGRect(x: view.frame.width - 55, y: 240, width: 50, height: 50))
        button.setImage(UIImage(named: "submit-ad-button"), forState: UIControlState.Normal)
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
    
    @IBAction func submitAd(sender: UIButton) {
        let ad = Advertisement(imageData: UIImageJPEGRepresentation(imageView.image, 0.2), title: titleTextView.text, description: descriptionTextView.text!,
            price: (priceTextField.text as NSString).doubleValue, category: Category(name: category, image: nil))
        ad.saveAd()
        
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
        
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 3 || indexPath.row == 4 {
            
            let doneButton = UIBarButtonItem(barButtonSystemItem: .Done,
                target: self, action: "endEditing:")
            
            let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel,
                target: self, action: "endEditing:")
            
            doneButton.tintColor = UIColor.darkGrayColor()
            cancelButton.tintColor = UIColor.darkGrayColor()
            
            let currentCell = tableView.cellForRowAtIndexPath(indexPath)!
            
            var action:ActionSheetStringPicker!
            
            if indexPath.row == 3 {
                action = ActionSheetStringPicker(title: "Select a category", rows: categories,
                    initialSelection: 0, doneBlock: { (pciker, selectedIndex, value) -> Void in
                        
                        currentCell.detailTextLabel?.text = "\(value)"
                        
                    }, cancelBlock: nil, origin: self.view)
            }
            
            if indexPath.row == 4 {
                action = ActionSheetStringPicker(title: "Select condition", rows: conditions,
                    initialSelection: 0, doneBlock: { (pciker, selectedIndex, value) -> Void in
                        currentCell.detailTextLabel?.text = "\(value)"
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
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let cell = textField.superview!.superview as! UITableViewCell
        tableView.scrollToRowAtIndexPath(tableView.indexPathForCell(cell)!,
            atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
    }
    
    //MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        let cell = textView.superview!.superview as! UITableViewCell
        tableView.scrollToRowAtIndexPath(tableView.indexPathForCell(cell)!,
            atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
        
        if textView.text == titleTextViewPlaceholder || textView.text == descriptionTextViewPlaceholder{
            textView.text = nil
        }
        
        //        if textView.textColor == UIColor.lightGrayColor() {
        //            textView.text = nil
        //            textView.textColor = UIColor.blackColor()
        //        }
        
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
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
}
