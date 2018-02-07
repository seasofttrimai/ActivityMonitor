//
//  ViewController.swift
//  ActivityMonitorApp
//
//  Created by Mai Nguyen Quang Tri on 9/25/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import UIKit

class MainViewController: ESTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tab bar appearance
        self.delegate = nil
        self.tabBar.shadowImage = UIImage(named: "transparent")
        self.tabBar.backgroundImage = UIImage(named: "background_dark")
        
        // Initial tabbar child view
        let v1 = self.storyboard?.instantiateViewController(withIdentifier: "ReportNavigationViewController") as! ReportNavigationViewController
        let v2 = self.storyboard?.instantiateViewController(withIdentifier: "HomeActivityNavigationViewController") as! HomeActivityNavigationViewController
        let v3 = self.storyboard?.instantiateViewController(withIdentifier: "SettingNavigationViewController") as! SettingNavigationViewController
        
        // Initial tabbar (ESTabBar library)
        v1.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: nil, image: UIImage(named: "chromatography"), selectedImage: UIImage(named: "chromatography_filled"))
        v2.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(), title: nil, image: UIImage(named: "exercise"), selectedImage: UIImage(named: "exercise_filled"))
        v3.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: nil, image: UIImage(named: "settings"), selectedImage: UIImage(named: "settings_filled"))
        
        // Setting tabbar
        self.viewControllers = [v1, v2, v3]
        self.selectedIndex = 1
        
    }
    
    
}

