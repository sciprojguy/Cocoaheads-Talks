//
//  POICell.swift
//  POI
//
//  Created by james c Woodard on 4/11/15.
//  Copyright (c) 2015 CW. All rights reserved.
//

import UIKit

class POICell: UITableViewCell {

    @IBOutlet weak var poiNameLabel: UILabel!
    @IBOutlet weak var poiAddressLabel: UILabel!
    @IBOutlet weak var distanceFromHereLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setViewsFromInfo(info:[String:AnyObject]) -> Void {
        poiNameLabel.text = info["name"]! as? String
        poiAddressLabel.text = info["address"]! as? String
        distanceFromHereLabel.text = info["distance"] as? String
    }
    
}
