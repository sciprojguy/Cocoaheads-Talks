import Foundation

extension Int {
    var seconds:Int { return self }
    var minutes:Int { return self * 60 }
    var hour:Int { return self * 3600 }
    var hours:Int { return self * 3600 }
}

// - dates

struct Date {
    let year:Int
    let month:Int
    let day:Int
    
    let leapYear:Bool
    let dayOfWeek:Int
    let daysInMonth:Int
    
    let jdn:Int
    
    private func isLeapYear(yyyy:Int) -> Bool {
        var rv:Bool = false
        if yyyy % 4 == 0 {
            if yyyy % 100 != 0 {
                rv = true
            }
            else if yyyy % 400 == 0 {
                rv = true
            }
        }
        return rv
    }
    
    private func numberOfDaysInMonth(yyyy:Int, mm:Int) -> Int {
        var dim:Int
        switch(mm) {
            case 11, 4, 6, 9: dim = 30
            case 2:
                dim = 28
                if isLeapYear(yyyy) {
                    dim = 29
                }
            default: dim = 31
            
        }
        return dim
    }
    
    private func dayOfTheWeek(yy:Int, mm:Int, dd:Int) -> Int {
        var y:Int = yy
        var m:Int = mm
        var q:Int = dd
        if(m==1 || m==2) {
            m += 12
            y -= 1
        }
        
        var k:Int = y % 100
        var j:Int = y / 100;
        var h:Int = (q + (13 * (m+1)/5) + k + (k/4) + (j/4) - 2*j) % 7
        
        return h
    }
    
    private func julianDayNumber(yr:Int, mo:Int, dy:Int) -> Int {
        let a:Int = (14 - mo)/12
        let y:Int = yr + 4800 - a
        let m:Int = mo + 12*a - 3
        let jdn:Int = dy + ((153*m + 2)/5) + 365*y + (y/4) - (y/100) + (y/400) - 32045
        
        return jdn
    }
    
    init(y:Int, m:Int, d:Int) {
        self.year = y
        self.month = m
        self.day = d
        
        self.leapYear = false
        self.dayOfWeek = 0
        self.daysInMonth = 0
        self.jdn = 0
        
        self.jdn = julianDayNumber(y, mo: m, dy: d)
        self.leapYear = isLeapYear(y)
        self.daysInMonth = numberOfDaysInMonth(y, mm:month)
        self.dayOfWeek = dayOfTheWeek(y, mm: m, dd: d)
    }
    
    init(iso8601:String) {
        let parts:[String] = iso8601.componentsSeparatedByString("-")
        let y:Int = parts[0].toInt()!
        let m:Int = parts[1].toInt()!
        let d:Int = parts[2].toInt()!
        
        self.year = y
        self.month = m
        self.day = d
        
        self.leapYear = false
        self.dayOfWeek = 0
        self.daysInMonth = 0
        self.jdn = 0
        
        self.jdn = julianDayNumber(y, mo: m, dy: d)
        self.leapYear = isLeapYear(y)
        self.daysInMonth = numberOfDaysInMonth(y, mm:m)
        self.dayOfWeek = dayOfTheWeek(y, mm: m, dd: d)
    }
    
    func plusDays(nDays:Int) -> Date {
        var mm:Int = month
        var dd:Int = day
        var yyyy:Int = year
        
        // add days to this date
        dd += nDays
        while dd > numberOfDaysInMonth(yyyy,mm:mm) {
            dd -= numberOfDaysInMonth(yyyy,mm:mm)
            mm += 1
            if mm > 12 {
                yyyy += 1
                mm -= 12
            }
        }
        
        return Date(y: yyyy, m: mm, d: dd)
    }

    func minusDays(nDays:Int) -> Date {
        var mm:Int = month
        var dd:Int = day
        var yyyy:Int = year
        
        // subtract days from this date
        dd -= nDays
        while( dd < 0) {
            mm -= 1
            if mm < 1 {
                yyyy -= 1
                mm += 1
            }
            dd += numberOfDaysInMonth(yyyy, mm: mm)
        }
        
        return Date(y: yyyy, m: mm, d: dd)
    }
    
    func isBefore(d:Date) -> Bool {
        return self.jdn < d.jdn
    }
    
    func isSameAs(d:Date) -> Bool {
        return self.jdn == d.jdn
    }
    
