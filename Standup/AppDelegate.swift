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

    /// Application Prompt Scheduler
    let promptScheduler = PromptScheduler()
    let user = User()

    /// Initialize Application
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        loadDefaultPrefs()

        promptScheduler.scheduleStandPrompt()
    }
    
    /// Clean up application
    func applicationWillTerminate(aNotification: NSNotification) {
        promptScheduler.clearPrompts()
    }
    
    /// Load default preferences
    func loadDefaultPrefs() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.registerDefaults([
            "PROMPT_INTERVAL" : 45,
            "DND_START_HOUR"  : 17,
            "DND_END_HOUR"    : 9
        ])
    }
}