//
//  DataManager.swift
//  POI
//
//  Created by Chris Woodard on 4/6/15.
//  Copyright (c) 2015 CW. All rights reserved.
//

/***
    DataManager sits on top of the SQLiteDB class, which talks directly to the SQLite library so we don't have to.
 ***/

import Foundation

class DataManager: NSObject {

    enum Result {
        case Succeeded, Failed
    }
   
   // instance of SQLiteDB to talk to the SQLite engine
    var db:SQLiteDB?
    
    // current version
    let currentVersion:String = "1.0.0"
    var cachedVersion:String = ""
    
    // version history
    let versions:[String] = [ "0.9.0", "0.9.1", "1.0.0" ]
    var versionIndexes:[String:Int] = [:]
    
    // name of database
    let dbName:String = "POI.db"

    // singleton/initializer methods
    struct Static {
        static var instance:DataManager? = nil
        static var token:dispatch_once_t = 0
    }
   
	class func sharedInstance(options:[String:Any]) -> DataManager! {
		dispatch_once(&Static.token) {
			Static.instance = self(options:options)
		}
		return Static.instance!
	}

    required init(options:[String:Any]) {
		assert(Static.instance == nil, "Singleton already initialized!")
        super.init()
        let path:String = pathToCacheDb()
        let fm = NSFileManager.defaultManager()
        
        let numVersions:Int = versions.count
        var i:Int = 0
        while i < numVersions {
            let str:String = versions[i]
            versionIndexes[str] = i++
        }
        
        //TODO: loop thru versions and build out versionIndexes[vs] = vi
        
        if !fm.fileExistsAtPath(path) {
            var version = currentVersion
            //NOTE: this is to facilitate testing
            if let createVersion = options["CreateVersion"] as? String {
                version = createVersion
            }
            createDbIfNecessary(path, version: version)
            
            //NOTE: this is dummy data meant to illustrate the data management capabilities of rolling your own
            let restaurants:[[String:AnyObject]] = [
                ["name":"La Cubana", "address": "4300 W Cypress St", "city": "Tampa", "state": "FL", "latitude": 27.9519525, "longitude": -82.5162256],
                ["name":"La Leche", "address": "1408 N West Shore Blvd", "city": "Tampa", "state": "FL", "latitude": 27.955203, "longitude": -82.5251569],
                ["name":"China Vase", "address": "5501 West Spruce Street", "city": "Tampa", "state": "FL", "latitude": 27.9601558, "longitude": -82.5341249]
            ]
            
            self.addPointOfInterest(restaurants[0])
            self.addPointOfInterest(restaurants[1])
            self.addPointOfInterest(restaurants[2])
        }
        else {
            db = SQLiteDB(path: path, options: options)
//            migrateDatabaseIfNecessary()
        }
    }
    
