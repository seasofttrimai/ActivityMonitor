//
//  SettingSelectionTableViewCell.swift
//  ActivityMonitorApp
//
//  Created by Seasoft on 9/26/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import UIKit
import Localize_Swift

class SettingSelectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var imgCheckmark: UIImageView!
    
    
    // Cell data displaying
    func updateUI(by settingProperty: SettingProperty, at indexPath: IndexPath) {
        switch settingProperty {
            
        case .language: // Language option data
            let laguage: String = Model.SettingOption.languages[indexPath.row].localized(using: "Localizable")
            lbTitle.text = laguage
            
            if Localize.currentLanguage() == Model.SettingOption.languages[indexPath.row] {
                imgCheckmark.isHidden = false
            }
            
        case .distance: // Distance option data
            let distance: String = Model.SettingOption.distance[indexPath.row].localized(using: "Localizable")
            lbTitle.text = distance
            
            if UserDefaults.standard.string(forKey: Common.UserDefaults.distance) == Model.SettingOption.distance[indexPath.row] { // Ex: "kilometers" == "kilometers"
                imgCheckmark.isHidden = false
            }
            
        case .countdownDelay: // Countdown delay option data
            let countdownDelay: Int = Model.SettingOption.countdownDelay[indexPath.row]
            lbTitle.text = "\(countdownDelay) " + "seconds".localized(using: "Localizable")
            
            if UserDefaults.standard.integer(forKey: Common.UserDefaults.countdownDelay) == Model.SettingOption.countdownDelay[indexPath.row] { // Ex: "3" == "3"
                imgCheckmark.isHidden = false
            }
            
        }
        
    }
    
    
}
