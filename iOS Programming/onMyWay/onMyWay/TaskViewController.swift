//
//  TaskViewController.swift
//  On My Way
//
//  Created by Xaria Kirtikar on 4/26/16.
//  Copyright (c) 2016 nyu.edu. All rights reserved.
//

import UIKit
import MapKit

class TaskViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: properties
    @IBOutlet weak var taskLocationLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    var startLL: String!
    var endLL: String!
    var locationTuples: [(textField: UITextField!, text: String!, mapItem: MKMapItem?)]!
    /*
    This value is either passed by `TaskTableViewController` in `prepareForSegue(_:sender:)`
    or constructed as part of adding a new task.
    */
    var task: Task?
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchField.delegate = self
        
        // Set up views if editing an existing Task.
        if let task = task {
            navigationItem.title = task.locationName
            searchField.text   = task.locationName
        }
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
       if segue.identifier == "showYelp" {
            let yelpViewController = segue.destinationViewController as! YelpSearchViewController
            yelpViewController.yelpSearchField = searchField.text!
            yelpViewController.startLL = startLL
            yelpViewController.endLL = endLL
            yelpViewController.locationTuples = locationTuples
        }
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        navigationItem.title = textField.text
    }
}