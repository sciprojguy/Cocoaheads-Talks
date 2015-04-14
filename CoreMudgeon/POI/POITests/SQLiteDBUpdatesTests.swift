//
//  SQLiteDBUpdatesTests.swift
//  POI
//
//  Created by Chris Woodard on 4/6/15.
//  Copyright (c) 2015 CW. All rights reserved.
//

import UIKit
import XCTest

class SQLiteDBUpdatesTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCreateDataManagerCheckNotNil() -> Void {
        var dm:DataManager? = DataManager(options: [:] )
        XCTAssertNotNil(dm, "BOO")
        dm?.deleteDb()
    }

    // this one will create a specific version and we will make sure it does it
    func testCreateDataManagerMigrateCheckResults() -> Void  {
        var dm:DataManager? = DataManager(options: ["CreateVersion":"0.9.0"])
        dm?.migrateDatabaseIfNecessary()
        XCTAssertTrue(dm?.cachedVersion == dm?.currentVersion, "Unable to migrate schema")
        dm?.deleteDb()
    }
    
    // these test the migration path pairs method
    func testMigrationPaths1() -> Void {
        // "0.9.0" -> "0.9.1"
        var dm:DataManager? = DataManager(options: ["CreateVersion":"0.9.0"])
        let path = dm?.versionPath(fromVersion: "0.9.0", toVersion: "0.9.1")
        XCTAssertTrue( 1 == path!.count, "should be 1 link")
        dm?.deleteDb()
    }
    
    func testMigrationPaths2() -> Void {
        // "0.9.1" -> "1.0.0"
        var dm:DataManager? = DataManager(options: ["CreateVersion":"0.9.1"])
        let path = dm?.versionPath(fromVersion: "0.9.1", toVersion: "1.0.0")
        XCTAssertTrue( 1 == path!.count, "should be 1 link")
        dm?.deleteDb()
    }
    
    func testMigrationPaths3() -> Void {
        // "0.9.0" -> "1.0.0"
        var dm:DataManager? = DataManager(options: ["CreateVersion":"0.9.0"])
        let path = dm?.versionPath(fromVersion: "0.9.0", toVersion: "1.0.0")
        XCTAssertTrue( 2 == path!.count, "should be 1 link")
        dm?.deleteDb()
    }
    
}
