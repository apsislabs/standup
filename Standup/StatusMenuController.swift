//
//  StatusMenuController.swift
//  Standup
//
//  Created by Wyatt Kirby on 3/16/16.
//  Copyright © 2016 Apsis Labs. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var sitItem: NSMenuItem!
    @IBOutlet weak var standItem: NSMenuItem!
    @IBOutlet weak var disableShort: NSMenuItem!
    @IBOutlet weak var disableLong: NSMenuItem!

    /// Menu Status Item
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    
    /// Application Prompt Scheduler
    let promptScheduler = PromptScheduler.sharedInstance
    
    /// Set up Status Item on `awakeFromNib`
    override func awakeFromNib() {
        statusMenu.delegate = self
        statusItem.menu = statusMenu
        
        if let button = statusItem.button {
            if let statusIcon = NSImage(named: "StatusBarButtonImage") {
                statusIcon.template = true
                button.image = statusIcon
            }
        }
    }
    
    /// Schedule Prompt
    @IBAction func sitItemClicked(sender: NSMenuItem) {
        promptScheduler.scheduleSitPrompt()
    }
    
    @IBAction func standItemClicked(sender: NSMenuItem) {
        promptScheduler.scheduleStandPrompt()
    }
    
    /// Quit Application
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    /// Update the Sit/Stand Label based on SittingStatus
    func updateSitStandItem() {
        switch promptScheduler.sittingState {
        case .Sitting:
            standItem.hidden = false
            sitItem.hidden = true
        case .Standing:
            standItem.hidden = true
            sitItem.hidden = false
        case .Waiting:
            standItem.hidden = false
            sitItem.hidden = false
        }
    }
}

extension StatusMenuController: NSMenuDelegate {
    func menuWillOpen(menu: NSMenu) {
        updateSitStandItem()
    }
}