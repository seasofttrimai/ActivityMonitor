//
//  HomeActivityViewController.swift
//  ActivityMonitorApp
//
//  Created by Mai Nguyen Quang Tri on 9/25/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MapKit
import Localize_Swift

class HomeActivityViewController: UIViewController {
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var activityIV: UIImageView!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startButton: UIButton!
    
    
    var currentActivity: ActivityType = {
        return ActivityType.running
    }()
    
    lazy var activityMenu: ActivityMenu = {
        let menu = ActivityMenu()
        menu.delegate = self
        return menu
    }()
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.languageSetting()
        self.initProperties()
        self.initMapView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadLaguage), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    func initMapView(){
        let status = CLLocationManager.authorizationStatus()
        if(status == CLAuthorizationStatus.authorizedWhenInUse || status == CLAuthorizationStatus.authorizedAlways) {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
            if #available(iOS 9.0, *) {
                locationManager.requestLocation()
            } else {
                // Fallback on earlier versions
            }            
            self.mapView.setUserTrackingMode(.follow, animated: true)
            
            self.startButton.backgroundColor = Common.Color.startButtonColor
            self.startButton.setTitle("home_activity_vc_start_button".localized(using: "Localizable"), for: .normal)
        }else{
            self.startButton.backgroundColor = Common.Color.pauseButtonColor
            self.startButton.setTitle("home_activity_vc_enable_gps_button".localized(using: "Localizable"), for: .normal)
        }
    }
    
    func initProperties(){
        
        self.gradientView.layoutIfNeeded()
        let colorTop =  UIColor.init(white: 0.0, alpha: 0.2).cgColor
        let colorBottom = UIColor.init(white: 0.0, alpha: 1).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.gradientView.frame.width, height: self.gradientView.frame.height)
        self.gradientView.layer.addSublayer(gradientLayer)
    }
    
    func reloadLaguage() {
        languageSetting()
    }
    
    func languageSetting() {
        self.navigationItem.title = "home_activity_vc_title".localized(using: "Localizable")
        self.activityLabel.text = currentActivity.rawValue.name.localized(using: "Localizable").uppercased()
        let status = CLLocationManager.authorizationStatus()
        if(status == CLAuthorizationStatus.authorizedWhenInUse || status == CLAuthorizationStatus.authorizedAlways) {
            self.startButton.setTitle("home_activity_vc_start_button".localized(using: "Localizable"), for: .normal)
        }else{
            self.startButton.setTitle("home_activity_vc_enable_gps_button".localized(using: "Localizable"), for: .normal)
        }
    }
    
    @IBAction func activityButtonPressed(_ sender: Any) {
        activityMenu.currentActivity = currentActivity
        activityMenu.showActivityMenu()
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case CLAuthorizationStatus.authorizedWhenInUse, CLAuthorizationStatus.authorizedAlways:
            //performSegue(withIdentifier: Common.Segue.goToActivityViewController, sender: nil)
            let activityVC = self.storyboard?.instantiateViewController(withIdentifier: "ActivityViewController") as! ActivityViewController
            activityVC.currentActivity = currentActivity
            let naVC = UINavigationController.init(rootViewController: activityVC)
            naVC.modalTransitionStyle = .crossDissolve
            naVC.navigationController?.isNavigationBarHidden = true
            self.present(naVC, animated: true, completion: nil)
            
            break
        case CLAuthorizationStatus.notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
            //locationManager.requestLocation()
            if #available(iOS 9.0, *) {
                locationManager.requestLocation()
            } else {
                // Fallback on earlier versions
            }
            self.mapView.setUserTrackingMode(.follow, animated: true)
            break
        default:
            let alert = UIAlertController(
                title: nil,
                message: "home_activity_vc_location_alert".localized(using: "Localizable"),
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK".localized(using: "Localizable"), style: .default) { action in
                if #available(iOS 10, *) {
                    if let appLocation = URL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.shared.open(appLocation, options: [:], completionHandler: nil)
                    }
                }else{
                    if let appLocation = URL(string:"prefs:root=LOCATION_SERVICES") {
                        UIApplication.shared.openURL(appLocation)
                    }//UIApplication.sharedApplication().openURL(NSURL(string:"prefs:root=LOCATION_SERVICES")!)
                }
                
                
            })
            alert.addAction(UIAlertAction(title: "cancel".localized(using: "Localizable"), style: .cancel) { action in
                print("Please turn on the location")
            })
            
            self.present(alert, animated: true)
            break
        }
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Common.Segue.goToActivityVC {
            let activiryVC = segue.destination as? ActivityViewController
            activiryVC?.currentActivity = currentActivity
        }
    }
    
}

extension HomeActivityViewController: ActivityMenuDelegate{
    func didSelectActivityMenu(activity: ActivityType){
        currentActivity = activity
        activityIV.image = UIImage(named: activity.rawValue.img)
        activityLabel.text = activity.rawValue.name.localized(using: "Localizable").uppercased()
    }
}

extension HomeActivityViewController: CLLocationManagerDelegate{
    //---------------------------------------------------------------
    // -------------------CLLocationManager Delegate-----------------
    //---------------------------------------------------------------
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //print("locationManager didFailWithError")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations[0]
        print("currentLocation = \(currentLocation)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if(status == CLAuthorizationStatus.authorizedWhenInUse || status == CLAuthorizationStatus.authorizedAlways) {
            self.startButton.backgroundColor = Common.Color.startButtonColor
            self.startButton.setTitle("home_activity_vc_start_button".localized(using: "Localizable"), for: .normal)
        }else{
            self.startButton.backgroundColor = Common.Color.pauseButtonColor
            self.startButton.setTitle("home_activity_vc_enable_gps_button".localized(using: "Localizable"), for: .normal)
        }
    }
}
