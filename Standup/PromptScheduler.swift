//
//  PromptScheduler.swift
//  Standup
//
//  Created by Wyatt Kirby on 3/16/16.
//  Copyright © 2016 Apsis Labs. All rights reserved.
//

import Cocoa

protocol PromptSchedulerDelegate {
    func promptDidSchedule(notification: NSUserNotification)
    func promptDidActivate(notification: NSUserNotification)
}

class PromptScheduler: NSObject, HasUser {
    var delegate: PromptSchedulerDelegate?
    
    /// Quick access to the default notification center
    let notificationCenter = NSUserNotificationCenter.defaultUserNotificationCenter()
    
    /// Initialize User
    lazy var user : User = self.getUser()
    
    /**
     Schedule the next prompt.
     
     - Paramter isStanding: Whether the user is currently standing
     - Returns: Void
     */
    func schedulePrompt(isStanding: Bool = false) {
        let notification = formatNotification(isStanding)
        
        clearPrompts()
        
        notification.deliveryDate = nextDeliveryDate()
        notificationCenter.delegate = self
        notificationCenter.scheduleNotification(notification)
        
        delegate?.promptDidSchedule(notification)
    }
    
    func scheduleStandPrompt() {
        user.sittingState = .Sitting
        schedulePrompt(false)
    }
    
    func scheduleSitPrompt() {
        user.sittingState = .Standing
        schedulePrompt(true)
    }
    
    /// Clear all scheduled notifications
    func clearPrompts() {
        let scheduledNotifications = notificationCenter.scheduledNotifications
        
        // Kill all Scheduled Notifications
        for notification in scheduledNotifications {
            notificationCenter.removeScheduledNotification(notification)
        }
        
        // Kill all Delivered Notifications (no trash)
        notificationCenter.removeAllDeliveredNotifications()
    }

    /**
     Returns a formatted notification to prompt the user.
     
     - Parameter isStanding: Whether the user is currently standing
     - Returns: A formatted `NSUserNotification`
    */
    func formatNotification(isStanding: Bool) -> NSUserNotification {
        let notification = NSUserNotification()
        
        // Conditional Notification Content
        if ( isStanding ) {
            notification.title = "Oh boy..."
            notification.informativeText = "You've been standing for a while. Let's take it easy."
            notification.actionButtonTitle = "Sit Down"
            notification.identifier = SittingStates.Standing.rawValue
        } else {
            notification.title = "Let's go!"
            notification.informativeText = "You've been sitting for a while. Up and at 'em!"
            notification.actionButtonTitle = "Stand Up"
            notification.identifier = SittingStates.Standing.rawValue
        }
        
        // Defaults
        return notification
    }
    
    /**
     Returns the next valid delivery date. Determination of that date
     follows a simple logic tree:
     
        * Determine the next notification by interval
        * If that interval falls in the do-not disturb hours
            schedule for the beginning of the next available
            period.
        *
     
     - Returns: NSDate for next prompt.
    */
    func nextDeliveryDate() -> NSDate {
        let now = NSDate()
        let interval = Double(10)
        
        return now.dateByAddingTimeInterval(interval)
    }
}

extension PromptScheduler: NSUserNotificationCenterDelegate {
    /// Override notification presentation
    func userNotificationCenter(center: NSUserNotificationCenter,
        shouldPresentNotification notification: NSUserNotification) -> Bool {
        return true
    }
    
    func userNotificationCenter(center: NSUserNotificationCenter,
        didDeliverNotification notification: NSUserNotification) {
            user.sittingState = .Waiting
    }
    
    /// Handle Notification Updates
    func userNotificationCenter(center: NSUserNotificationCenter,
        didActivateNotification notification: NSUserNotification) {
            
            // Determine what kind of notification we just activated
            switch (notification.identifier) {
                case SittingStates.Standing.rawValue?:
                    scheduleSitPrompt()
                case SittingStates.Sitting.rawValue?:
                    scheduleStandPrompt()
                default:
                    break
            }
            
            delegate?.promptDidActivate(notification)
    }
}