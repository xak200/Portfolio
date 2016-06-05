//
//  TaskViewController.swift
//  On My Way
//
//  Created by Xaria Kirtikar on 4/26/16.
//  Copyright (c) 2016 nyu.edu. All rights reserved.
//

import UIKit
//import Alamofire

class TaskViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: properties
    
    @IBOutlet weak var taskLocationLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var distanceField: UITextField!
    @IBOutlet weak var ratingField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    //    @IBOutlet weak var ratingControl: RatingControl!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
    This value is either passed by `TaskTableViewController` in `prepareForSegue(_:sender:)`
    or constructed as part of adding a new task.
    */
    var task: Task?
    //var businesses: [Business]!
    
    
    //    //hook up Yelp API
    //    @IBAction func searchAPI(sender: UIButton) {
    //        Alamofire.request(.GET, "https://httpbin.org/get")
    //
    //        Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])
    //            .responseJSON { response in
    //                print(response.request)  // original URL request
    //                print(response.response) // URL response
    //                print(response.data)     // server data
    //                print(response.result)   // result of response serialization
    //
    //                if let JSON = response.result.value {
    //                    print("JSON: \(JSON)")
    //                }
    //        }
    //    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchField.delegate = self
        
        // Set up views if editing an existing Meal.
        if let task = task {
            navigationItem.title = task.locationName
            searchField.text   = task.locationName
            priceField.text = task.price
            //            ratingControl.rating = task.rating
            ratingField.text = task.rating
            photoImageView.image = task.photo
            distanceField.text = task.distance
        }
        
        // Enable the Save button only if the text field has a valid Task name.
        checkValidTaskName()
        
        
        
        //        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
        //            self.businesses = businesses
        //
        //            for business in businesses {
        //                print(business.name!)
        //                print(business.address!)
        //            }
        //        })
        
        /* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
        self.businesses = businesses
        
        for business in businesses {
        print(business.name!)
        print(business.address!)
        }
        }
        */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddTaskMode = presentingViewController is UINavigationController
        if isPresentingInAddTaskMode {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let locationName = searchField.text ?? ""
            let price = priceField.text ?? ""
            let distance = distanceField.text ?? ""
            let photo = photoImageView.image
            //            let rating = ratingControl.rating
            let rating = ratingField.text ?? ""
            // Set the meal to be passed to MealTableViewController after the unwind segue.
            task = Task(locationName: locationName, rating: rating, price: price, distance: distance, photo: photo)
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        searchField.resignFirstResponder()
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidTaskName() {
        // Disable the Save button if the text field is empty.
        let text = searchField.text ?? ""
        let priceText = priceField.text ?? ""
        let ratingText = ratingField.text ?? ""
        let distanceText = distanceField.text ?? ""
        saveButton.enabled = !text.isEmpty && !priceText.isEmpty && !distanceText.isEmpty
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidTaskName()
        navigationItem.title = textField.text
    }
    
}

