//
//  UserProfileViewController.swift
//  ActivityMonitorApp
//
//  Created by Mai Nguyen Quang Tri on 10/17/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Localize_Swift


class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var titleInfoLabel: UILabel!
    @IBOutlet weak var skipView: UIView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderSelectorLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightSelectorLabel: UILabel!
    @IBOutlet weak var birthDayLabel: UILabel!
    @IBOutlet weak var birthDaySelectorLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceSelectorLabel: UILabel!    
    @IBOutlet weak var saveButton: UIButton!
    
    
    // MARK: - VARIABLES
    
    lazy var datePickerMenu: DatePickerMenu = {
        let menu = DatePickerMenu()
        menu.delegate = self
        return menu
    }()
    
    lazy var weightPickerMenu: WeightPickerMenu = {
        let menu = WeightPickerMenu()
        menu.delegate = self
        return menu
    }()
    
    lazy var genderPickerMenu: GenderPickerMenu = {
        let menu = GenderPickerMenu()
        menu.delegate = self
        return menu
    }()
    
    lazy var unitPickerMenu: UnitDistancePickerMenu = {
        let menu = UnitDistancePickerMenu()
        menu.delegate = self
        return menu
    }()
    
    var userProfile: UserProfile = UserProfile()
    
    
    
    // MARK: - LIFE CYCLES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initProperties()
        reloadLaguage()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadLaguage), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    
    
    // MARK: - HELPER FUNCTIONS
    
    func initProperties(){
        
        self.gradientView.layoutIfNeeded()
        let colorTop =  UIColor.rgba(26, green: 30, blue: 59, alpha: 0.33).cgColor//rgba(red: 26, green: 30, blue: 59, alpha: 1).cgColor
        let colorBottom = UIColor.rgba(26, green: 30, blue: 59, alpha: 1).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.gradientView.frame.width, height: self.gradientView.frame.height)
        self.gradientView.layer.addSublayer(gradientLayer)
    }
    
    func reloadLaguage() {
        languageSetting()
    }
    
    func languageSetting(){
        self.titleInfoLabel.text = "user_profile_my_fitness_info".localized(using: "Localizable")
        self.noteLabel.text = "user_profile_provide_your_info___".localized(using: "Localizable")
        self.genderLabel.text = "user_profile_gender".localized(using: "Localizable")
        self.weightLabel.text = "user_profile_weight".localized(using: "Localizable")
        self.birthDayLabel.text = "user_profile_birth_day".localized(using: "Localizable")
        self.distanceLabel.text = "user_profile_unit_distance".localized(using: "Localizable")
        
        self.genderSelectorLabel.text = Model.UserProfileOption.genderArray[self.userProfile.genderIndex].localized(using: "Localizable")
        self.weightSelectorLabel.text = getWeightString(by: self.userProfile.weightEncode)
        self.birthDaySelectorLabel.text = self.userProfile.birthDay.localizedDate()
        self.distanceSelectorLabel.text = Model.UserProfileOption.unitArray[self.userProfile.unitIndex]
        
        //            self.genderSelectorLabel.text = "user_profile_none".localized(using: "Localizable")
        //            self.weightSelectorLabel.text = "user_profile_none".localized(using: "Localizable")
        //            self.birthDaySelectorLabel.text = "user_profile_none".localized(using: "Localizable")
        //            self.distanceSelectorLabel.text = "user_profile_none".localized(using: "Localizable")
        
        saveButton.setTitle("user_profile_save_info".localized(using: "Localizable"), for: .normal)
        skipButton.setTitle("user_profile_skip".localized(using: "Localizable"), for: .normal)
        
    }
    
    
    func getWeightString(by stringCode: String) -> String {
        let weightArray = stringCode.components(separatedBy: "$")
        guard weightArray.count == 3 else {
            return "user_profile_none".localized(using: "Localizable")
        }
        guard let unit = Int(weightArray[2]) else {
            return "user_profile_none".localized(using: "Localizable")
        }
        return "\(weightArray[0]).\(weightArray[1]) \(unit == 0 ? "kg" : "lb")"
    }
    
    
    
    // MARK: - IB ACTIONS
    
    @IBAction func genderButtonPressed(_ sender: Any) {
        genderPickerMenu.currentGender = self.userProfile.genderIndex
        genderPickerMenu.showGenderMenu()
    }
    @IBAction func weightButtonPressed(_ sender: Any) {
        weightPickerMenu.currentWeight = self.userProfile.weightEncode
        weightPickerMenu.showWeightMenu()
    }
    @IBAction func distanceButtonPressed(_ sender: Any) {
        unitPickerMenu.currentUnit = self.userProfile.unitIndex
        unitPickerMenu.showUnitMenu()
    }
    @IBAction func birthDayButtonPressed(_ sender: Any) {
        datePickerMenu.currentDate = self.userProfile.birthDay
        datePickerMenu.showDateMenu()
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if self.genderSelectorLabel.text == "user_profile_none".localized(using: "Localizable") {
            print("please select your gender")
            return
        }
        if self.weightSelectorLabel.text == "user_profile_none".localized(using: "Localizable"){
            print("please select your weight")
            return
        }
        
        if self.birthDaySelectorLabel.text == "user_profile_none".localized(using: "Localizable"){
            print("please select your birth day")
            return
        }
        if self.distanceSelectorLabel.text == "user_profile_none".localized(using: "Localizable"){
            print("please select your unit distance")
            return
        }
        
        print("start to save user infomation")
        
        try! realm.write {
            realm.add(userProfile)
        }
        
        //        try! realm.write {
        //            realm.add(userProfile, update: true)
        //        }
        
        let allUser = realm.objects(UserProfile.self)
        print("allUser: \(allUser.debugDescription)")
        
        Helper.goToMainViewController()
        
    }
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        try! realm.write {
            realm.add(UserProfile())
        }
        let allUser = realm.objects(UserProfile.self)
        print("allUserSkipped: \(allUser.debugDescription)")
        Helper.goToMainViewController()
    }
}



// MARK: - PICKER EXTENTIONS

extension UserProfileViewController: DatePickerMenuDelegate{
    func datePickerDidSelect(date: Date) {
        birthDaySelectorLabel.text = date.localizedDate()
        self.userProfile.birthDay = date
        print("date = \(date)")
    }
}

extension UserProfileViewController: WeightPickerMenuDelegate{
    func weightPickerDidSelect(weight: String, weightEncode: String) {
        weightSelectorLabel.text = weight
        self.userProfile.weightEncode = weightEncode
    }
}

extension UserProfileViewController: GenderPickerMenuDelegate{
    func genderPickerDidSelect(gender: String, genderIndex: Int) {
        genderSelectorLabel.text = gender
        self.userProfile.genderIndex = genderIndex
    }
}

extension UserProfileViewController: UnitDistancePickerMenuDelegate{
    func unitDistancePickerDidSelect(unit: String, unitIndex: Int) {
        distanceSelectorLabel.text = unit
        self.userProfile.unitIndex = unitIndex
    }
}

