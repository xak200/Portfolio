
import UIKit
import MapKit

class AddressTableView: UITableView {
    
    var mainViewController: TripViewController!
    var addresses: [String]!
    var placemarkArray: [CLPlacemark]!
    var currentTextField: UITextField!
    var sender: UIButton!
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.registerClass(UITableViewCell.self, forCellReuseIdentifier: "AddressCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension AddressTableView: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = UIFont(name: "HoeflerText-Black", size: 18)
        label.textAlignment = .Center
        label.text = "Did you mean..."
        label.backgroundColor = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/225.0, alpha: 1)
        
        return label
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        removeFromSuperview()
        if addresses.count > indexPath.row {
            print(addresses.count)
            print(indexPath.row)
            currentTextField.text = addresses[indexPath.row]
            if (currentTextField.tag == 1) {
                //startField
                mainViewController.startLL = String(placemarkArray[indexPath.row].location!.coordinate.latitude) + ", " + String(placemarkArray[indexPath.row].location!.coordinate.longitude)
            }
            else if (currentTextField.tag == 2) {
                //endField
                mainViewController.endLL = String(placemarkArray[indexPath.row].location!.coordinate.latitude) + ", " + String(placemarkArray[indexPath.row].location!.coordinate.longitude)
            }
            let mapItem = MKMapItem(placemark:
                MKPlacemark(coordinate: placemarkArray[indexPath.row].location!.coordinate,
                    addressDictionary: placemarkArray[indexPath.row].addressDictionary
                        as! [String:AnyObject]?))
            mainViewController.locationTuples[currentTextField.tag-1].mapItem = mapItem
            sender.selected = true
        }
    }
}

extension AddressTableView: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AddressCell") as UITableViewCell!
        cell.textLabel?.numberOfLines = 3
        cell.textLabel?.font = UIFont(name: "HoeflerText-Regular", size: 11)
        
        if addresses.count > indexPath.row {
            cell.textLabel?.text = addresses[indexPath.row]
        }
        else {
            cell.textLabel?.text = "None of the above"
        }
        return cell
    }
}
