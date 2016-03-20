//
//  NSDateExtension.swift
//  Standup
//
//  Created by Wyatt Kirby on 3/17/16.
//  Copyright © 2016 Apsis Labs. All rights reserved.
//

import Foundation

public extension NSDate {
    /// Returns a new `NSDate` by adding days
    func dateByAddingDays(days: Int) -> NSDate {
        let dateComp = NSDateComponents()
        dateComp.day = days
        return NSCalendar
            .currentCalendar()
            .dateByAddingComponents(dateComp, toDate: self, options: NSCalendarOptions(rawValue: 0))!
    }
    
    /// Returns a new `NSDate` by adding minutes
    func dateByAddingMinutes(minutes: Int) -> NSDate {
        let dateComp = NSDateComponents()
        dateComp.minute = minutes
        return NSCalendar
            .currentCalendar()
            .dateByAddingComponents(dateComp, toDate: self, options: NSCalendarOptions(rawValue: 0))!
    }
    
    /// Returns a new `NSDate` at the given hour
    func dateAtHour(hour: NSInteger) -> NSDate {
        let components = self.components()

        components.hour = hour
        components.minute = 0
        components.second = 0
        
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
    
    /// Determines whether the date object falls between two other date objects.
    func isBetween(startDate: NSDate, endDate: NSDate) -> Bool {
        var between = false
        
        // Reassign variables to be mutable
        var currentTime = self
        var endTime     = endDate
        var startTime   = startDate
        
        // Increment current time if it's before the end date
        if currentTime.earlierDate(endTime) == currentTime {
            currentTime = currentTime.dateByAddingDays(1)
        }
        
        // Increment the start time if it's before the end date
        if startTime.earlierDate(endTime) == startTime {
            startTime = startTime.dateByAddingDays(1)
        }
        
        // Is current time after the startTime?
        if currentTime.laterDate(startTime) == currentTime {
            
            if currentTime.laterDate(endTime) == currentTime {
                endTime = endTime.dateByAddingDays(1)
            }
            
            // And also before the end time?
            if currentTime.laterDate(endTime) == endTime {
                between = true
            }
        }
        
        return between
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