    //MARK: - db path and migration methods
    func pathToCacheDb() -> String {
		let fm = NSFileManager.defaultManager()
		var cacheDir = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0] as! String
		let path = cacheDir.stringByAppendingPathComponent(dbName)
        return path
    }
    
    func versionOfCachedDb() -> String {
        var version = "0.0.0"
        if let rows:[SQLRow]? = db?.query("SELECT version FROM Version", parameters: nil) {
            let row:SQLRow = rows![0]
            version = row["version"]!.asString()
        }
        return version
    }
    
    func sqlFrom(path:String) -> [String] {
        var sqlLines:[String] = []
		let fm = NSFileManager.defaultManager()
        if fm.fileExistsAtPath(path) {
            // need to load SQL into array from file
            let sqlStr:String = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)!
            let lines:[String] = sqlStr.componentsSeparatedByString(";")
            for line:String in lines {
                if line.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 2 {
                    if !(line.subStringTo(2) == "--") {
                        sqlLines.append(line.stringByReplacingOccurrencesOfString("\n", withString: ""))
                    }
                }
            }
        }
        return sqlLines
    }
    
    func sqlToCreate(version:String) -> [String] {
        let sqlCreateName = String(format:"create_%@", version)
        let bundle = NSBundle(forClass:object_getClass(self))
        let sqlCreatePath = bundle.pathForResource(sqlCreateName, ofType: "sql")!
        return sqlFrom(sqlCreatePath)
    }

    func sqlToMigrate(fromVersion:String, toVersion:String) -> [String] {
        let sqlMigrateName = String(format:"migrate_%@_to_%@", fromVersion, toVersion)
        let bundle = NSBundle(forClass:object_getClass(self))
        let sqlMigratePath = bundle.pathForResource(sqlMigrateName, ofType: "sql")!
        return sqlFrom(sqlMigratePath)
    }
    
    //TODO: make this one return an array of (String, String) instead
    func versionPath(#fromVersion:String, toVersion:String) -> [(String, String)] {
        var versionsInPath:[(String, String)] = []
        let iStart:Int? = versionIndexes[fromVersion]
        let iStop:Int? = versionIndexes[toVersion]!-1
        for var i:Int = iStart!; i<=iStop!; i++ {
            let versionPair = (self.versions[i], self.versions[i+1])
            versionsInPath.append(versionPair)
        }
        return versionsInPath
    }
    
    func createDbIfNecessary(path:String, version:String) {
        db = SQLiteDB(path: path, options: [:])
        var lines:[String] = sqlToCreate(version)
        for sqlStatement in lines {
//            println("line: \(sqlStatement)")
            let e = db?.execute(sqlStatement, parameters: nil)
        }
    }
    
    func migrateDatabaseIfNecessary() -> Int {
        let cachedVersion:String = self.versionOfCachedDb()
        var err:Bool = false
        if cachedVersion != currentVersion {
            
            // loop through version history from cached to current
            // 1. find index of cached version in version history
            // 2. loop thru and go pairwise to generate migration script names
            let versionPath = self.versionPath(fromVersion:cachedVersion, toVersion:currentVersion)
            for tuple in versionPath {
                let fromVersion = tuple.0
                let toVersion = tuple.1
                let sqlStatements = self.sqlToMigrate(fromVersion, toVersion: toVersion)
                db?.execute("BEGIN")
                for sqlStatement in sqlStatements {
                    let e = db?.execute(sqlStatement, parameters: nil)
                    if 0 == e {
                        err = true
                        break
                    }
                }
                if false == err {
                    db?.execute("COMMIT")
                    NSLog("COMMIT")
                }
                else {
                    db?.execute("ROLLBACK")
                    NSLog("ROLLBACK")
                }
                if err {
                    break
                }
            }
        }
        self.cachedVersion = versionOfCachedDb()
        return 0
    }
    
    func deleteDb() {
		let fm = NSFileManager.defaultManager()
        let dbPath:String = self.pathToCacheDb()
        fm.removeItemAtPath(dbPath, error: nil)
    }
    
    //MARK: - public data methods
    func addPointOfInterest(data:[String:AnyObject]) -> DataManager.Result {
    
        let name: AnyObject = data["name"]!
        let address: AnyObject = data["address"]!
        let city: AnyObject = data["city"]!
        let state: AnyObject = data["state"]!
        let latitude: AnyObject = data["latitude"]!
        let longitude: AnyObject = data["longitude"]!
        
        var parms:[AnyObject]? = [ name, address, city, state, latitude, longitude ]
        
        let e = db?.execute("INSERT INTO PointsOfInterest (name,address,city,state,latitude,longitude) VALUES(?, ?, ?, ?, ?, ?)", parameters: parms)
        
        return e==1 ? .Succeeded : .Failed
    }
    
    func pointsOfInterest(latitude:Double, longitude:Double, radius:Double) -> (DataManager.Result, [PointOfInterest]) {
    
        var points:[PointOfInterest] = []
        var result:DataManager.Result
        
        if let rows:[SQLRow]? = db?.query("SELECT * FROM PointsOfInterest", parameters: nil) {
            result = .Succeeded
            points = []
            for row:SQLRow in rows! {
                let id:Int = row["id"]!.asInt()
                let name:String = row["name"]!.asString()
                let address:String = row["address"]!.asString()
                let city:String = row["city"]!.asString()
                let state:String = row["state"]!.asString()
                let latitude:Double = row["latitude"]!.asDouble()
                let longitude:Double = row["longitude"]!.asDouble()
                var p:PointOfInterest = PointOfInterest(id: id, name: name, address:address, city:city, state:state, lat: latitude, lon: longitude, tags: [])
                points.append(p)
            }
        }
        else {
            result = .Failed
        }
        
        return (result, points)
    }
    
    func updatePointOfInterest(id:Int, data:[String:AnyObject]) -> DataManager.Result {
    
        let name: AnyObject = data["name"]!
        let address: AnyObject = data["address"]!
        let city: AnyObject = data["city"]!
        let state: AnyObject = data["state"]!
        let latitude: AnyObject = data["latitude"]!
        let longitude: AnyObject = data["longitude"]!
        
        var parms:[AnyObject]? = [ name, address, city, state, latitude, longitude, id ]
        
        let e = db?.execute("UPDATE PointsOfInterest SET name = ?, address = ?, city = ?, state = ?, latitude = ?, longitude = ? WHERE id=?", parameters: parms)
        
        return e==1 ? .Succeeded : .Failed
    }
    
    func removePointOfInterest(id:Int) -> DataManager.Result {
        let e = db?.execute("DELETE FROM PointsOfInterest WHERE id=?", parameters: [id])
        return e==1 ? .Succeeded : .Failed
    }
}
