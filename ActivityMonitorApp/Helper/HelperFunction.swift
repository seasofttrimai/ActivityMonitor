//
//  HelperFunction.swift
//  ActivityMonitorApp
//
//  Created by Seasoft on 10/18/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView
import Localize_Swift

public class Helper {
    
    //MARK: - HELPER FUNCTIONS
    
    // Initial setting for first launching app
    class func initialSetting() {
        Localize.setCurrentLanguage("en")
        UserDefaults.standard.set(DistanceProperty.kilometers.rawValue, forKey: Common.UserDefaults.distance)
        UserDefaults.standard.set(CountdownDelayProperty.ten.rawValue, forKey: Common.UserDefaults.countdownDelay)
        UserDefaults.standard.synchronize()
    }
    
    
    // Go to login screen
    class func goToLoginViewController() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginViewController
    }
    
    
    // Go to user profile screen
    class func goToUserProfileViewController() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginViewController
    }
    
    
    // Go to home screen
    class func goToMainViewController() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = mainViewController
    }
    
    
    
    //MARK: - POPUP
    
    // No network connection popup showing
    class func popupNoNetwortConnection() {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleTop: CGFloat(38.0),
            showCloseButton: false,
            showCircularIcon: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("wifi".localized(using: "Localizable")) {
            UIApplication.shared.openURL(URL(string:"App-Prefs:root=WIFI")!)
        }
        alertView.addButton("cancel".localized(using: "Localizable")) {
        }
        alertView.showInfo("noNetworkTitle".localized(using: "Localizable"), subTitle: "noNetworkDescription".localized(using: "Localizable"))
    }
    
    
    // Checking date popup showing
    class func popupDateChecking() {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleTop: CGFloat(38.0),
            showCloseButton: false,
            showCircularIcon: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("OK".localized(using: "Localizable")) {
        }
        alertView.showInfo("date_time_picker_vc_alert_tilte".localized(using: "Localizable"), subTitle: "date_time_picker_vc_alert_subtitle".localized(using: "Localizable"))
    }
    
}
