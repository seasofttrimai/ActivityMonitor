//
//  ReportTableViewCell.swift
//  ActivityMonitorApp
//
//  Created by Seasoft on 9/27/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import UIKit
import Device

class ReportTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var imgActivity: UIImageView!
    @IBOutlet weak var lbActivity: UILabel!
    
    @IBOutlet weak var ring1: UICircularProgressRingView!
    @IBOutlet weak var ring2: UICircularProgressRingView!
    @IBOutlet weak var ring3: UICircularProgressRingView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if Device.size() < Size.screen4_7Inch {
            
            // Your device screen is smaller than 4.7 inch
            lbTime.font = Common.Font.historyFontSmall
            lbActivity.font = Common.Font.historyFontSmall
            
            ring1.showValueFloatingPoint = true
            ring1.valueFont = Common.Font.ringValueFontSmall
            ring1.unitFont = Common.Font.ringUnitFontSmall
            
            ring2.valueFont = Common.Font.ringValueFontSmall
            ring2.unitFont = Common.Font.ringUnitFontSmall
            ring2.unitText = "MIN"
            
            ring3.showValueFloatingPoint = true
            ring3.valueFont = Common.Font.ringValueFontSmall
            ring3.unitFont = Common.Font.ringUnitFontSmall
            
        } else {
            
            // Your device screen is equal or bigger than 4.7 inch
            lbTime.font = Common.Font.historyFontLarge
            lbActivity.font = Common.Font.historyFontLarge
            
            ring1.showValueFloatingPoint = true
            ring1.valueFont = Common.Font.ringValueFontLarge
            ring1.unitFont = Common.Font.ringUnitFontLarge
            
            ring2.valueFont = Common.Font.ringValueFontLarge
            ring2.unitFont = Common.Font.ringUnitFontLarge
            ring2.unitText = "MIN"
            
            ring3.showValueFloatingPoint = true
            ring3.valueFont = Common.Font.ringValueFontLarge
            ring3.unitFont = Common.Font.ringUnitFontLarge
        }
        
        
        // Cell background color
        selectionStyle = .default
        let view = UIView()
        view.backgroundColor = UIColor.clear
        selectedBackgroundView = view
        
    }
    
    
    // Cell data displaying
    func updateUI(by activityData: ActivityData) {
        
        // Time, image, activity name
        let activity = ActivityType.getActivityBy(id:  activityData.id)
        lbTime.text = activityData.created.localizedDate()
        imgActivity.image = UIImage(named: activity.rawValue.img)
        lbActivity.text = activity.rawValue.name.lowercased().localized(using: "Localizable")
        
        // Unit label on rings
        if UserDefaults.standard.string(forKey: Common.UserDefaults.distance) == DistanceProperty.kilometers.rawValue {
            ring1.updateUnitLabel(value: "KM")
            ring3.updateUnitLabel(value: "KPH")
        } else {
            ring1.updateUnitLabel(value: "MILE")
            ring3.updateUnitLabel(value: "MPH")
        }
        
        // Value label on rings
        //        ring1.minValue = 0
        ring1.maxValue = CGFloat(activityData.distance)
        ring1.setProgress(value: CGFloat(activityData.distance), animationDuration: 0)
        
        //        ring2.minValue = 0
        ring2.maxValue = CGFloat(activityData.duration)
        ring2.setProgress(value: CGFloat(activityData.duration), animationDuration: 0)
        
        //        ring3.minValue = 0
        ring3.maxValue = CGFloat(activityData.speed)
        ring3.setProgress(value: CGFloat(activityData.speed), animationDuration: 0)
        
    }
    
    
}