    func isAfter(d:Date) -> Bool {
        return self.jdn > d.jdn
    }

    func daysSince(d:Date) -> Int {
        return self.jdn - d.jdn
    }

    func daysUntil(d:Date) -> Int {
        return d.jdn - self.jdn
    }
    
    func iso8601() -> String {
        return String(format: "%04d-%02d-%02d", year, month, day)
    }
    
    func nextDay() -> Date {
        return Date(y: year, m: month, d: day).plusDays(1)
    }
}

let d:Date = Date(y:2015, m:3, d:8)
let d2:Date = d.plusDays(10)
let d3:Date = d.plusDays(30)
let d4:Date = d2.minusDays(10)
let d5:Date = d3.minusDays(30)
let dISO:Date = Date(iso8601: "2015-03-14")

let isBefore:Bool = d.isBefore(d2)
let isAfter:Bool = d5.isAfter(d3)
let isAfter2:Bool = d2.isAfter(d)
let isSame:Bool = d4.isSameAs(d)

let diff1:Int = d2.daysSince(d)
let diff2:Int = d3.daysSince(d)
let diff3:Int = d3.daysSince(d2)
let until1:Int = d.daysUntil(d2)
let until2:Int = d.daysUntil(d3)

// --- time only

struct Time {

    let hours:Int
    let minutes:Int
    let seconds:Int
    let tzOffset:Int
    let secondsSoFar:Int
    
    init() {
        hours = 0
        minutes = 0
        seconds = 0
        tzOffset = 0
        self.secondsSoFar = 0
    }
    
    init(hh:Int, mm:Int, ss:Int, tz:Int) {
        self.hours = hh
        self.minutes = mm
        self.seconds = ss
        self.tzOffset = tz
        self.secondsSoFar = hh*3600 + mm*60 + ss
    }
        
    func iso8601() -> String {
        let tzHours = tzOffset / 3600
        let tzMinutes = (tzOffset - tzHours*3600) / 60
        let signChar:String = (tzOffset>0) ? "+" : "-"
        return String(format:"%02d:%02d:%02d%s%02d:%02d", hours, minutes, seconds, signChar, tzHours, tzMinutes)
    }
    
    func utcTime() -> Time {
        let tzHours = tzOffset / 3600
        let tzMinutes = (tzOffset - tzHours*3600) / 60
        let utcHours = hours + tzHours
        let utcMinutes = minutes + tzMinutes
        return Time(hh:utcHours, mm:utcMinutes, ss: seconds, tz: 0)
    }
    
    func plus(nSecs:Int) -> Time {
        var ss:Int = seconds + nSecs
        var mm:Int = minutes
        var hh:Int = hours
        
        while( ss > 59) {
            ss -= 60
            mm += 1
            if mm > 59 {
                hh += 1
                mm = 1
            }
        }
        
        return Time(hh:hh, mm:mm, ss:ss, tz:tzOffset)
    }
    
    func minus(nSecs:Int) -> Time {
        var ss:Int = seconds - nSecs
        var mm:Int = minutes
        var hh:Int = hours
        
        while( ss < 0) {
            ss += 60
            mm -= 1
            if mm < 0 {
                hh -= 1
                mm = 59
            }
        }
        
        return Time(hh:hh, mm:mm, ss:ss, tz:tzOffset)
    }

    func secondsSince(t:Time) -> Int {
        return secondsSoFar - t.secondsSoFar
    }
    

    func secondsUntil(t:Time) -> Int {
        return t.secondsSoFar - secondsSoFar
    }
    
}

let t1:Time = Time(hh: 11, mm: 30, ss: 0, tz: -3600*5)
let t2:Time = Time(hh:10, mm:20, ss:0, tz:0)
let t3:Time = t1.utcTime()
let t4:Time = t1.plus(60.seconds)
let t5:Time = t1.plus(30.seconds)
let n1:Int = t4.secondsSince(t1)
let n2:Int = t5.secondsSince(t1)
let n3:Int = t5.secondsSince(t5.minus(35.seconds))
let d6:Time = t1.plus(10.seconds).minus(15.seconds)
let d7:Time = t5.plus(1.hour)
let d8:Time = t5.plus(3.hours)
let d9:Time = t5.plus(1.hour + 10.minutes)
