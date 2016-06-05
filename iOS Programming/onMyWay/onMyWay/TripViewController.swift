//
//  TripViewController.swift
//  onMyWay
//
//  Created by Xaria Kirtikar on 5/9/16.
//  Copyright © 2016 XariaDawood. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

var locManager = CLLocationManager()


class TripViewController: UIViewController, UITextFieldDelegate{

    //MARK: Properties
    @IBOutlet weak var startField: UITextField!
    @IBOutlet var finalDestinationField: UITextField!
    @IBOutlet var enterButtonArray: [UIButton]!
    @IBOutlet weak var addTask: UIBarButtonItem!
    
    //MARK: Location Properties
    var coords: CLLocationCoordinate2D?
    var startLL: String!
    var endLL: String!
    var locationTuples: [(textField: UITextField!, text: String!, mapItem: MKMapItem?)]!
    
    var locationsArray: [(textField: UITextField!, text: String!, mapItem: MKMapItem?)] {
        var filtered = locationTuples.filter({ $0.mapItem != nil })
        filtered += [filtered.first!]
        return filtered
    }
    
    //TODO:
    //dawood -- global initialization?
    let locationManager = CLLocationManager()
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize location based services
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            locationManager.requestLocation()
        }
        locationTuples = [(startField, startField.text, nil), (finalDestinationField, finalDestinationField.text, nil)]
    }
    
    @IBAction func addressEntered(sender: AnyObject) {
        view.endEditing(true)
        let currentTextField = locationTuples[sender.tag-1].textField
        CLGeocoder().geocodeAddressString(currentTextField.text!,
            completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                if let placemarks = placemarks {
                    var addresses = [String]()
                    for placemark in placemarks {
                        addresses.append(self.formatAddressFromPlacemark(placemark))
                    }
                    self.showAddressTable(addresses, textField: currentTextField,
                        placemarks: placemarks, sender: sender as! UIButton)
                }
                else {
                    self.showAlert("Address was not found.")
                }
        })
    }
    
    //MARK: AddressTableView functionality
    func showAddressTable(addresses: [String], textField: UITextField,
        placemarks: [CLPlacemark], sender: UIButton) {
            let addressTableView = AddressTableView(frame: UIScreen.mainScreen().bounds, style: UITableViewStyle.Plain)
            addressTableView.addresses = addresses
            addressTableView.currentTextField = textField
            addressTableView.placemarkArray = placemarks
            addressTableView.mainViewController = self
            addressTableView.sender = sender
            addressTableView.delegate = addressTableView
            addressTableView.dataSource = addressTableView
            view.addSubview(addressTableView)
    }
    
    func formatAddressFromPlacemark(placemark: CLPlacemark) -> String {
        return (placemark.addressDictionary!["FormattedAddressLines"] as!
            [String]).joinWithSeparator(", ")
    }
    
    func showAlert(alertString: String) {
        let alert = UIAlertController(title: nil, message: alertString, preferredStyle: .Alert)
        let okButton = UIAlertAction(title: "OK",
            style: .Cancel) { (alert) -> Void in
        }
        alert.addAction(okButton)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func dissmissKeyboard() {
        finalDestinationField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        finalDestinationField.resignFirstResponder()
        return true
    }
    
    //MARK: Segue
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if (locationTuples[0].mapItem == nil || locationTuples[1].mapItem == nil) {
                showAlert("Please enter a valid starting point and at least one destination.")
                return false
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let taskTableViewController = segue.destinationViewController as! TaskTableViewController
        taskTableViewController.startLL = startLL
        taskTableViewController.endLL = endLL
        taskTableViewController.locationTuples = locationTuples
    }
}

//MARK: Delegate
extension TripViewController: CLLocationManagerDelegate {
    
    //TODO:
    //should auto populate start location based on current location?
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(locations.last!,
            completionHandler: {(placemarks:[CLPlacemark]?, error:NSError?) -> Void in
                if let placemarks = placemarks {
                    let placemark = placemarks[0]
                    self.locationTuples[0].mapItem = MKMapItem(placemark:
                        MKPlacemark(coordinate: placemark.location!.coordinate,addressDictionary: placemark.addressDictionary as! [String:AnyObject]?))
                    self.startField.text = self.formatAddressFromPlacemark(placemark)
                    self.enterButtonArray.filter{$0.tag == 1}.first!.selected = true
                }
        })
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
}