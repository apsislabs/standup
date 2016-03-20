//
//  PreferencesWindow.swift
//  Standup
//
//  Created by Wyatt Kirby on 3/17/16.
//  Copyright © 2016 Apsis Labs. All rights reserved.
//

import Cocoa

class PreferencesWindow: NSWindowController, NSWindowDelegate {
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
        
        self.window?.makeKeyAndOrderFront(nil)
        self.window?.center()
        
        loadDefaults()
    }
    
    func windowWillClose(notification: NSNotification) {
        savePreferences()
    }
    
    /// Load Defaults into Text Fields
    func loadDefaults() {
        let promptInterval = userDefaults.integerForKey("PROMPT_INTERVAL")
        let dndStartTime = dateFromDefaults("DND_START_TIME")
        let dndEndTime = dateFromDefaults("DND_END_TIME")
        
        dndStartTimeInput.dateValue      =  dndStartTime ?? K.APP_DEFAULTS.DND_START_TIME
        dndEndTimeInput.dateValue        =  dndEndTime ?? K.APP_DEFAULTS.DND_END_TIME
        promptIntervalInput.integerValue =  promptInterval > 0 ? promptInterval : K.APP_DEFAULTS.PROMPT_INTERVAL
    }
    
    func savePreferences() {
        let promptInterval = promptIntervalInput.integerValue
        let dndStartTime = dndStartTimeInput.dateValue
        let dndEndTime = dndEndTimeInput.dateValue
        
        userDefaults.setInteger(promptInterval, forKey: "PROMPT_INTERVAL")
        userDefaults.setObject(dndStartTime, forKey: "DND_START_TIME")
        userDefaults.setObject(dndEndTime, forKey: "DND_END_TIME")
    }

    /// Initialize User Defaults
    func initUserDefaults() -> NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    /// Retrieve an optionally null date field from NSUserDefaults
    private func dateFromDefaults(key: String) -> NSDate? {
        return userDefaults.objectForKey(key) as! NSDate?
    }
}
