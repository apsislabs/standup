//
//  NSDateExtension.swift
//  Standup
//
//  Created by Wyatt Kirby on 3/17/16.
//  Copyright © 2016 Apsis Labs. All rights reserved.
//

import Foundation

public extension NSDate {
    func dateByAddingDays(days: Int) -> NSDate {
        let dateComp = NSDateComponents()
        dateComp.day = days
        return NSCalendar
            .currentCalendar()
            .dateByAddingComponents(dateComp, toDate: self, options: NSCalendarOptions(rawValue: 0))!
    }
    
    func dateByAddingMinutes(minutes: Int) -> NSDate {
        let dateComp = NSDateComponents()
        dateComp.minute = minutes
        return NSCalendar
            .currentCalendar()
            .dateByAddingComponents(dateComp, toDate: self, options: NSCalendarOptions(rawValue: 0))!
    }
    
    func dateAtHour(hour: NSInteger) -> NSDate {
        let components = self.components()

        components.hour = hour
        components.minute = 0
        components.second = 0
        
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
    
    // MARK: Class Functions
    
    class func tomorrow() -> NSDate {
        return NSDate().dateByAddingDays(1).dateAtHour(0)
    }

    // MARK: Intervals In Seconds
    
    class func minuteInSeconds() -> Double { return 60 }
    class func hourInSeconds() -> Double { return 3600 }
    class func dayInSeconds() -> Double { return 86400 }
    class func weekInSeconds() -> Double { return 604800 }
    class func yearInSeconds() -> Double { return 31556926 }
    
    // MARK: Component Construction
    
    private class func componentFlags() -> NSCalendarUnit { return [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.WeekOfYear, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second, NSCalendarUnit.Weekday, NSCalendarUnit.WeekdayOrdinal, NSCalendarUnit.WeekOfYear] }
    
    private class func components(fromDate fromDate: NSDate) -> NSDateComponents! {
        return NSCalendar.currentCalendar().components(NSDate.componentFlags(), fromDate: fromDate)
    }
    
    public func components() -> NSDateComponents  {
        return NSDate.components(fromDate: self)!
    }

}
