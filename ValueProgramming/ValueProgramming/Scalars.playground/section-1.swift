import Foundation

enum Units {
    case Centimeters, Meters, Kilometers, Feet, Yards, Miles, Inches, Furlongs
}

extension Double {

    var cm:Double { return self/100.0 }
    var meters:Double { return self }
    var km:Double { return 1000.0 * self }
    var kilometers:Double { return 1000.0 * self }
    var feet:Double { return 3.28084 * self }
    var inches:Double { return self.feet * 12.0 }
    var yards:Double { return self.feet / 3.0 }
    var miles:Double { return self.feet / 5280.0 }
    var furlongs:Double { return self * 201.16800 }
    
    func format(type:Units) -> String {
        var str = ""
        switch(type) {
            case .Meters: str = String(format:"%.2f m", self)
            case .Kilometers: str = String(format:"%.2f km", self.kilometers)
            case .Feet: str = String(format:"%.2f ft", self.feet)
            case .Yards: str = String(format:"%.2f yd", self.yards)
            case .Miles: str = String(format:"%.2f mi", self.miles)
            case .Centimeters: str = String(format:"%.2f cm", self.cm)
            case .Furlongs: str = String(format:"%.2f furlongs", self.furlongs)
            case .Inches: str = String(format:"%.2f in", self.inches)
        }
        return str
    }
}

let x:Double = 154.5.meters
let y:Double = x.yards
let s:String = y.format(Units.Feet)
let s1:String = y.format(Units.Yards)
let s2:String = y.format(Units.Miles)
let s3:String = y.format(Units.Inches)
