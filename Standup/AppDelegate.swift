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
        promptScheduler.scheduleStandPrompt()
    }
    
    /// Clean up application
    func applicationWillTerminate(aNotification: NSNotification) {
        promptScheduler.clearPrompts()
    }
    
    func sharedUser() -> User {
        return user
    }
}