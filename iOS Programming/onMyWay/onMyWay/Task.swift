//
//  Task.swift
//  On My Way
//
//  Created by Xaria Kirtikar on 4/29/16.
//  Copyright (c) 2016 nyu.edu. All rights reserved.
//

import UIKit

class Task: NSObject, NSCoding {

    // MARK: Properties
    struct PropertyKey {
        static let locationNameKey = "locationName"
        static let addressKey = "address"
        static let ratingKey = "rating"
        static let photoKey = "photo"
    }
    
    var locationName: String
    var address: String
    var rating: Double
    var photo: UIImage?
    
    // MARK: Archiving Paths
    static let DocumentsDirectory: AnyObject = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("tasks")

    // MARK: Initialization
    init?(locationName: String, address: String, rating: Double, photo: UIImage?) {
        // Initialize stored properties.
        self.locationName = locationName
        self.address = address
        self.rating = rating
        self.photo = photo
        super.init()
        
        // Initialization should fail if there is no name or if the rating is negative.
        if locationName.isEmpty || address.isEmpty || rating < 0.0  {
            return nil
        }
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(locationName, forKey: PropertyKey.locationNameKey)
        aCoder.encodeObject(address, forKey: PropertyKey.addressKey)
        aCoder.encodeDouble(rating, forKey: PropertyKey.ratingKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let locationName = aDecoder.decodeObjectForKey(PropertyKey.locationNameKey) as! String
        let address = aDecoder.decodeObjectForKey(PropertyKey.addressKey) as! String
        let rating = aDecoder.decodeDoubleForKey(PropertyKey.ratingKey)
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        
        // Must call designated initializer.
        self.init(locationName: locationName, address: address, rating: rating, photo: photo)
    }
}