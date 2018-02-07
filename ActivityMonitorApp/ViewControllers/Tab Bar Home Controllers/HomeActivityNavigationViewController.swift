//
//  HomeActivityNavigationViewController.swift
//  ActivityMonitorApp
//
//  Created by Mai Nguyen Quang Tri on 9/26/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import Foundation
import UIKit

class HomeActivityNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar appearance (Home Controllers)
        self.navigationBar.barTintColor = Common.Color.barBackgroundColor
        self.navigationBar.isTranslucent = false
        
        #if swift(>=4.0)
            self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: Common.Color.titleTextColor, NSAttributedStringKey.font: Common.Font.titleFont]
        #elseif swift(>=3.0)
            self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Common.Color.titleTextColor, NSFontAttributeName: Common.Font.titleFont]
        #endif
        
        /*self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
         self.navigationBar.shadowImage = UIImage()
         self.navigationBar.isTranslucent = true*/
    }
    
}
