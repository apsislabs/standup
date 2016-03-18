//
//  User.swift
//  Standup
//
//  Created by Wyatt Kirby on 3/17/16.
//  Copyright © 2016 Apsis Labs. All rights reserved.
//

import Cocoa

enum SittingStates : String {
    case Sitting  = "sitting"
    case Standing = "standing"
    case Waiting  = "waiting"
}

protocol HasUser {
    func getUser() -> User
}

extension HasUser {
    func getUser() -> User {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.user
    }
}

class User: NSObject {
    /// Current Sitting State
    var sittingState = SittingStates.Waiting
}
