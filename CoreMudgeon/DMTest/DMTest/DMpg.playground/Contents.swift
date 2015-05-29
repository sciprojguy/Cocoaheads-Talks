//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

//notes - this way we get custom DataManager/FetchedResults
// data structures done in more functional style

class DM1<T> {
    var cache:[T]
    init() {
        cache = []
    }
    init(input:[T]) {
        cache = input
    }
}

class DM2<T,G> {
    var cache1:[T]
    var cache2:[G]
    init(input:[T], sections:[G]) {  // <-- here for convenience - IRL this only takes options
        cache1 = input
        cache2 = sections
    }
}

struct T1 {
    let a:String
    let b:Int
    init(aa:String, bb:Int) {
        a = aa
        b = bb
    }
}

struct T2 {
    let kk:Float
    let mm:String
    init(k:Float, m:String) {
        kk = k
        mm = m
    }
}

let t1array:[T1] = [
    T1(aa: "A", bb: 100),
    T1(aa: "B", bb: 12),
    T1(aa: "C", bb: 66)
]

let t2array:[T2] = [
    T2(k: 100.1, m: "Clouds"),
    T2(k: 98.4, m: "Rain")
]

let dm1 = DM1<T1>(input: t1array)
let dm2 = DM1<T2>(input: t2array)

let dm3 = DM2<T1,T2>(input: t1array, sections: t2array)

