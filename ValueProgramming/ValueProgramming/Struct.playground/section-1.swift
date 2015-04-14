// Playground - noun: a place where people can play

import UIKit

func jsonDecode( str:String ) -> AnyObject {
    let data:NSData = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
    let obj:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers|NSJSONReadingOptions.MutableLeaves, error: nil)!
    return obj
}

let jsonStr:String = "{ \"BBB\" : 100 }"
let dd:NSDictionary = jsonDecode(jsonStr) as NSDictionary
let jsonStr2:String = "[ 1, 2, 5, 66 ]"
let da:NSArray = jsonDecode(jsonStr2) as NSArray

struct Event {
    
    let name:String
    let date:String
    let startTime:String
    let endTime:String
    
    init(nm:String, dt:String, st:String, et:String) {
        self.name = nm
        self.date = dt
        self.startTime = st
        self.endTime = et
    }
    
    init(json:String) {
        let d:NSDictionary = jsonDecode(json) as NSDictionary
        name = d["name"] as String
        date = d["date"] as String
        startTime = d["startTime"] as String
        endTime = d["endTime"] as String
    }
    
    init(dict:NSDictionary) {
        name = dict["name"] as String
        date = dict["date"] as String
        startTime = dict["startTime"] as String
        endTime = dict["endTime"] as String
    }
    
    func json() -> String {
        var str = ""
        
        str += "{"
        str += "\"name\":\"\(name)\","
        str += "\"date\":\"\(date)\","
        str += "\"startTime\":\"\(startTime)\","
        str += "\"endTime\":\"\(endTime)\""
        str += "}"
        
        return str
    }
}

struct EventsList {

    let events:[Event]
    let name:String
    
    init(bundleName:String, inEvents:[Event]) {
        self.name = bundleName
        self.events = inEvents
    }

    func numberOfEvents() -> Int {
        return events.count
    }
    
    init(json:String) {
        let d:NSDictionary = jsonDecode(json) as NSDictionary
        self.name = d["name"] as String
        let e = d["events"] as NSArray
        var evts:[Event] = []
        for a:AnyObject in e {
            let ee:Event = Event(dict:a as NSDictionary)
            evts.append(ee)
        }
        self.events = evts
    }
    
    func json() -> String {
        var str = ""
        
        str += "{"
        str += "\"name\":\"\(name)\", \"events\":["
        for e:Event in events {
            str += e.json() + ","
        }
        
        str = str.substringToIndex(str.endIndex.predecessor())
        str += "]}"
        
        return str
    }

    func eventsListByAddingEvents(newEvents:[Event]) -> EventsList {
        var arr:[Event] = []
        arr += events
        arr += newEvents
        return EventsList(bundleName:name, inEvents: arr)
    }
}

let e1:Event = Event(nm: "Football", dt: "2015-03-14", st: "11:00 am", et: "5:00 pm")
let e2:Event = Event(nm: "Beer", dt:"2015-03-14", st: "6:00 pm", et: "11:59 pm" )

var el:EventsList = EventsList(bundleName: "Joey", inEvents: [e1])
let el2 = el.eventsListByAddingEvents([e2])
let ej:String = el2.json()

println("after adding an event:\(ej)")
let el3:EventsList = EventsList(json: ej)

