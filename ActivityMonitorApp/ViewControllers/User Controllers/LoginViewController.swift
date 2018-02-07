//
//  LoginViewController.swift
//  ActivityMonitorApp
//
//  Created by Seasoft on 10/17/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import SwiftOverlays
import Localize_Swift

class LoginViewController: UIViewController {
    
    // MARK: - VARIABLES
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var imgBackground: UIImageView!
    
    @IBOutlet weak var viewLanguage: UIView!
    @IBOutlet weak var btEnglish: UIButton!
    @IBOutlet weak var btVietnamese: UIButton!
    
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var lbGoogle: UILabel!
    
    @IBOutlet weak var facebookView: UIView!
    @IBOutlet weak var lbFacebook: UILabel!
    
    
    // MARK: - LIFE CYCLES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languageSetting()
        appearanceSetting()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    
    // MARK: - HELPER FUNCTIONS
    
    // Setting language
    func languageSetting() {
        
        // Title and login button text
        lbTitle.text = "login_vc_title".localized(using: "Localizable")
        lbGoogle.text = "login_vc_google".localized(using: "Localizable")
        lbFacebook.text = "login_vc_facebook".localized(using: "Localizable")
        
        // Language button text and background
        switch Localize.currentLanguage() {
        case "en":
            btEnglish.setTitleColor(UIColor.white, for: .normal)
            btVietnamese.setTitleColor(Common.Color.backgroundColor, for: .normal)
            self.viewLanguage.addSelectedBackground(on: .leftSide)
            
        case "vi":
            btEnglish.setTitleColor(Common.Color.backgroundColor, for: .normal)
            btVietnamese.setTitleColor(UIColor.white, for: .normal)
            self.viewLanguage.addSelectedBackground(on: .rightSide)
            
        default:
            btEnglish.setTitleColor(UIColor.white, for: .normal)
            btVietnamese.setTitleColor(Common.Color.backgroundColor, for: .normal)
            self.viewLanguage.addSelectedBackground(on: .leftSide)
        }
        
    }
    
    
    // Setting appearance
    func appearanceSetting() {
        
        // Gradient for background image
        self.imgBackground.gradientBackground(from: Common.Color.gradientBackgroundColorDark, to: Common.Color.gradientBackgroundColorLight, direction: .bottomToTop)
        
        //  Changing language view
        self.viewLanguage.layer.borderWidth = 1
        self.viewLanguage.layer.borderColor = UIColor.white.cgColor
        self.viewLanguage.layer.cornerRadius = 4
        self.viewLanguage.layer.masksToBounds = true
        
        // Google sing-in view
        self.googleView.layer.borderWidth = 2
        self.googleView.layer.borderColor = UIColor.white.cgColor
        self.googleView.layer.cornerRadius = 8
        self.googleView.layer.masksToBounds = true
        
        // Facebook login view
        self.facebookView.layer.borderWidth = 2
        self.facebookView.layer.borderColor = UIColor.white.cgColor
        self.facebookView.layer.cornerRadius = 8
        self.facebookView.layer.masksToBounds = true
        
        // Tap gesture for google sign-in view
        let googleTap = UITapGestureRecognizer(target: self, action: #selector(self.googleButtonTapped))
        googleTap.cancelsTouchesInView = false
        self.googleView.addGestureRecognizer(googleTap)
        
        // Tap gesture for facebook login view
        let facebookTap = UITapGestureRecognizer(target: self, action: #selector(self.facebookButtonTapped))
        facebookTap.cancelsTouchesInView = false
        self.facebookView.addGestureRecognizer(facebookTap)
        
    }
    
    
    // MARK: - IB ACTIONS
    
    // English language button action
    @IBAction func btEnglishTapped(_ sender: Any) {
        Localize.setCurrentLanguage("en")
        languageSetting()
    }
    
    // Vietnamese language button action
    @IBAction func btVietnameseTapped(_ sender: Any) {
        Localize.setCurrentLanguage("vi")
        languageSetting()
    }
    
    
    // Facebook login button action
    func facebookButtonTapped() {
        
        // Make sure network connected
        guard Reachability.isConnectedToNetwork() else {
            Helper.popupNoNetwortConnection()
            return
        }
        
        // Wait overlay with text
        self.showWaitOverlayWithText("please_wait".localized(using: "Localizable"))
        
        // Facebook login
        facebookSignIn()
    }
    
    
    // Google sign-in button action
    func googleButtonTapped() {
        
        // Make sure network connected
        guard Reachability.isConnectedToNetwork() else {
            Helper.popupNoNetwortConnection()
            return
        }
        
        // Wait overlay with text
        self.showWaitOverlayWithText("please_wait".localized(using: "Localizable"))
        
        // Google login
        GIDSignIn.sharedInstance().signIn()
    }
    
    
}



// MARK: - GOOGLE LOGIN DELEGATE

extension LoginViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    
    // Delegate: call this function after user signed-in  Google account
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        // Checking error && remove waiting overlay if failed
        if let err = error {
            self.removeAllOverlays()
            print("Failed to log into Google: ", err)
            return
        }
        
        // Sign-in to Firebase after successfully sing-in to Google
        print("Successfully logged into Google", user)
        
        guard let authentication = user.authentication else {
            self.removeAllOverlays()
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            
            if let err = error {
                self.removeAllOverlays()
                print("Failed to create a Firebase User with Google account: ", err)
                return
            }
            
            guard let uid = user?.uid else {
                self.removeAllOverlays()
                return
            }
            
            // Go to home screen after successfully signed-in Firebase
            print("Successfully logged into Firebase with Google", uid)
            UserDefaults.setLoggedInStatus(to: true)
            self.removeAllOverlays()
            Helper.goToUserProfileViewController()
        })
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
}



