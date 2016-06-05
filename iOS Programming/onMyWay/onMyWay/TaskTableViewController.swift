//
//  TaskTableViewController.swift
//  On My Way
//
//  Created by Xaria Kirtikar on 4/29/16.
//  Copyright (c) 2016 nyu.edu. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

var firstLoad = true

class TaskTableViewController: UITableViewController {
    
    // MARK: Properties
    @IBOutlet weak var setRouteButton: UIBarButtonItem!
    var tasks = [Task]()
    var startLL: String!
    var endLL: String!
    var currentTextField: UITextField!
    var coords: CLLocationCoordinate2D?
    var locationTuples: [(textField: UITextField!, text: String!, mapItem: MKMapItem?)]!
    var locationsArray: [(textField: UITextField!, text: String!, mapItem: MKMapItem?)] {
        var filtered = locationTuples.filter({ $0.mapItem != nil })
        filtered += [filtered.first!]
        return filtered
    }

    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load any saved tasks, otherwise load sample data.
        if let savedTasks = loadTasks() {
            tasks = savedTasks
        }
        else {
          //   Load the sample data.
            loadSampleTasks()
        }
        if firstLoad {
            updateLocationTuplesFromTasks()
            firstLoad = false
        }
    }
    
    func loadSampleTasks() {
        let flowerImage = UIImage(named: "flowers")!
        let task1 = Task(locationName: "Flower shop", address: "516 E 12th St.", rating: 1.0, photo: flowerImage)
        let chipotleLogo = UIImage(named: "chipotle")!
        let task2 = Task(locationName: "Chipotle", address: "41370 Carmen St.", rating: 5.0, photo: chipotleLogo)
        let starbucksLogo = UIImage(named: "coffee")!
        let task3 = Task(locationName: "Starbucks", address: "357 W 37th St.", rating: 3.5, photo: starbucksLogo)
        let gymPic = UIImage(named: "gym")!
        let task4 = Task(locationName: "24 Hour Fitness", address: "140 E 14th St.", rating: 2.0, photo: gymPic)
        let groceriesPic = UIImage(named: "groceries")!
        let task5 = Task(locationName: "Trader Joe's", address: "416 E 13th St.", rating: 4.0, photo: groceriesPic)
        
        tasks.append(task1!)
        tasks.append(task2!)
        tasks.append(task3!)
        tasks.append(task4!)
        tasks.append(task5!)
    }
    
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return tasks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "TaskTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TaskTableViewCell
        let task = tasks[indexPath.row]
        
        cell.nameLabel.text = task.locationName
        cell.addressLabel.text = task.address
        cell.ratingControl.rating = task.rating
        cell.photoView.image = task.photo
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        //Allow for deletion of tasks
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            locationTuples.removeAtIndex(indexPath.row)
            tasks.removeAtIndex(indexPath.row)
            saveTasks()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    }

    // MARK: Navigation
    //Serialize update of location tuples
    func insertAddressIntoLocationTuples(addressString: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(addressString, completionHandler:
            {(placemarks, error) in
                if error != nil {
                    print("Geocode failed with error: \(error!.localizedDescription)")
                }
                else if placemarks!.count > 0 {
                    let placemark = placemarks![0] as! CLPlacemark
                    let location = placemark.location
                    self.coords = location!.coordinate
                    let locationTupleLength = self.locationTuples.count
                    self.locationTuples.insert((self.currentTextField, addressString, MKMapItem(placemark:
                        MKPlacemark(coordinate: placemark.location!.coordinate,addressDictionary: placemark.addressDictionary as! [String:AnyObject]?))), atIndex: locationTupleLength - 1)
                }
        })
    }
    
    func updateLocationTuplesFromTasks() {
        for task in tasks {
            let addressString = task.address
            insertAddressIntoLocationTuples(addressString)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddTask" {
            print("Adding new task.", terminator: "")
            let navVC = segue.destinationViewController as! UINavigationController
            let taskVC = navVC.viewControllers.first as! TaskViewController
            taskVC.startLL = startLL
            taskVC.endLL = endLL
            taskVC.locationTuples = locationTuples
        }
        else if segue.identifier == "mapIt" {
            //TODO:
            //order locationtuples by distance from start
            let mapViewController = segue.destinationViewController as! MapView
            mapViewController.locationArray = locationsArray
        }
    }
    
    func setRouteNavigation(sender: UIBarButtonItem) {
    }
    
    @IBAction func unwindToTaskList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? TaskViewController, task = sourceViewController.task {
            // Add a new task.
            let newIndexPath = NSIndexPath(forRow: tasks.count, inSection: 0)
            tasks.append(task)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            // Save the tasks.
            saveTasks()
        }
    }
    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: NSCoding
    func saveTasks() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(tasks, toFile: Task.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save tasks...", terminator: "")
        }
    }
    
    func loadTasks() -> [Task]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Task.ArchiveURL.path!) as? [Task]
    }
}