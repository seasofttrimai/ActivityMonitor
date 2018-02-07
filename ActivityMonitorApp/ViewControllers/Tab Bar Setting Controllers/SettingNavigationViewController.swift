//
//  SettingNavigationViewController.swift
//  ActivityMonitorApp
//
//  Created by Seasoft on 9/26/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import UIKit

class SettingNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar appearance (Setting Controllers)
        self.navigationBar.barTintColor = Common.Color.barBackgroundColor
        self.navigationBar.tintColor = Common.Color.barTintColor
        
        #if swift(>=4.0)
            self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: Common.Color.titleTextColor, NSAttributedStringKey.font: Common.Font.titleFont]
        #elseif swift(>=3.0)
            self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Common.Color.titleTextColor, NSFontAttributeName: Common.Font.titleFont]
        #endif
        
    }
    
}
