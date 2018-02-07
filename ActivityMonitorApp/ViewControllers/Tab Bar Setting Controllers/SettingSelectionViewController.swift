//
//  SettingSelectionViewController.swift
//  ActivityMonitorApp
//
//  Created by Seasoft on 9/26/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import UIKit
import Device
import Localize_Swift

class SettingSelectionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - VARIABLES
    
    var settingProperty: SettingProperty?
    var delegate: SettingChangedDelegate?
    var indexOfSelectedItem: Int?
    
    
    // MARK: - LIFE CYCLES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languageSetting()
        appearanceSetting()
    }
    
    
    
    // MARK: - HELPER FUNCTIONS
    
    // Setting language
    func languageSetting() {
        
    }
    
    
    // Setting appearance
    func appearanceSetting() {
        
        // Background, tableview footer
        self.view.backgroundColor = Common.Color.backgroundMaskColor
        tableView.tableFooterView = UIView()
        
        // Back button, done button
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneBarButtonTapped))
    }
    
    
    // Done button tapped function
    func doneBarButtonTapped() {
        
        guard let indexOfSelectedItem = indexOfSelectedItem else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        guard  let settingProperty = settingProperty else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        switch settingProperty {
        case .language:
            let language = Model.SettingOption.languages[indexOfSelectedItem]
            Localize.setCurrentLanguage(language)
            
        case .distance:
            let distance = Model.SettingOption.distance[indexOfSelectedItem]
            UserDefaults.standard.set(distance, forKey: Common.UserDefaults.distance)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Common.NotificationCenter.distanceUnitSettingChanged), object: nil)
            
        case .countdownDelay:
            let countdownDelay = Model.SettingOption.countdownDelay[indexOfSelectedItem]
            UserDefaults.standard.set(countdownDelay, forKey: Common.UserDefaults.countdownDelay)
        }
        
        delegate?.reloadSetting(settingProperty: settingProperty)
        navigationController?.popViewController(animated: true)
        
    }
    
}



// MARK: - UITABLEVIEW DATASOURCE

extension SettingSelectionViewController: UITableViewDataSource {
    
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
        
        guard  let settingProperty = settingProperty else {
            return 0
        }
        
        switch settingProperty {
        case .language:
            return Model.SettingOption.languages.count
        case .distance:
            return Model.SettingOption.distance.count
        case .countdownDelay:
            return Model.SettingOption.countdownDelay.count
        }
        
    }
    
}



// MARK: - UITABLEVIEW DELEGATE

extension SettingSelectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard  let settingProperty = settingProperty else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SettingSelectionTableViewCell
        
        cell.updateUI(by: settingProperty, at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard  let settingProperty = settingProperty else {
            return
        }
        
        switch settingProperty {
            
        case .language:
            for i in 0..<Model.SettingOption.languages.count {
                
                guard let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? SettingSelectionTableViewCell else {
                    return
                }
                
                if i == indexPath.row {
                    cell.imgCheckmark.isHidden = false
                } else {
                    cell.imgCheckmark.isHidden = true
                }
            }
            
        case .distance:
            
            for i in 0..<Model.SettingOption.distance.count {
                guard let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? SettingSelectionTableViewCell else {
                    return
                }
                if i == indexPath.row {
                    cell.imgCheckmark.isHidden = false
                } else {
                    cell.imgCheckmark.isHidden = true
                }
            }
            
            
        case .countdownDelay:
            
            for i in 0..<Model.SettingOption.countdownDelay.count {
                guard let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? SettingSelectionTableViewCell else {
                    return
                }
                if i == indexPath.row {
                    cell.imgCheckmark.isHidden = false
                } else {
                    cell.imgCheckmark.isHidden = true
                }
            }
            
        }
        
        indexOfSelectedItem = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
