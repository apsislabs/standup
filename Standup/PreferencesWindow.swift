//
//  PreferencesWindow.swift
//  Standup
//
//  Created by Wyatt Kirby on 3/17/16.
//  Copyright © 2016 Apsis Labs. All rights reserved.
//

import Cocoa

class PreferencesWindow: NSWindowController {
    @IBOutlet weak var dndStartTimeInput: NSDatePicker!;
    @IBOutlet weak var dndEndTimeInput: NSDatePicker!;
    @IBOutlet weak var promptIntervalInput: NSTextField!;
    
    /// User Defaults
    lazy var userDefaults : NSUserDefaults = self.initUserDefaults()
    
    /// Override Window Nib Name
    override var windowNibName : String! {
        return "PreferencesWindow"
    }
    
    /// Setup defaults on window load
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Well this is dumb
        self.window?.level = Int(CGWindowLevelForKey(CGWindowLevelKey.FloatingWindowLevelKey))
        
        self.window?.makeKeyAndOrderFront(nil)
        self.window?.center()
        
        loadDefaults()
    }
    
    /// Load Defaults into Text Fields
    func loadDefaults() {
        let dndStartHour = userDefaults.integerForKey("DND_START_HOUR")
        let dndEndHour = userDefaults.integerForKey("DND_END_HOUR")
        let promptInterval = userDefaults.integerForKey("PROMPT_INTERVAL")
        
        dndStartTimeInput.dateValue      = NSDate().dateAtHour(dndStartHour)
        dndEndTimeInput.dateValue        = NSDate().dateAtHour(dndEndHour)
        promptIntervalInput.integerValue = promptInterval
    }
    
    func savePreferences() {
        let promptInterval = promptIntervalInput.integerValue
        let dndStartTime = dndStartTimeInput.dateValue
        let dndEndTime = dndEndTimeInput.dateValue
        
        userDefaults.setInteger(promptInterval, forKey: "PROMPT_INTERVAL")
        userDefaults.setInteger(dndStartTime.components().hour, forKey: "DND_START_HOUR")
        userDefaults.setInteger(dndEndTime.components().hour, forKey: "DND_END_HOUR")
    }

    /// Initialize User Defaults
    func initUserDefaults() -> NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    /// Retrieve an optionally null date field from NSUserDefaults
    private func dateFromDefaults(key: String) -> NSDate {
        return userDefaults.objectForKey(key) as! NSDate
    }
}

extension PreferencesWindow : NSWindowDelegate {
    func windowWillClose(notification: NSNotification) {
        savePreferences()
    }
}
