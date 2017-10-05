//
//  Extensions.swift
//  saints
//
//  Created by Alexey Smirnov on 10/1/17.
//  Copyright © 2017 Alexey Smirnov. All rights reserved.
//

import UIKit

public extension DateComponents {
    init(_ day: Int, _ month:Int, _ year: Int) {
        self.init()
        
        self.day = day
        self.month = month
        self.year = year
    }
    
    init(date: Date) {
        self.init()
        
        let calendar = Calendar.current
        let dateComponents = (calendar as NSCalendar).components([.day, .month, .year, .weekday], from: date)
        
        self.day = dateComponents.day
        self.month = dateComponents.month
        self.year = dateComponents.year
        self.weekday = dateComponents.weekday
    }
    
    func toDate() -> Date {
        let calendar = Calendar.current
        return calendar.date(from: self)!
    }
}

public enum TimeIntervalUnit {
    case seconds, minutes, hours, days, months, years
    
    func dateComponents(_ interval: Int) -> DateComponents {
        var components:DateComponents = DateComponents()
        
        switch (self) {
        case .seconds:
            components.second = interval
        case .minutes:
            components.minute = interval
        case .days:
            components.day = interval
        case .months:
            components.month = interval
        case .years:
            components.year = interval
        default:
            components.day = interval
        }
        return components
    }
}

public struct CalTimeInterval {
    var interval: Int
    var unit: TimeIntervalUnit
    
    init(interval: Int, unit: TimeIntervalUnit) {
        self.interval = interval
        self.unit = unit
    }
}

// FYI: http://stackoverflow.com/questions/24116271/whats-the-cleanest-way-of-applying-map-to-a-dictionary-in-swift

public extension Int {
    var days: CalTimeInterval {
        return CalTimeInterval(interval: self, unit: TimeIntervalUnit.days);
    }
    
    var months: CalTimeInterval {
        return CalTimeInterval(interval: self, unit: TimeIntervalUnit.months);
    }
}

public func - (left:Date, right:CalTimeInterval) -> Date {
    let calendar = Calendar.current
    let components = right.unit.dateComponents(-right.interval)
    return (calendar as NSCalendar).date(byAdding: components, to: left, options: [])!
}

public func + (left:Date, right:CalTimeInterval) -> Date {
    let calendar = Calendar.current
    let components = right.unit.dateComponents(right.interval)
    return (calendar as NSCalendar).date(byAdding: components, to: left, options: [])!
}

public extension String {
    subscript (i: Int) -> String {
        return String(Array(self.characters)[i])
    }
    
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

public func findIndex<S: Sequence>(_ sequence: S, predicate: (S.Iterator.Element) -> Bool) -> Int? {
    for (index, element) in sequence.enumerated() {
        if predicate(element) {
            return index
        }
    }
    return nil
}

public extension UIViewController {
    static func named(_ name: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: name)
    }
}

public extension UINavigationController {
    func makeTransparent() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = UIColor.clear
    }
}
