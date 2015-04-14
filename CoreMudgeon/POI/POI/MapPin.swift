//
//  MapPin.swift
//  POI
//
//  Created by james c Woodard on 4/11/15.
//  Copyright (c) 2015 CW. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapPin: NSObject, MKAnnotation {

    let id:Int
    let coordinate:CLLocationCoordinate2D
    let title:String
    let subtitle:String
   
    init(idNumber:Int, lat:Double, lon:Double, name:String, address:String) {
        self.id = idNumber
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        self.title = name
        self.subtitle = address
    }
}
