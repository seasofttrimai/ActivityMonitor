//
//  SettingsTableViewCell.swift
//  ActivityMonitorApp
//
//  Created by Seasoft on 9/26/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import UIKit
import Localize_Swift

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var imgAccessory: UIImageView!
    
    // Initialization code
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
    }
    
    
    // Cell data displaying
    func updateUI(at indexPath: IndexPath) {
        switch indexPath.row {
            
        case 0: // Language cell
            lbTitle.text = "settings_vc_laguage".localized(using: "Localizable")
            lbDescription.text = Localize.currentLanguage().localized(using: "Localizable")
            lbDescription.isHidden = false
            imgAccessory.isHidden = false
            
        case 1: // Distance cell
            lbTitle.text = "settings_vc_distance".localized(using: "Localizable")
            if let distanceRawValue: String = UserDefaults.standard.string(forKey: Common.UserDefaults.distance) {
                lbDescription.text = distanceRawValue.localized(using: "Localizable")
            }
            lbDescription.isHidden = false
            imgAccessory.isHidden = false
            
        case 2: // Countdown delay cell
            lbTitle.text = "settings_vc_coundown_delay".localized(using: "Localizable")
            let countdownDelayRawValue: Int = UserDefaults.standard.integer(forKey: Common.UserDefaults.countdownDelay)
            lbDescription.text = "\(countdownDelayRawValue) " + "seconds".localized(using: "Localizable")
            lbDescription.isHidden = false
            imgAccessory.isHidden = false
            
            //        case 3:
            //            cell.lbTitle.text = "settings_vc_user_profile".localized(using: "Localizable")
            //            cell.lbDescription.isHidden = true
            //            cell.imgAccessory.isHidden = false
            
        case 3: // Lgout cell
            lbTitle.text = "settings_vc_logout".localized(using: "Localizable")
            lbDescription.isHidden = true
            imgAccessory.isHidden = true
            
        default:
            break
        }
    }

}
