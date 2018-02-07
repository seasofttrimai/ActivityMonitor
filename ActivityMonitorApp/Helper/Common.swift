//
//  Common.swift
//  ActivityMonitorApp
//
//  Created by Seasoft on 9/26/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import Foundation
import UIKit

public struct Common {
    
    // Constant
    public struct Constant {
        public static let aMile: Float = 1.60934
        public static let aPound: Float = 0.453592
    }
    
    
    // Segue identifier
    public struct Segue {
        public static let goToFilterVC = "goToFilterVC"
        public static let goToDateTimePickerVC = "goToDateTimePickerVC"
        public static let goToResultActivityVCFromHistoryVC = "goToResultActivityVCFromHistoryVC"
        public static let goToCalendarVC = "goToCalendarVC"
        public static let goToActivityVC = "goToActivityVC"
        public static let goToSettingSelectionVC = "goToSettingSelectionVC"
        public static let goToUserProfileVC = "goToUserProfileVC"
        public static let goToActivityViewController = "goToActivityViewController"
        public static let goToResultActivityViewController = "goToResultActivityViewController"
    }
    
    
    public struct Color {
        
        // Main View Color
        public static let mainColor = UIColor.rgba(36, green: 102, blue: 121, alpha: 1)
        public static let backgroundColor = UIColor.rgba(5, green: 66, blue: 92, alpha: 1)
        public static let backgroundMaskColor = UIColor.rgba(31, green: 35, blue: 72, alpha: 1)
        public static let gradientBackgroundColorDark = UIColor.rgba(26, green: 30, blue: 59, alpha: 1)
        public static let gradientBackgroundColorLight = UIColor.rgba(26, green: 30, blue: 59, alpha: 0.35)
        public static let cellSelectedColor = UIColor.rgba(36, green: 102, blue: 121, alpha: 0.8)
        
        // Main Text Color
        public static let titleTextColor = UIColor.white
        public static let selectedTextColor = UIColor.rgba(156, green: 211, blue: 93, alpha: 1)
        
        // Ring Color
        public static let ringStepColor = UIColor.rgba(35, green: 191, blue: 255, alpha: 1)
        public static let ringTimeColor = UIColor.rgba(156, green: 211, blue: 93, alpha: 1)
        public static let ringSpeedColor = UIColor.rgba(239, green: 69, blue: 60, alpha: 1)
        public static let ringUnitTextColor = UIColor.rgba(255, green: 255, blue: 255, alpha: 1)
        
        // Bar Color
        public static let barBackgroundColor = UIColor.rgba(5, green: 66, blue: 92, alpha: 1)
        public static let barTintColor = UIColor.white
        
        // Button Color
        public static let startButtonColor = UIColor.rgba(157, green: 206, blue: 76, alpha: 1)
        public static let pauseButtonColor = UIColor.rgba(213, green: 143, blue: 4, alpha: 1)
        public static let stopButtonColor = UIColor.rgba(230, green: 94, blue: 49, alpha: 1)
        
        // Calendar Color
        public static let calendarTextIndateMonthColor = UIColor.white
        public static let calendarTextOutdateMonthColor = UIColor.gray
        public static let calendarTextSelectedColor = UIColor.rgba(255, green: 75, blue: 113, alpha: 1)
        public static let calendarCellColor = UIColor.clear
        public static let calendarCellSelectedColor = UIColor.white
        
    }
    
    
    public struct Font {
        
        // Main Font
        public static let titleFont = UIFont(name: "HelveticaNeue", size: 20.0)!
        
        // History font
        public static let historyFontSmall = UIFont(name: "HelveticaNeue", size: 13.0)!
        public static let historyFontLarge = UIFont(name: "HelveticaNeue", size: 15.0)!
        
        // Ring Font
        public static let ringValueFontSmall = UIFont(name: "HelveticaNeue", size: 13.0)!
        public static let ringUnitFontSmall = UIFont(name: "HelveticaNeue", size: 6.0)!
        public static let ringValueFontLarge = UIFont(name: "HelveticaNeue", size: 16.0)!
        public static let ringUnitFontLarge = UIFont(name: "HelveticaNeue", size: 8.0)!
    }
    
    
    public struct UserDefaults {
        
        // Check flag
        public static let isLaunchedBeforeFlag = "kIsLaunchedBeforeFlag"
        public static let isLoggedInFlag = "kIsLoggedInFlag"
        
        // Setting Controllers
        public static let distance = "kDistance"
        public static let countdownDelay = "kCountdownDelay"
        
    }
    
    
    public struct NotificationCenter {
        public static let distanceUnitSettingChanged = "kDistanceUnitSettingChanged"
    }
    
    
}
