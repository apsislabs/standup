//
//  AppDelegate.swift
//  Standup
//
//  Created by Wyatt Kirby on 3/15/16.
//  Copyright © 2016 Apsis Labs. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    var currentState = "Standing"

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        if let button = statusItem.button {
            if let statusIcon = NSImage(named: "StatusBarButtonImage") {
                statusIcon.template = true
                button.image = statusIcon
            }
            
            let menu = NSMenu()
            
            menu.addItem(NSMenuItem(title: "Schedule Transition", action: "showNotification:", keyEquivalent: "p"))
            menu.addItem(NSMenuItem.separatorItem())
            menu.addItem(NSMenuItem(title: "Preferences", action: "showPreferences:", keyEquivalent: ","))
            menu.addItem(NSMenuItem(title: "Quit", action: "terminate:", keyEquivalent: "q"))
            
            statusItem.menu = menu
        }
    }
    
    func showPreferences(send: AnyObject) {
        self.window!.makeKeyAndOrderFront(self)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        let notificationCenter = NSUserNotificationCenter.defaultUserNotificationCenter()
        let scheduledNotifications = notificationCenter.scheduledNotifications
        
        // Kill all Scheduled Notifications
        for notification in scheduledNotifications {
            notificationCenter.removeScheduledNotification(notification)
        }
        
        // Kill all Delivered Notifications (no trash)
        notificationCenter.removeAllDeliveredNotifications()
    }
    
    func showNotification(send: AnyObject) -> Void {
        let notification = NSUserNotification()
        let notifyDate = getNextNotificationTime()

        notification.title = "Oh boy..."
        notification.informativeText = "You've been standing for a while. Let's take it easy."
        notification.hasActionButton = true
        notification.otherButtonTitle = "Soon..."
        notification.actionButtonTitle = "Sit Down"
        notification.deliveryDate = notifyDate
        
        // Schedule Notification
        NSUserNotificationCenter.defaultUserNotificationCenter().scheduleNotification(notification)
    }
    
    func getNextNotificationTime() -> NSDate {
        let now = NSDate()
        let notifyDate = now.dateByAddingTimeInterval(60*45)
        let startTime = getEarliestNotification()
        let endTime = getLatestNotification()
        
        // Valid time, set notification
        if isNotificationTimeValid(notifyDate, startTime: startTime, endTime: endTime) {
            return notifyDate;
        }
        
        // Invalid time, notify tomorrow morning
        return startTime.dateByAddingTimeInterval(60*60*24)
    }
    
    func getEarliestNotification() -> NSDate {
        return getTodayAtHour(9)
    }
    
    func getLatestNotification() -> NSDate {
        return getTodayAtHour(17)
    }
    
    func getTodayAtHour(hour: NSInteger) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let components = calendar.components([.Month, .Day, .Year], fromDate: now)
        
        components.hour = hour
        
        return calendar.dateFromComponents(components)!
    }
    
    func isNotificationTimeValid(scheduledDate:NSDate, startTime:NSDate, endTime:NSDate) -> Bool {
        if scheduledDate.earlierDate(endTime) == scheduledDate && scheduledDate.laterDate(startTime) == scheduledDate {
            return true
        }
        
        return false
    }
}