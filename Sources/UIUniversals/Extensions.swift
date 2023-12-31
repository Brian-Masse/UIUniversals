//
//  Extensions.swift
//  Recall
//
//  Created by Brian Masse on 7/14/23.
//

import Foundation
import SwiftUI

//MARK: Color
@available(iOS 15.0, *)
public extension Color {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {

        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0

        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            // You can handle the failure here as you want
            return (0, 0, 0, 0)
        }

        return (r, g, b, o)
    }

    var hex: String {
        String(
            format: "#%02x%02x%02x%02x",
            Int(components.red * 255),
            Int(components.green * 255),
            Int(components.blue * 255),
            Int(components.opacity * 255)
        )
    }
}

//MARK: Date
public extension Date {
    
    func getHoursFromStartOfDay() -> Double {
        let comps = Calendar.current.dateComponents([.minute, .hour], from: self)
        return Double(comps.minute ?? 0) / Constants.MinuteTime + Double(comps.hour ?? 0)
    }
    
    func getMinutesFromStartOfHour() -> Double {
        let comps = Calendar.current.dateComponents([.minute, .second], from: self)
        return Double( comps.second ?? 0 ) / 60 + Double(comps.minute ?? 0)
    }
    
    func getYearsSince( _ date: Date ) -> Double {
        self.timeIntervalSince(date) / Constants.yearTime
    }
    
    func resetToStartOfDay() -> Date {
        Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self) ?? self
    }
    
    func matches(_ secondDate: Date, to component: Calendar.Component) -> Bool {
        Calendar.current.isDate(self, equalTo: secondDate, toGranularity: component)
    }
    
    func dateBySetting(hour: Double, ignoreMinutes: Bool = false) -> Date {
        let intHour = Int(hour)
        let minutes = (hour - Double(intHour)) * Constants.MinuteTime
        let recordedMinutes = Calendar.current.dateComponents([.minute], from: self).minute ?? 0
        
        return Calendar.current.date(bySettingHour: intHour, 
                                     minute: !ignoreMinutes ? Int(minutes) : recordedMinutes,
                                     second: 0, of: self) ?? self
    }
    
    func dateBySetting(minutes: Double) -> Date {
        let hour = Calendar.current.dateComponents([.hour], from: self).hour ?? 0
        let intMinutes = Int(minutes)
        let seconds = ( minutes - Double(intMinutes) )
        
        return Calendar.current.date( bySettingHour: hour, minute: intMinutes, second: Int(seconds), of: self ) ?? self
    }
    
    func dateBySetting( dateFrom date: Date ) -> Date {
        
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: self)
        
        return Calendar.current.date(bySettingHour: components.hour!,
                                     minute: components.minute!,
                                     second: components.second!,
                                     of: date) ?? self
        
    }
    
//    this only support year, month, and day, but can easily be expanded in the future
    func prioritizeComponent( _ component: Calendar.Component ) -> Date {
        
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        
        var mutableComponents = DateComponents()
        mutableComponents.year = components.year
        
        switch component {
        case .month: mutableComponents.month = components.month
        case .day:
            mutableComponents.month = components.month
            mutableComponents.day = components.day
        default: break
        }
        
        return Calendar.current.date(from: mutableComponents) ?? self
    }
    
    func day() -> Int {
        Calendar.current.component(.day, from: self)
    }
    
    func isFirstOfMonth() -> Bool {
        let components = Calendar.current.dateComponents([.day], from: self)
        return components.day == 1
    }
    
    func isSunday() -> Bool {
        Calendar.current.component(.weekday, from: self) == 1
    }
    
    func matches(dayOfWeek day: Int) -> Bool {
        let component = Calendar.current.component(.weekday, from: self)
        return component == day
        
    }
    
    func setMonth(to month: Int) -> Date {
        var components = Calendar.current.dateComponents([.day, .month, .year], from: self)
        components.month = month
        return Calendar.current.date(from: components) ?? self
    }
    
    func setDay(to day: Int) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        components.day = day
        
        return Calendar.current.date(from: components) ?? self 
        
    }
}

//MARK: Collection
extension Collection {
    func countAll(where query: ( Self.Element ) -> Bool ) -> Int {
        self.filter(query).count
    }
}

//MARK: Float, Double, Int
public extension Float {
    func round(to digits: Int) -> Float {
        (self * pow(10, Float(digits))).rounded(.down) / ( pow(10, Float(digits)) )
    }
}

public extension Double {
    func round(to digits: Int) -> Double {
        (self * pow(10, Double(digits))).rounded(.down) / ( pow(10, Double(digits)) )
    }
}

public extension Int {
    func formatIntoPhoneNumber() -> String {
        let mask = "+X (XXX) XXX-XXXX"
        let phone = "\(self)"
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
}

//MARK: String
public extension String {
    func removeFirst( of char: Character ) -> String {
        if let index = self.firstIndex(of: char) {
            var t = self
            t.remove(at: index)
            return t
        }
        return self
    }
    
    func removeNonNumbers() -> String {
        self.filter("0123456789.".contains)
    }
}

