import Foundation
import UIKit
import CoreLocation
import MapKit
import AddressBook

class YelpSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //MARK: Properties
    var businesses: [Business]!
    var enterPressed = false
    var mainViewController: TripViewController!
    var yelpSearchField = ""
    var currentTextField: UITextField!
    var placemarkArray: [CLPlacemark]!
    var startLL: String!
    var endLL: String!
    var coords: CLLocationCoordinate2D?
    var locationTuples: [(textField: UITextField!, text: String!, mapItem: MKMapItem?)]!
    
    //MARK: Functions
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var yelpTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yelpTable.dataSource = self
        yelpTable.delegate = self
    }
    
    @IBAction func enterSearch(sender: AnyObject) {
        enterPressed = true
        self.yelpTable.reloadData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SearchResultsTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SearchResultsTableViewCell
        let myBounds = startLL + "|" + endLL
        let bounds = myBounds.stringByReplacingOccurrencesOfString(" ", withString: "")
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode  = NSLineBreakMode.ByWordWrapping
        if yelpSearchField != "" {
            Business.searchWithTerm(self.yelpSearchField, bounds: bounds, completion: { (businesses: [Business]!, error: NSError!) -> Void in
                self.businesses = businesses
                if (businesses.count >= 5) {
                    for business in businesses {
                        cell.nameLabel.text = businesses[indexPath.row].name!
                        cell.addressLabel.text = businesses[indexPath.row].address!
                        cell.ratingLabel.rating = Double(businesses[indexPath.row].rating!)
                    }
                }
                else {
                    self.showAlert("Insufficient search results")
                }
            })
        }
        return cell
    }

    func showAlert(alertString: String) {
        let alert = UIAlertController(title: nil, message: alertString, preferredStyle: .Alert)
        let okButton = UIAlertAction(title: "OK",
            style: .Cancel) { (alert) -> Void in
        }
        alert.addAction(okButton)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("show_view", sender: indexPath)
    }
    
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "show_view" {
            let taskTableViewController = segue.destinationViewController as! TaskTableViewController
            // Get the cell that generated this segue.
            let indexPath = sender as? NSIndexPath
            if (indexPath != nil) {
                let name = businesses[indexPath!.row].name!
                let address = businesses[indexPath!.row].address!
                let rating = businesses[indexPath!.row].rating!
                var photo = UIImage(named: "noImage")
                taskTableViewController.insertAddressIntoLocationTuples(address)
                if (yelpSearchField == "coffee") || (yelpSearchField == "starbucks") {
                    photo = UIImage(named: "coffee")!
                }
                else if (yelpSearchField == "nails") {
                    photo = UIImage(named: "nails")
                }
                else if (yelpSearchField == "haircut") || (yelpSearchField == "salon") {
                    photo = UIImage(named: "haircut")
                }
                else if (yelpSearchField == "laundry") {
                    photo = UIImage(named: "laundry")
                }
                else if (yelpSearchField == "gym") {
                    photo = UIImage(named: "gym")
                }
                else if (yelpSearchField == "groceries") {
                    photo = UIImage(named: "groceries")
                }
                else if (yelpSearchField == "flowers") {
                    photo = UIImage(named: "flowers")
                }
                else if (yelpSearchField == "bank") || (yelpSearchField == "money") || (yelpSearchField == "cash") {
                    photo = UIImage(named: "bank")
                }
                else if (yelpSearchField == "chipotle") {
                    photo = UIImage(named: "chipotle")
                }
                else if (yelpSearchField == "dinner") || (yelpSearchField == "food") {
                    photo = UIImage(named: "dinner")
                }
                let selectedTask =  Task(locationName: name, address: address, rating: rating, photo: photo)
                taskTableViewController.tasks = taskTableViewController.loadTasks()!
                taskTableViewController.tasks.append(selectedTask!)
                taskTableViewController.saveTasks()
            }
            taskTableViewController.locationTuples = locationTuples
            taskTableViewController.startLL = startLL
            taskTableViewController.endLL = endLL
        }
    }
}