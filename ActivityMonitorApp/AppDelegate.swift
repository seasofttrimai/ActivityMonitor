//
//  AppDelegate.swift
//  ActivityMonitorApp
//
//  Created by Mai Nguyen Quang Tri on 9/25/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - APP DELEGATE FUNCTION
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Navigation bar appearance
        UINavigationBar.appearance().backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        UINavigationBar.appearance().isTranslucent = true
        
        // First time launching app setting
        if UserDefaults.isFirstLaunch() {
            Helper.initialSetting()
        }
        
        // Configure firebase
        FirebaseApp.configure()
        
        // Initialize google sign-in
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        // Initialize facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Launching screen setting
        if UserDefaults.isLoggedIn() {
            Helper.goToMainViewController()
        } else {
            Helper.goToLoginViewController()
        }
        
        return true
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        // Facebook open URL
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app,
                                                                            open: url,
                                                                            sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!,
                                                                            annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        // Google open URL
        GIDSignIn.sharedInstance().handle(url,
                                          sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!,
                                          annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return handled
    }
    
    
}

