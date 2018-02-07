//
//  ReportNavigationViewController.swift
//  ActivityMonitorApp
//
//  Created by Seasoft on 9/27/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import UIKit

class ReportNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Navigation bar appearance (Report Controllers)
        self.navigationBar.barTintColor = Common.Color.barBackgroundColor
        self.navigationBar.tintColor = Common.Color.barTintColor
        self.navigationBar.isTranslucent = false
        
        #if swift(>=4.0)
            self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: Common.Color.titleTextColor, NSAttributedStringKey.font: Common.Font.titleFont]
        #elseif swift(>=3.0)
            self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Common.Color.titleTextColor, NSFontAttributeName: Common.Font.titleFont]
        #endif
        
    }

}