// MARK: - FACEBOOK LOGIN DELEGATE

extension LoginViewController: FBSDKLoginButtonDelegate {
    
    // Facebook login function
    func facebookSignIn() {
        
        // Login to facebook and get "email", "public_profile" after login
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
            
            // Checking error && remove waiting overlay if failed
            if err != nil {
                self.removeAllOverlays()
                print("Custom FB Login failed:", err ?? "nil")
                return
            }
            
            // Sign-in to Firebase after successfully logged-in to Facebook
            let token = FBSDKAccessToken.current()
            guard let tokenString = token?.tokenString else {
                self.removeAllOverlays()
                return
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: tokenString)
            
            Auth.auth().signIn(with: credential) { (user, error) in
                
                if error != nil {
                    self.removeAllOverlays()
                    print("Something went wrong with the facebook user:", error ?? "nil")
                    return
                }
                
                // Go to home screen after successfully signed-in Firebase
                print("Successfully login FB via Firebase: ", user ?? "nil")
                UserDefaults.setLoggedInStatus(to: true)
                self.removeAllOverlays()
                Helper.goToUserProfileViewController()
            }
            
            
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
                
                if err != nil {
                    print("Failed to start graph request:", err ?? "nil")
                    return
                }
                print(result.debugDescription)
            }
            
        }
        
    }
    
    
    // Delegate: call this function after user logged in from facebook account
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        print("loginButton FBSDKLoginManagerLoginResult")
        if error != nil {
            print(error)
            return
        }
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request:", err ?? "nil")
                return
            }
            
            print(result.debugDescription)
        }
        
    }
    
    
    // Delegate: call this function after user logged out from facebook account
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    
    //    func checkFacebookUserInfo() {
    //        let token = FBSDKAccessToken.current()
    //        guard let tokenString = token?.tokenString else {  return }
    //        let credential = FacebookAuthProvider.credential(withAccessToken: tokenString)
    //        Auth.auth().signIn(with: credential) { (user, error) in
    //            if let error = error {
    //                // ...
    //                return
    //            }
    //            // User is signed in
    //            // ...
    //            print("User FB: \(user.debugDescription)")
    //        }
    //    }
    
    
}


















