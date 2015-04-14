//
//  ListViewController.swift
//  POI
//
//  Created by Chris Woodard on 4/11/15.
//  Copyright (c) 2015 CW. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView:UITableView?
    
    var dataMgr:DataManager?
    var points:[PointOfInterest]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
//        self.dataMgr = DataManager(options: [:])
//        let (status, points) = dataMgr!.pointsOfInterest(28.1, longitude: 80.1, radius: 11.0)
        self.points = []
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return points!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        var cell:POICell? = tableView.dequeueReusableCellWithIdentifier("POICell") as? POICell
        let p:PointOfInterest = points![indexPath.row]
        cell?.setViewsFromInfo(["name":p.name, "address":p.formattedAddress(), "distance": p.formattedDistanceFrom(latitude: 28.888, longitude: 81.1)])
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowPOI", sender: indexPath)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // look up id and assign it to destination view controller
        var detailViewController = segue.destinationViewController as! POIDetailViewController
        var senderIP = sender as! NSIndexPath
        detailViewController.poi = points![senderIP.row]
    }

}
