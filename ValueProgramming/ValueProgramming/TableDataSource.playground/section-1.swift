import UIKit

// ----- data structs

struct Event {
    let date:String
    let name:String
    let street:String
    let city:String
    let state:String
    let rating:Int
}

struct EventsForList {
    let events:[Event]
    
    init(inEvents:[Event]) {
        self.events = inEvents
    }
    
    func listByAddingEvents(newEvents:[Event]) -> EventsForList {
        var cumulatedEvents:[Event] = events
        cumulatedEvents += newEvents
        return EventsForList(inEvents: cumulatedEvents)
    }
    
    func listWithEventsForCity(city:String) -> EventsForList {
        let filteredEvents = events.filter({$0.city == city})
        return EventsForList(inEvents: filteredEvents)
    }
    
    func numberOfEvents() -> Int {
        return events.count
    }
    
    func eventAtIndex(index:Int) -> Event {
        return events[index]
    }
    
    func listByCombiningWithList(evl:EventsForList) -> EventsForList {
        var cumulatedEvents:[Event] = events
        cumulatedEvents += evl.events
        return EventsForList(inEvents: cumulatedEvents)
    }
}

// -- data source class

class DataSource:NSObject, UITableViewDataSource {

    var events:EventsForList
    
    init(evl:EventsForList) {
        self.events = evl
    }
    
    func replaceDataForSource(evl:EventsForList) {
        self.events = evl
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.numberOfEvents()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "EventCell")
        let event:Event = events.eventAtIndex(indexPath.row)
        cell.textLabel!.text = String(format:"%@ (%d stars)", event.name, event.rating)
        cell.detailTextLabel!.text = String(format:"%@ %@, %@", event.street, event.city, event.state)
        return cell
    }
}

// -- data
let evts:[Event] = [
    Event(date: "2015-03-14", name: "Pi Fight", street: "1305 E Crenshaw St", city: "Tampa", state: "FL", rating: 1),
    Event(date: "2015-03-14", name: "Pi Fight Part Deux", street: "1300 E Main St", city: "Tampa", state: "FL", rating: 1),
    Event(date: "2015-03-15", name: "Ides of March Pub Crawl", street: "110 N Florida Ave", city: "Tampa", state: "FL", rating: 0),
    Event(date: "2015-03-14", name: "Haggis Eating Competition", street: "11 Patricia Ave", city: "Dunedin", state: "FL", rating: 1),
    Event(date: "2015-03-16", name: "Jazz Fest", street: "610 Central Ave", city: "St Petersburg", state: "FL", rating: 1),
    Event(date: "2015-03-17", name: "Shakespeare In Jail", street: "210 2nd Ave N", city: "St Petersburg", state: "FL", rating: 1),
    Event(date: "2015-03-18", name: "Nude Darts", street: "310 5th St", city: "St Petersburg", state: "FL", rating: 1),
    Event(date: "2015-03-21", name: "Pizza Cook-off", street: "11 Patricia Ave", city: "Dunedin", state: "FL", rating: 6)
]

let evl:EventsForList = EventsForList(inEvents: evts)
var ds:DataSource = DataSource(evl: evl)

// show all events in table
var tbl:UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: 300, height: 400), style: UITableViewStyle.Plain)
tbl.dataSource = ds
tbl.reloadData()

// show tampa events
let tampaEvents:EventsForList = evl.listWithEventsForCity("Tampa")
ds.replaceDataForSource(tampaEvents)
tbl.reloadData()

// show dunedin events
let dunedinEvents:EventsForList = evl.listWithEventsForCity("Dunedin")
ds.replaceDataForSource(dunedinEvents)
tbl.reloadData()

// show st pete events
let stPeteEvents:EventsForList = evl.listWithEventsForCity("St Petersburg")
ds.replaceDataForSource(stPeteEvents)
tbl.reloadData()

// show pinellas events
let pinellasEvents:EventsForList = dunedinEvents.listByCombiningWithList(stPeteEvents)
ds.replaceDataForSource(pinellasEvents)
tbl.reloadData()

