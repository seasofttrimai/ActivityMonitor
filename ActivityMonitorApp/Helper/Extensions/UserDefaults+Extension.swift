//
//  UserDefaults+Extension.swift
//  ActivityMonitorApp
//
//  Created by Seasoft on 9/26/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//


import Foundation

extension UserDefaults {
    
    // MARK: - *** First lauching flag ***
    
    // Check for is first launch - only true on first invocation after app install, false on all further invocations
    static func isFirstLaunch() -> Bool {
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: Common.UserDefaults.isLaunchedBeforeFlag)
        if (isFirstLaunch) {
            UserDefaults.standard.set(true, forKey: Common.UserDefaults.isLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
    
    
    // MARK: - *** Logged in flag ***
    
    // Get the current loggin status
    static func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: Common.UserDefaults.isLoggedInFlag)
    }
    
    // Set the loggin status
    static func setLoggedInStatus(to status: Bool) {
        UserDefaults.standard.set(status, forKey: Common.UserDefaults.isLoggedInFlag)
    }
    
}
