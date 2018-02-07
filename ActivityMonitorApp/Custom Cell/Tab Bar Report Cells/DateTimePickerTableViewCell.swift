//
//  DateTimePickerTableViewCell.swift
//  ActivityMonitorApp
//
//  Created by Seasoft on 9/28/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import UIKit

class DateTimePickerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    
    // Cell data displaying
    func updateUI(by dateFrom: Date, _ dateTo: Date, at indexPath: IndexPath) {
        
        // Cell 1: date from
        if indexPath.section == 0 && indexPath.row == 0 {
            lbTitle.text = dateFrom.localizedDate()
        }
        
        // Cell 2: date to
        if indexPath.section == 1 && indexPath.row == 0 {
            lbTitle.text = dateTo.localizedDate()
        }
        
    }
    
}
