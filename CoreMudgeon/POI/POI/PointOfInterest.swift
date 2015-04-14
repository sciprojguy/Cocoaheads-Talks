//
//  Restaurant.swift
//  POI
//
//  Created by Chris Woodard on 4/5/15.
//  Copyright (c) 2015 CW. All rights reserved.
//

import Foundation

enum CompassHeading {
    case North, NorthEast, East, SouthEast, South, SouthWest, West, NorthWest
    func toString() -> String {
        var str = ""
        switch(self) {
            case .North: str = "N"
            case .NorthEast: str = "NE"
            case .East: str = "E"
            case .SouthEast: str = "SE"
            case .South: str = "S"
            case .SouthWest: str = "SW"
            case .West: str = "W"
            case .NorthWest: str = "NW"
            default:str = ""
        }
        return str
    }
}

func headingToCompassHeading(heading:Float) -> CompassHeading {
    var ch:CompassHeading = .North
    
    if( heading >= 337.5 && heading < 22.5 ) {
        ch = .North
    }
    else
    if( heading >= 22.5 && heading < 67.5 ) {
        ch = .NorthEast
    }
    else
    if( heading >= 67.5 && heading < 112.5 ) {
        ch = .East
    }
    else
    if( heading >= 112.5 && heading < 157.5 ) {
        ch = .SouthEast
    }
    else
    if( heading >= 157.5 && heading < 202.5 ) {
        ch = .South
    }
    else
    if( heading >= 202.5 && heading < 247.5 ) {
        ch = .SouthWest
    }
    else
    if( heading >= 247.5 && heading < 292.5 ) {
        ch = .West
    }
    else
    if( heading >= 292.5 && heading < 337.5 ) {
        ch = .NorthWest
    }
    
    return ch
}

let pi:Double = 3.1415927
let eQuatorialEarthRadius:Double = 6378.137
let d2r:Double = (pi / 180.0)
let r2d:Double = 180.0 / pi

func HaversineInM(lat1:Double, long1:Double, lat2:Double, long2:Double) -> Double {
    return (1000.0 * HaversineInKM(lat1, long1, lat2, long2));
}

func HaversineInKM(lat1:Double, long1:Double, lat2:Double, long2:Double) -> Double {
    let dlong:Double = (long2 - long1) * d2r;
    let dlat:Double = (lat2 - lat1) * d2r;
    let a:Double = pow(sin(dlat / 2.0), 2.0) + cos(lat1 * d2r) * cos(lat2 * d2r) * pow(sin(dlong / 2.0), 2.0);
    let c:Double = 2.0 * atan2(sqrt(a), sqrt(1.0 - a));
    let d:Double = eQuatorialEarthRadius * c;

    return d;
}

struct PointOfInterest {

    let id:Int
    let name:String
    let address:String
    let city:String
    let state:String
    let latitude:Double
    let longitude:Double
    let tags:[String]
    
    init(id:Int, name:String, address:String, city:String, state:String, lat:Double, lon:Double, tags:[String]) {
        self.name = name
        self.address = address
        self.city = city
        self.state = state
        self.latitude = lat
        self.longitude = lon
        self.tags = tags
        self.id = id
    }
    
    func distanceInMeters(fromLatitude:Double, andLongitude:Double) -> Double {
        return HaversineInM(fromLatitude, andLongitude, self.latitude, self.longitude)
    }
    
    func distanceInMiles(fromLatitude:Double, andLongitude:Double) -> Double {
        return 0.000621371 * HaversineInM(fromLatitude, andLongitude, self.latitude, self.longitude)
    }
    
    func formattedDistanceFrom(#latitude:Double, longitude:Double) -> String {
        return String(format:"%.2f mi", distanceInMiles(latitude, andLongitude:longitude))
    }
    
    func headingTo(destination:PointOfInterest) -> Double {
        let startLat = self.latitude * d2r
        let startLon = self.longitude * d2r
        let endLat = destination.latitude * d2r
        let endLon = destination.longitude * d2r
        var dLon = endLon - startLon
        let dPhi = log( tan(endLat/2.0 + pi/4.0) / tan(startLat/2.0 + pi/4.0) )
        if dLon > pi {
            if dLon > 0 {
                dLon = -(2.0 * pi - dLon)
            }
            else {
                dLon = 2.0 * pi + dLon
            }
        }
        let bearing = fmod((r2d * atan2(dLon, dPhi) + 360), 360)
        return bearing
    }
    
    func formattedAddress() -> String {
        return String(format:"%@, %@ %@", address, city, state)
    }
    
}
