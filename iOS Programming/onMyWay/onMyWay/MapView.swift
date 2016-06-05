//
//  MapView.swift
//  onMyWay
//
//  Created by Dawood Khan on 5/10/16.
//  Copyright © 2016 XariaDawood. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class MapView: UIViewController {
    
    //MARK: Properties
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var directionsTableView: DirectionsTableView!
    
    var activityIndicator: UIActivityIndicatorView?
    var locationArray: [(textField: UITextField!, text: String!, mapItem: MKMapItem?)]!
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        addActivityIndicator()
        calculateSegmentDirections(0, time: 0, routes: [])
        locationArray.removeLast()
        
        // Drop a pin at each stop
        for (var i = 0; i < locationArray.count; i++) {
            if (locationArray[i].text.isEmpty) {
                locationArray[i].text = locationArray[i].textField.text!
            }
            print(locationArray[i].text!)
            
            let address = locationArray[i].text!
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
                if ((error) != nil) {
                    print("Error", error)
                }
                if let placemark = placemarks?.first {
                    let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                    let dropPin = MKPointAnnotation()
                    dropPin.coordinate = coordinates
                    self.mapView.addAnnotation(dropPin)
                }
            })
        }
    }
    
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: UIScreen.mainScreen().bounds)
        activityIndicator?.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator?.backgroundColor = view.backgroundColor
        activityIndicator?.startAnimating()
        view.addSubview(activityIndicator!)
    }
    
    func hideActivityIndicator() {
        if activityIndicator != nil {
            activityIndicator?.removeFromSuperview()
            activityIndicator = nil
        }
    }
    
    //Create the segmented routes
    func calculateSegmentDirections(index: Int,time: NSTimeInterval, routes: [MKRoute]) {
        let request: MKDirectionsRequest = MKDirectionsRequest()
        request.source = locationArray[index].mapItem
        request.destination = locationArray[index+1].mapItem
        request.requestsAlternateRoutes = true
        request.transportType = .Walking
        let directions = MKDirections(request: request)
        directions.calculateDirectionsWithCompletionHandler ({
            (response: MKDirectionsResponse?, error: NSError?) in
            if let routeResponse = response?.routes {
                let quickestRouteForSegment: MKRoute =
                routeResponse.sort({$0.expectedTravelTime <
                    $1.expectedTravelTime})[0]
                
                var timeVar = time
                var routeVar = routes
                routeVar.append(quickestRouteForSegment)
                timeVar += quickestRouteForSegment.expectedTravelTime
                if index+2 < self.locationArray.count {
                    self.calculateSegmentDirections(index+1, time: timeVar, routes: routeVar)
                } else {
                    self.hideActivityIndicator()
                    self.showRoute(routeVar, time: timeVar)
                }
                
            } else if let _ = error {
                let alert = UIAlertController(title: nil,
                    message: "Directions not available.", preferredStyle: .Alert)
                let okButton = UIAlertAction(title: "OK",
                    style: .Cancel) { (alert) -> Void in
                        self.navigationController?.popViewControllerAnimated(true)
                }
                alert.addAction(okButton)
                self.presentViewController(alert, animated: true,
                    completion: nil)
            }
        })
    }
    
    //Display directions table view
    func displayDirections(directionsArray: [(startingAddress: String,
        endingAddress: String, route: MKRoute)]) {
            directionsTableView.directionsArray = directionsArray
            directionsTableView.delegate = directionsTableView
            directionsTableView.dataSource = directionsTableView
            directionsTableView.reloadData()
    }
    
    func showRoute(routes: [MKRoute], time: NSTimeInterval) {
        var directionsArray = [(startingAddress: String, endingAddress: String, route: MKRoute)]()
        for i in 0..<routes.count {
            plotPolyline(routes[i])
            directionsArray += [(locationArray[i].text!,
                endAddress: locationArray[i+1].text!, route: routes[i])]
        }
        displayDirections(directionsArray)
        printTimeToLabel(time)
    }
    
    func printTimeToLabel(time: NSTimeInterval) {
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = false
        automaticallyAdjustsScrollViewInsets = false
    }
    
    func plotPolyline(route: MKRoute) {
        mapView.addOverlay(route.polyline)
        if mapView.overlays.count == 1 {
            mapView.setVisibleMapRect(route.polyline.boundingMapRect,
                edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0),
                animated: false)
        }
        else {
            let polylineBoundingRect =  MKMapRectUnion(mapView.visibleMapRect,
                route.polyline.boundingMapRect)
            mapView.setVisibleMapRect(polylineBoundingRect,
                edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0),
                animated: false)
        }
    }
}

//MARK: Delegate
extension MapView: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView,rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if (overlay is MKPolyline) {
            if mapView.overlays.count == 1 {
                polylineRenderer.strokeColor =
                    UIColor.redColor().colorWithAlphaComponent(0.75)
            } else if mapView.overlays.count == 2 {
                polylineRenderer.strokeColor =
                    UIColor.orangeColor().colorWithAlphaComponent(0.75)
            } else if mapView.overlays.count == 3 {
                polylineRenderer.strokeColor =
                    UIColor.yellowColor().colorWithAlphaComponent(0.75)
            }
            else if mapView.overlays.count == 4 {
                polylineRenderer.strokeColor =
                    UIColor.greenColor().colorWithAlphaComponent(0.75)
            }
            else if mapView.overlays.count == 5 {
                polylineRenderer.strokeColor =
                    UIColor.blueColor().colorWithAlphaComponent(0.75)
            }
            else if mapView.overlays.count == 6 {
                polylineRenderer.strokeColor =
                    UIColor.purpleColor().colorWithAlphaComponent(0.75)
            }
            else if mapView.overlays.count == 7 {
                polylineRenderer.strokeColor =
                    UIColor.magentaColor().colorWithAlphaComponent(0.75)
            }
            else if mapView.overlays.count == 8 {
                polylineRenderer.strokeColor =
                    UIColor.whiteColor().colorWithAlphaComponent(0.75)
            }
            else if mapView.overlays.count == 9 {
                polylineRenderer.strokeColor =
                    UIColor.lightGrayColor().colorWithAlphaComponent(0.75)
            }
            else if mapView.overlays.count == 10 {
                polylineRenderer.strokeColor =
                    UIColor.blackColor().colorWithAlphaComponent(0.75)
            }
            polylineRenderer.lineWidth = 5
        }
        return polylineRenderer
    }
}