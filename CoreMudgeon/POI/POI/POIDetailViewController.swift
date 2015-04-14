//
//  POIDetailViewController.swift
//  POI
//
//  Created by james c Woodard on 4/11/15.
//  Copyright (c) 2015 CW. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class POIDetailViewController: UIViewController, MKMapViewDelegate {

    var poi:PointOfInterest?
    
    @IBOutlet var mapView:MKMapView?
    
    @IBOutlet weak var poiNameLabel: UILabel!
    @IBOutlet weak var poiAddressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // center the map around the poi location
        let mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: poi!.latitude, longitude: poi!.longitude), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        
        mapView?.setRegion(mapRegion, animated: false)
        mapView?.addAnnotation(MapPin(idNumber: poi!.id, lat: poi!.latitude, lon: poi!.longitude, name: poi!.name, address: poi!.formattedAddress()))
        
        // assign the name and address labels from it
        poiNameLabel?.text = poi!.name
        poiAddressLabel?.text = poi!.formattedAddress()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
