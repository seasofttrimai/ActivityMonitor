//
//  SettingsViewController.swift
//  ActivityMonitorApp
//
//  Created by Mai Nguyen Quang Tri on 9/25/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import Foundation
import UIKit
import Device
import RealmSwift
import Localize_Swift
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit
import SCLAlertView


class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - LIFE CYCLES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languageSetting()
        appearanceSetting()
    }
    
    
    
    // MARK: - HELPER FUNCTIONS
    
    // Setting language
    func languageSetting() {
        self.navigationItem.title = "settings_vc_title".localized(using: "Localizable")
    }
    
    
    // Setting appearance
    func appearanceSetting() {
        self.view.backgroundColor = Common.Color.backgroundMaskColor
        tableView.tableFooterView = UIView()
    }
    
    
    // Prepare for perform segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Go to Setting Selection View Controller
        if segue.identifier == Common.Segue.goToSettingSelectionVC {
            
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
            let settingSelectionVC = segue.destination as? SettingSelectionViewController
            
            settingSelectionVC?.delegate = self
            
            switch indexPath.row {
            case 0:
                settingSelectionVC?.settingProperty = .language
            case 1:
                settingSelectionVC?.settingProperty = .distance
            case 2:
                settingSelectionVC?.settingProperty = .countdownDelay
                
            default: break
            }
            
        }
        
        // Go to User Profile View Controller
        //        else if segue.identifier == Common.Segue.goToUserProfileVC {
        //
        //            let userProfileVC = segue.destination as? UserProfileViewController
        ////            userProfileVC?.isFilledUserProfile = true
        //
        //            let userProfile = realm.objects(UserProfile.self).first
        //            let userPF: UserProfile = UserProfile()
        //            userPF.email = userProfile?.email ?? ""
        //            userPF.weightEncode = userProfile?.weightEncode ?? "65$5$0"
        //            userPF.genderIndex = userProfile?.genderIndex ?? 0
        //            userPF.birthDay = userProfile?.birthDay ?? Date()
        //            userPF.unitIndex = userProfile?.unitIndex ?? 0
        //            userProfileVC?.userProfile = userPF
        //        }
    }
    
}



// MARK: - UITABLEVIEW DATASOURCE

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Device.size() < Size.screen4_7Inch {
            // Your device screen is smaller than 4.7 inch
            return 65
        } else {
            // Your device screen is equal or bigger than 4.7 inch
            return 70
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
}



// MARK: - UITABLEVIEW DELEGATE

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SettingsTableViewCell
        
        cell.updateUI(at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0, 1, 2:
            performSegue(withIdentifier: Common.Segue.goToSettingSelectionVC, sender: nil)
            tableView.deselectRow(at: indexPath, animated: true)
            break
            
            //        case 3:
            //            performSegue(withIdentifier: Common.Segue.goToUserProfileVC, sender: nil)
            //            tableView.deselectRow(at: indexPath, animated: true)
            //            break
            
        case 3:
            self.showLogoutPopup()
            break
            
        default:
            break
        }
        
    }
    
    
    func showLogoutPopup() {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleTop: CGFloat(38.0),
            showCloseButton: false,
            showCircularIcon: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("settings_vc_logout_title".localized(using: "Localizable")) {
            self.logOutFromCurrentUser()
        }
        alertView.addButton("cancel".localized(using: "Localizable")) {
        }
        alertView.showInfo("settings_vc_logout_title".localized(using: "Localizable"), subTitle: "settings_vc_logout_subTitle".localized(using: "Localizable"))
    }
    
    
    // Logout from current user function
    func logOutFromCurrentUser() {
        
        // Make sure network connected
        guard Reachability.isConnectedToNetwork() else {
            Helper.popupNoNetwortConnection()
            return
        }
        
        // Wait overlay with text
        self.showWaitOverlayWithText("please_wait".localized(using: "Localizable"))
        
        let firebaseAuth = Auth.auth()
        
        do {
            
            try firebaseAuth.signOut()
            
            // Logout from Google sing-in or facebook
            GIDSignIn.sharedInstance().signOut()
            FBSDKLoginManager().logOut()
            
            // Set logged in status to false
            UserDefaults.setLoggedInStatus(to: false)
            
            // Remove all user profile from database
            try! realm.write {
                let allUserProfile = realm.objects(UserProfile.self)
                realm.delete(allUserProfile)
            }
            
            // Remove waiting overlay
            self.removeAllOverlays()
            
            // Go to Login screen
            Helper.goToLoginViewController()
            
        } catch let signOutError as NSError {
            
            // Remove waiting overlay
            self.removeAllOverlays()
            print ("Error signing out: %@", signOutError)
            
        }
    }
}



// MARK: - SETTING CHANGED DELEGATE

extension SettingsViewController: SettingChangedDelegate {
    
    func reloadSetting(settingProperty: SettingProperty) {
        
        switch settingProperty {
        case .language:
            languageSetting()
            tableView.reloadData()
            
        case .distance:
            guard let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SettingsTableViewCell else {
                return
            }
            
            guard let distanceRawValue: String = UserDefaults.standard.string(forKey: Common.UserDefaults.distance) else {
                return
            }
            
            cell.lbDescription.text = distanceRawValue.localized(using: "Localizable")
            
        case .countdownDelay:
            guard let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? SettingsTableViewCell else {
                return
            }
            
            let countdownDelayRawValue: Int = UserDefaults.standard.integer(forKey: Common.UserDefaults.countdownDelay)
            
            cell.lbDescription.text = "\(countdownDelayRawValue) " + "seconds".localized(using: "Localizable")
            
        }
    }
}









