//
//  FilterTableViewCell.swift
//  ActivityMonitorApp
//
//  Created by Seasoft on 9/28/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgActivity: UIImageView!
    @IBOutlet weak var lbTitle: MarqueeLabel!
    @IBOutlet weak var imgAccessory: UIImageView!
    
    
    // Configure the view for the selected state
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            // Highlight text and arrow image
            lbTitle.textColor = Common.Color.selectedTextColor
            imgAccessory.maskWith(color: Common.Color.selectedTextColor)
            
        } else {
            // Normal text and arrow image
            lbTitle.textColor = UIColor.white
            imgAccessory.maskWith(color: UIColor.white)
        }
        
    }
    
}



