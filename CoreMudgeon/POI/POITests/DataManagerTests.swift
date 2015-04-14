//
//  DataManagerTests.swift
//  POI
//
//  Created by Chris Woodard on 4/9/15.
//  Copyright (c) 2015 CW. All rights reserved.
//

import UIKit
import XCTest

class DataManagerTests: XCTestCase {

    var dm:DataManager?
    
    override func setUp() {
        super.setUp()
        dm = DataManager(options: ["CreateVersion":"1.0.0"] )
    }
    
    override func tearDown() {
        super.tearDown()
        dm?.deleteDb()
    }

    func testInsertPointsCheckResults() -> Void  {
    
        let restaurants:[[String:AnyObject]] = [
            ["name":"La Cubana", "address": "4300 W Cypress St", "city": "Tampa", "state": "FL", "latitude": 27.9519525, "longitude": -82.5162256],
            ["name":"La Leche", "address": "1408 N West Shore Blvd", "city": "Tampa", "state": "FL", "latitude": 27.955203, "longitude": -82.5251569],
            ["name":"China Vase", "address": "5501 West Spruce Street", "city": "Tampa", "state": "FL", "latitude": 27.9601558, "longitude": -82.5341249]
        ]
        
        dm?.addPointOfInterest(restaurants[0])
        dm?.addPointOfInterest(restaurants[1])
        dm?.addPointOfInterest(restaurants[2])
        
        let (status, pts:[PointOfInterest]) = dm!.pointsOfInterest(28.1, longitude: 12.2, radius: 1000.0)
        XCTAssertTrue( 3 == pts.count, "should be 3 items")
    }

    func testInsertPointsUpdateOneCheckResults() -> Void  {
    
        let restaurants:[[String:AnyObject]] = [
            ["name":"La Cubana", "address": "4300 W Cypress St", "city": "Tampa", "state": "FL", "latitude": 27.9519525, "longitude": -82.5162256],
            ["name":"La Leche", "address": "1408 N West Shore Blvd", "city": "Tampa", "state": "FL", "latitude": 27.955203, "longitude": -82.5251569],
            ["name":"China Vase", "address": "5501 West Spruce Street", "city": "Tampa", "state": "FL", "latitude": 27.9601558, "longitude": -82.5341249]
        ]
        
        dm?.addPointOfInterest(restaurants[0])
        dm?.addPointOfInterest(restaurants[1])
        dm?.addPointOfInterest(restaurants[2])
        
        let (status, pts:[PointOfInterest]) = dm!.pointsOfInterest(28.1, longitude: 12.2, radius: 1000.0)
        XCTAssertTrue( 3 == pts.count, "should be 3 items")
        
        let po1 = pts[0]
        let id1 = po1.id
        dm?.updatePointOfInterest(id1, data: ["name":"La Lechonere Grande", "address": "1408 N West Shore Blvd", "city": "Tampa", "state": "FL", "latitude": 27.955203, "longitude": -82.5251569])
        
        let (status2, pts2) = dm!.pointsOfInterest(28.1, longitude: 12.2, radius: 1000.0)
        XCTAssertTrue( 3 == pts2.count, "should be 3 items")
        let po1a = pts2[0]
        XCTAssertTrue( "La Lechonere Grande" == po1a.name, "name should have changed")
    }

    func testInsertPointsDeleteTwoCheckResults() {
    
        let restaurants:[[String:AnyObject]] = [
            ["name":"La Cubana", "address": "4300 W Cypress St", "city": "Tampa", "state": "FL", "latitude": 27.9519525, "longitude": -82.5162256],
            ["name":"La Leche", "address": "1408 N West Shore Blvd", "city": "Tampa", "state": "FL", "latitude": 27.955203, "longitude": -82.5251569],
            ["name":"China Vase", "address": "5501 West Spruce Street", "city": "Tampa", "state": "FL", "latitude": 27.9601558, "longitude": -82.5341249]
        ]
        
        dm?.addPointOfInterest(restaurants[0])
        dm?.addPointOfInterest(restaurants[1])
        dm?.addPointOfInterest(restaurants[2])
        
        let (status, pts:[PointOfInterest]) = dm!.pointsOfInterest(28.1, longitude: 12.2, radius: 1000.0)
        XCTAssertTrue( 3 == pts.count, "should be 3 items")
        
        let p1 = pts[0]
        let id1 = p1.id
        dm?.removePointOfInterest(id1)
        
        let (status2, pts2) = dm!.pointsOfInterest(28.1, longitude: 12.2, radius: 1000.0)
        XCTAssertTrue( 2 == pts2.count, "should be 2 items")
    }

}
