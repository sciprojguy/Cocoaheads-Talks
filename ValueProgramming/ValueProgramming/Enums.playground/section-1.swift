import Foundation

enum CalendarDay {

    case Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Unknown
    
    func dayOfWeek() -> Int {
        switch(self) {
            case .Unknown: return -1
            case .Sunday: return 0
            case .Monday: return 1
            case .Tuesday: return 2
            case .Wednesday: return 3
            case .Thursday: return 4
            case .Friday: return 5
            case .Saturday: return 6
        }
    }
    
    func weekday() -> Bool {
        switch(self) {
            case .Saturday, .Sunday: return false
            case .Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Unknown: return true
        }
    }
    
    func weekend() -> Bool {
        switch(self) {
            case .Saturday, .Sunday: return true
            case .Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Unknown: return false
        }
    }
    
    func tinyName() -> String {
        switch(self) {
            case .Sunday: return "S"
            case .Monday: return "M"
            case .Tuesday: return "T"
            case .Wednesday: return "W"
            case .Thursday: return "R"
            case .Friday: return "F"
            case .Saturday: return "Sa"
            case .Unknown: return "?"
        }
    }
    
    func shortName() -> String {
        switch(self) {
            case .Sunday: return "Sun"
            case .Monday: return "Mon"
            case .Tuesday: return "Tue"
            case .Wednesday: return "Wed"
            case .Thursday: return "Thu"
            case .Friday: return "Fri"
            case .Saturday: return "Sat"
            case .Unknown: return "Unk"
        }
    }
    
    func name() -> String {
        switch(self) {
            case .Sunday: return "Sunday"
            case .Monday: return "Monday"
            case .Tuesday: return "Tuesday"
            case .Wednesday: return "Wednesday"
            case .Thursday: return "Thursday"
            case .Friday: return "Friday"
            case .Saturday: return "Saturday"
            case .Unknown: return "Unknown"
        }
    }
    
    init(abbrev:String) {
        switch(abbrev) {
            case "S": self = .Sunday
            case "M": self = .Monday
            case "T": self = .Tuesday
            case "W": self = .Wednesday
            case "R": self = .Thursday
            case "F": self = .Friday
            case "Sa": self = .Saturday
            default: self = .Unknown
        }
    }
}

let today = CalendarDay(abbrev:"R")
let fullName = today.name()
let tomorrow:CalendarDay = .Friday
let tomorrowName = tomorrow.shortName()

