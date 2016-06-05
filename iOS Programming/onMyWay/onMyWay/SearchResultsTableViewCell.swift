//
//  SearchResultsTableViewCell.swift
//  onMyWay
//
//  Created by Xaria Kirtikar on 5/6/16.
//  Copyright © 2016 XariaDawood. All rights reserved.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var ratingLabel: RatingControl!
    

    //MARK: Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}