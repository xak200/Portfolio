import UIKit
import MapKit

class DirectionsTableView: UITableView {
    
    var directionsArray: [(startingAddress: String, endingAddress: String, route: MKRoute)]!
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension DirectionsTableView: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
//    
//    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 40
//    }
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let label = UILabel()
//        label.font = UIFont(name: "HoeflerText-Regular", size: 14)
//        label.numberOfLines = 5
//        setLabelBackgroundColor(label, section: section)
//        
//        label.text = "SEGMENT #\(section+1)\n\nStarting point: \(directionsArray[section].startingAddress)\n"
//        
//        return label
//    }
//    
//    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        
//        let label = UILabel()
//        label.font = UIFont(name: "HoeflerText-Regular", size: 14)
//        label.numberOfLines = 8
//        setLabelBackgroundColor(label, section: section)
//        
//        let route = directionsArray[section].route
//        let time = route.expectedTravelTime.formatted()
//        let miles = route.distance.miles()
//        label.text = "Ending point: \(directionsArray[section].endingAddress)\n\nDistance: \(miles) miles\n\nExpected Travel Time: \(time)"
//        
//        return label
//    }
    
    func setLabelBackgroundColor(label: UILabel, section: Int) {
        switch section {
        case 0:
            label.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.75)
        case 1:
            label.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.75)
        default:
            label.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.75)
        }
    }
}

extension DirectionsTableView: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return directionsArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return directionsArray[section].route.steps.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DirectionCell") as UITableViewCell!
        cell.textLabel?.numberOfLines = 4
        cell.textLabel?.font = UIFont(name: "HoeflerText-Regular", size: 12)
        cell.userInteractionEnabled = false
        
        let steps = directionsArray[indexPath.section].route.steps
        let step = steps[indexPath.row]
        let instructions = step.instructions
        let distance = step.distance.miles()
        cell.textLabel?.text = "\(indexPath.row+1). \(instructions) - \(distance) miles"
        
        return cell
    }
}

extension Float {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
}

extension CLLocationDistance {
    func miles() -> String {
        let miles = Float(self)/1609.344
        return miles.format(".2")
    }
}

extension NSTimeInterval {
    func formatted() -> String {
        let formatter = NSDateComponentsFormatter()
        formatter.unitsStyle = .Full
        formatter.allowedUnits = [NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second]
        
        return formatter.stringFromTimeInterval(self)!
    }
}