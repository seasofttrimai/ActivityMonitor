

//
//  ActivityViewController.swift
//  ActivityMonitorApp
//
//  Created by Mai Nguyen Quang Tri on 9/27/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import UIKit
import MapKit
import Foundation
import CoreMotion
import AVFoundation
import Localize_Swift


class ActivityViewController: UIViewController {
    var firstTypeMeasure: TypeMeasure = TypeMeasure(title: "0 km", imageName: "highway_filled", sub: "result_activity_vc_total_distance".localized(using: "Localizable"), color: UIColor.rgba(50, green: 192, blue: 252, alpha: 1), type: TypeIndexMeasure.distance)
    var secondTypeMeasure: TypeMeasure = TypeMeasure(title: "00:00:00", imageName: "time_filled", sub: "result_activity_vc_total_time".localized(using: "Localizable"), color: UIColor.rgba(204, green: 156, blue: 47, alpha: 1), type: TypeIndexMeasure.duration)
    var thirdTypeMeasure: TypeMeasure = TypeMeasure(title: "0.00 km/h", imageName: "speed_filled", sub: "result_activity_vc_average_speed".localized(using: "Localizable"), color: UIColor.rgba(153, green: 212, blue: 98, alpha: 1), type: TypeIndexMeasure.speed)
    var fourthTypeMeasure: TypeMeasure = TypeMeasure(title: "0.00", imageName: "ic_calories", sub: "result_activity_vc_calories".localized(using: "Localizable"), color: UIColor.rgba(241, green: 113, blue: 91, alpha: 1), type: TypeIndexMeasure.calo)
    
    //var pedometer = CMPedometer()
    let activityManager = CMMotionActivityManager()
    let motion = CMMotionManager()
    var currentActivity : ActivityType!
    var currentTypeIndexMeasure: TypeIndexMeasure = TypeIndexMeasure.duration
    var secondTimer: Timer!
    var secondTimeOut: Int = UserDefaults.standard.integer(forKey: Common.UserDefaults.countdownDelay)
    var secondMaxTimeOut: Int = 60
    var isPaused: Bool = false
    var isCompletedAnimation: Bool = true
    var secondTotal: Int = 0
    var distanceTotal: Float = 0
    var calories: Float = 0
    var speed: Int = 0
    var locationString: String = ""
    var locationManager: CLLocationManager = CLLocationManager()
    let durationAnimation = 0.3
    let typeDistance = UserDefaults.standard.string(forKey: Common.UserDefaults.distance)
    var stepCount: Int = 0
    var xAxis = 0.0
    var yAxis = 0.0
    var zAxis = 0.0
    var locationArrary:[CLLocationCoordinate2D] = []
        
    @IBOutlet weak var bigContainerView: UIView!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var secondLabel: UILabel!{
        didSet{
            secondLabel.text = "\(secondTimeOut)"
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var leftContainerView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pageControl: UIPageControl!{
        didSet{
            pageControl.pageIndicatorTintColor = .lightGray
            pageControl.currentPageIndicatorTintColor = UIColor.white
            pageControl.numberOfPages = 2
        }
    }
    @IBOutlet weak var pauseButton: UIButton!{
        didSet{
            pauseButton.backgroundColor = Common.Color.pauseButtonColor
            pauseButton.setTitle("activity_vc_pause_button".localized(using: "Localizable"), for: .normal)
            locationManager.startUpdatingLocation()
        }
    }
    @IBOutlet weak var stopButton: UIButton!{
        didSet{
            stopButton.setTitle("activity_vc_stop_button".localized(using: "Localizable"), for: .normal)
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBOutlet weak var bigImageView: UIImageView!{
        didSet{
            bigImageView.image = UIImage(named:secondTypeMeasure.imageName)?.withRenderingMode(.alwaysTemplate)
            bigImageView.tintColor = secondTypeMeasure.color
        }
    }
    @IBOutlet weak var bigLabel: UILabel!{
        didSet{
            bigLabel.text = "00:00:00"
        }
    }
    
    @IBOutlet weak var firstImageView: UIImageView!{
        didSet{
            firstImageView.image = UIImage(named:firstTypeMeasure.imageName)?.withRenderingMode(.alwaysTemplate)
            firstImageView.tintColor = firstTypeMeasure.color
        }
    }
    @IBOutlet weak var firstTitleLabel: UILabel!{
        didSet{
            if self.typeDistance == DistanceProperty.kilometers.rawValue{
                firstTitleLabel.text = "0.00 km"
            }else{
                firstTitleLabel.text = "0.00 mi"
            }
            
        }
    }
    @IBOutlet weak var firstDescriptionLabel: UILabel!{
        didSet{
            firstDescriptionLabel.text = firstTypeMeasure.sub
        }
    }
    
    @IBOutlet weak var secondImageView: UIImageView!{
        didSet{
            secondImageView.image = UIImage(named: secondTypeMeasure.imageName)?.withRenderingMode(.alwaysTemplate)
            secondImageView.tintColor = secondTypeMeasure.color
        }
    }
    @IBOutlet weak var secondTitleLabel: UILabel!{
        didSet{
            secondTitleLabel.text = secondTypeMeasure.title
        }
    }
    @IBOutlet weak var secondDescriptionLabel: UILabel!{
        didSet{
            secondDescriptionLabel.text = secondTypeMeasure.sub
        }
    }
    
    @IBOutlet weak var thirdImageView: UIImageView!{
        didSet{
            thirdImageView.image = UIImage(named:thirdTypeMeasure.imageName)?.withRenderingMode(.alwaysTemplate)
            thirdImageView.tintColor = thirdTypeMeasure.color
        }
    }
    @IBOutlet weak var thirdTitleLabel: UILabel!{
        didSet{
            //thirdTitleLabel.text = thirdTypeMeasure.title
            if self.typeDistance == DistanceProperty.kilometers.rawValue{
                thirdTitleLabel.text = "0.00 km/h"
            }else{
                thirdTitleLabel.text = "0.00 mi/h"
            }
        }
    }
    @IBOutlet weak var thirdDescriptionLabel: UILabel!{
        didSet{
            thirdDescriptionLabel.text = thirdTypeMeasure.sub
        }
    }
    
    @IBOutlet weak var fourthImageView: UIImageView!{
        didSet{
            fourthImageView.image = UIImage(named:fourthTypeMeasure.imageName)?.withRenderingMode(.alwaysTemplate)
            fourthImageView.tintColor = fourthTypeMeasure.color
        }
    }
    @IBOutlet weak var fourthTitleLabel: UILabel!{
        didSet{
            fourthTitleLabel.text = "0.00"
        }
    }
    @IBOutlet weak var fourthDescriptionLabel: UILabel!{
        didSet{
            fourthDescriptionLabel.text = fourthTypeMeasure.sub
        }
    }


    @IBOutlet weak var addSecondButton: UIButton!
    
    @IBOutlet weak var startImmediatelyLabel: UILabel!
    
    let motionQueue: OperationQueue = {
        let motionQueue = OperationQueue()
        motionQueue.name = "asia.seasoft.amapp"
        return motionQueue
    }()
    
    var isMoving: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        initMapView()
        self.navigationController?.isNavigationBarHidden = true
        resetTimer()
        self.reloadLaguage()
        //self.startCMMotionManager()
        //self.startCMMotionActivityManager()
    }
    
    func startCMMotionActivityManager() {
        if CMMotionActivityManager.isActivityAvailable() {
            activityManager.startActivityUpdates(to: motionQueue) { activity in
                // Ignore unclassified activites.
                DispatchQueue.main.async {
                    if (activity?.stationary)!{
                        print("activity = stationary")
                        self.isMoving = false
                    }else if (activity?.walking)!{
                        print("activity = walking")
                        self.isMoving = true
                    }else if (activity?.running)!{
                        print("activity = running")
                        self.isMoving = true
                    }else if (activity?.cycling)!{
                        print("activity = cycling")
                        self.isMoving = true
                    }else{
                        print("activity = none")
                        self.isMoving = false
                    }
                }
            }
        }
        else {
            print("Activity updates are not available.")
        }
    }
    
    func startCMMotionManager() {
        if motion.isDeviceMotionAvailable {
            self.motion.showsDeviceMovementDisplay = true
            /*self.motion.deviceMotionUpdateInterval = 1.0
            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical,
                                                 to: motionQueue, withHandler: { (data, error) in
                // Make sure the data is valid before accessing it.
                if let validData = data {
                    // Get the attitude relative to the magnetic north reference frame.
                    let roll = validData.attitude.roll
                    let pitch = validData.attitude.pitch
                    let yaw = validData.attitude.yaw
                    print("roll = \(roll), pitch =\(pitch)m yaw = \(yaw)")
                    // Use the motion data in your app.
                 }
            })*/
            
            self.motion.accelerometerUpdateInterval = 1
            self.motion.startAccelerometerUpdates(to: motionQueue, withHandler: {(data, error) in
                // Make sure the data is valid before accessing it.
                DispatchQueue.main.async {
                    if let validData = data {
                        // Get the attitude relative to the magnetic north reference frame.
                        let x = round(validData.acceleration.x * 10)
                        let y = round(validData.acceleration.y * 10)
                        let z = round(validData.acceleration.z * 10)
                        print("x = \(x), y =\(y) z = \(z)")
                        if x != self.xAxis || y != self.yAxis || z != self.zAxis {
                            self.xAxis = x
                            self.yAxis = y
                            self.zAxis = z
                            self.isMoving = true
                        }else{
                            self.isMoving = false
                        }
                        
                    }
                }
                
            })
        }else {
            print("CMMotionManager updates are not available.")
        }
        /*if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0
            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
            // Configure a timer to fetch the motion data.
            if #available(iOS 10.0, *) {
                let timer = Timer(fire: Date(), interval: 0.2, repeats: true,
                                  block: { (timer) in
                                    if let data = self.motion.deviceMotion {
                                        // Get the attitude relative to the magnetic north reference frame.
                                        let pitch = data.attitude.pitch
                                        let roll = data.attitude.roll
                                        let yaw = data.attitude.yaw
                                        print("roll = \(roll), pitch =\(pitch) yaw = \(yaw)")
                                        // Use the motion data in your app.
                                        
                                    }
                })
                RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
            } else {
                // Fallback on earlier versions
            }

      // Add the timer to the current run loop.
      
        }*/
        
        
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
            if #available(iOS 9.0, *){
                locationManager.allowsBackgroundLocationUpdates = true
            }

        }
    }
    
    func zoomInUserLocation(){
        self.mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    func resetTimer() {
        if secondTimer != nil{
            secondTimer.invalidate()
        }
        secondTimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    func reloadLaguage() {
        languageSetting()
    }
    
    func languageSetting(){
        startImmediatelyLabel.text = "result_activity_vc_start_immediately".localized(using: "Localizable")
        let countdown = 10//UserDefaults.standard.integer(forKey: Common.UserDefaults.countdownDelay)//UserDefaults.standard.value(forKey: Common.UserDefaults.countdownDelay)
        addSecondButton.setTitle(String(format: "result_activity_vc_add_second".localized(using: "Localizable"), countdown), for: .normal)
    }
    
    func updateTimer(){
        secondTimeOut -= 1
        if secondTimeOut >= 0{
            secondLabel.text = "\(secondTimeOut)"
        }else if secondTimeOut == -1{
            locationManager.startUpdatingLocation()
            //self.startCMMotionManager()
            //self.startCMMotionActivityManager()
            UIView.animate(withDuration: 0.2, animations: {
                self.maskView.alpha = 0
            }, completion: { finished in
                self.maskView.isHidden = true
            })
            //self.maskView.isHidden = true
            //self.addStartAnnotation(coordinate: (locationManager.location?.coordinate)!)
            //self.addEndAnnotation(coordinate: (locationManager.location?.coordinate)!)
        }else{
            if isPaused == false{
                self.updateProperties()
            }
        }
    }
    
    func updateProperties(){
        secondTotal += 1
        //print("secondTotal = \(secondTotal)")
        let second = self.secondTotal % 60
        let minute = secondTotal / 60;
        let hour = minute / 60;
        secondTitleLabel.text = String(format: "%02i:%02i:%02i", hour, minute, second)
        
        
        if isCompletedAnimation{
            if currentTypeIndexMeasure == TypeIndexMeasure.duration{
                bigLabel.text = secondTitleLabel.text
            }
        }
        guard let location = locationManager.location else {
            print("no location")
            return
        }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        if locationArrary.count == 0 {
            locationArrary.append(location.coordinate)
            self.addStartAnnotation(coordinate: (locationManager.location?.coordinate)!)
        }
        
        if location.speed >= 0 && isMoving{
            locationArrary.append(location.coordinate)
            DispatchQueue.main.async {
                self.mapView.removeOverlays(self.mapView.overlays)
                let pathPolyline = MKPolyline(coordinates: self.locationArrary, count: self.locationArrary.count)
                self.mapView.addOverlays([pathPolyline])
            }
        }
        
        print("latitude =\(latitude). longitude = \(longitude)")
        //self.mapView.add(MKPolyline(coordinates: [location.coordinate], count: 1))
        if self.typeDistance == DistanceProperty.kilometers.rawValue{
            let speed = Float((location.speed > 0 && isMoving) ? location.speed : 0)
            if speed >= 0 && latitude != 0 && longitude != 0{
                let kph = speed * 3.6
                thirdTitleLabel.text = "\( String(format: "%.2f", kph)) km/h"
                self.distanceTotal += speed
                let km = (distanceTotal / 1000.0)
            
                firstTitleLabel.text = String(format: "%.02f km", km)
                if locationString == "" {
                    locationString = "\(latitude),\(longitude)"
                }else{
                    locationString = "\(locationString)$\(latitude),\(longitude)"
                }
            
                if isCompletedAnimation{
                    switch currentTypeIndexMeasure{
                    case TypeIndexMeasure.distance:
                        bigLabel.text = String(format: "%.02f km", km)
                    break
                    case TypeIndexMeasure.duration:
                    
                    break
                    case TypeIndexMeasure.calo:
                        bigLabel.text = fourthTitleLabel.text
                        break
                    default:
                        bigLabel.text = thirdTitleLabel.text
                    break
                    }
                }
                let mph = kph / Common.Constant.aMile
                let caloPerSecond = caloriesPerSecond(mph: mph)
                print("caloPerSecond = \(caloPerSecond)")
                calories += Float(caloPerSecond)
                fourthTitleLabel.text = String(format: "%.02f", calories)

            }
        }else{
            let speed = Float((location.speed > 0 && isMoving) ? location.speed : 0)
            if speed >= 0 && latitude != 0 && longitude != 0{
                let mph = speed * 3.6 / Common.Constant.aMile
                thirdTitleLabel.text = "\( String(format: "%.2f", mph)) mi/h"
                self.distanceTotal += speed
                let miles = (distanceTotal / (Common.Constant.aMile * 1000.0))
            
                firstTitleLabel.text = String(format: "%.02f mi", miles)
                if locationString == "" {
                    locationString = "\(latitude),\(longitude)"
                }else{
                    locationString = "\(locationString)$\(latitude),\(longitude)"
                }
            
                if isCompletedAnimation{
                    switch currentTypeIndexMeasure{
                        case TypeIndexMeasure.distance:
                        bigLabel.text = String(format: "%.02f mi", miles)
                    break
                    case TypeIndexMeasure.duration:
                    
                    break
                    case TypeIndexMeasure.calo:
                        bigLabel.text = fourthTitleLabel.text
                    break
                    default:
                        bigLabel.text = thirdTitleLabel.text
                    break
                    }
                }
                
                
                let caloPerSecond = caloriesPerSecond(mph: mph)
                print("caloPerSecond = \(caloPerSecond)")
                calories += Float(caloPerSecond) // calories/min = 0.175 x MET x weight (in kilograms)
                fourthTitleLabel.text = String(format: "%.02f", calories)
            }
        }
        //print("distanceTotal = \(distanceTotal)")
    }
    
    func caloriesPerSecond(mph: Float) -> Float{
        let MET = self.calculateMET(mph: mph)
        print("speed = \(mph), MET = \(MET)")
        let weight:Float = 65.0 //65kg
        let calories = (0.0175 * MET * weight) / 60.0 //// calories/min = 0.175 x MET x weight (in kilograms)
        return calories
    }
    func calculateMET(mph: Float) -> Float{
        if mph == 0 {
            return 0
        }
        switch self.currentActivity {
        case .walking:
            if mph <= 2 {
                return 2.5
            }else if mph <= 2.5{
                return 3.0
            }else if mph <= 3{
                return 3.5
            }else if mph <= 4{
                return 4.0
            }else if mph <= 4.5 {
                return 4.5
            }else{
                return 6.5
            }
            
        case .running:
            if mph <= 5 {
                return 8.0
            }else if mph <= 5.2{
                return 9.0
            }else if mph <= 6{
                return 10.0
            }else if mph <= 6.7{
                return 11.0
            }else if mph <= 7 {
                return 11.5
            }else if mph <= 7.5 {
                return 12.5
            }else if mph <= 8 {
                return 13.5
            }else if mph <= 8.6 {
                return 14
            }else if mph <= 9 {
                return 15
            }else if mph <= 10 {
                return 16
            }else if mph <= 10.9 {
                return 18
            }else{
                return 15
            }
            
        default:
            if mph < 10 {
                return 4.0
            }else if mph <= 11.9{
                return 6.0
            }else if mph <= 13.9{
                return 8.0
            }else if mph <= 15.9{
                return 10.0
            }else if mph <= 19 {
                return 12.0
            }else{
                return 16.0
            }
        }
    }

    func addStartAnnotation(coordinate: CLLocationCoordinate2D){
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), completionHandler: {(placemarks, error) in
            if error != nil {
                print("Reverse geocoder failed with an error" + (error?.localizedDescription)!)
            }else if (placemarks?.count)! > 0 {
                let placemark = CLPlacemark(placemark: placemarks![0] as CLPlacemark)
                let subtitle = "\(placemark.name ?? ""), \(placemark.subLocality ?? ""), \(placemark.subAdministrativeArea ?? "")"
                let startAnno = StartAnnotation(coordinate: coordinate, title: "activity_vc_start_point".localized(using: "Localizable"), subtitle: subtitle)
                self.mapView.addAnnotation(startAnno)
            }else{
                print("Problems with the data received from geocoder.")
            }
            
            
            
            /*if let locationName = placemark?.addressDictionary!["Name"] as? String, let street = placemark?.addressDictionary!["Thoroughfare"] as? String, let city = placemark?.addressDictionary!["City"] as? String{
                let startAnno = StartAnnotation(coordinate: coordinate, title: locationName, subtitle: "\(street),\(city)")
                self.mapView.addAnnotation(startAnno)
            }else{
                let startAnno = StartAnnotation(coordinate: coordinate, title: "", subtitle: "")
                self.mapView.addAnnotation(startAnno)
            }*/
        })
    }
    
    func addEndAnnotation(coordinate: CLLocationCoordinate2D){
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), completionHandler: {(placemarks, error) in
            if error != nil {
                print("Reverse geocoder failed with an error" + (error?.localizedDescription)!)
            }else if (placemarks?.count)! > 0 {
                let placemark = CLPlacemark(placemark: placemarks![0] as CLPlacemark)
                let subtitle = "\(placemark.name ?? ""), \(placemark.subLocality ?? ""), \(placemark.subAdministrativeArea ?? "")"
                let endAnno = EndAnnotation(coordinate: coordinate, title: "activity_vc_end_point".localized(using: "Localizable"), subtitle: subtitle)
                self.mapView.addAnnotation(endAnno)
            }else{
                print("Problems with the data received from geocoder.")
            }


            /*let placemark = placemarks?.first
            print("placemark = \(String(describing: placemark))")
            // Location name
            if let locationName = placemark?.addressDictionary!["Name"] as? String, let street = placemark?.addressDictionary!["Thoroughfare"] as? String, let city = placemark?.addressDictionary!["City"] as? String{
                let endAnno = EndAnnotation(coordinate: coordinate, title: locationName, subtitle: "\(street),\(city)")
                self.mapView.addAnnotation(endAnno)
            }else{
                let endAnno = EndAnnotation(coordinate: coordinate, title: "", subtitle: "")
                self.mapView.addAnnotation(endAnno)
            }*/
        })        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        scrollView.setContentOffset(CGPoint.init(x: 0, y: scrollView.contentOffset.y), animated: true)
        pageControl.currentPage = 0
        self.pageControl.isHidden = false
        self.pageControl.alpha = 1
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        let button = sender as! UIButton
        button.isUserInteractionEnabled = false
        self.secondTimeOut = 0
        self.resetTimer()
        
        // Step count by Core Motion
//        startUpdatingStepCount()
        
    }
    
    @IBAction func addTenSecondsButtonPressed(_ sender: Any) {
        secondTimeOut += 11//UserDefaults.standard.integer(forKey: Common.UserDefaults.countdownDelay) + 1
        if secondTimeOut > secondMaxTimeOut {
            secondTimeOut = secondMaxTimeOut
        }
    }
    
    @IBAction func pauseButtonPressed(_ sender: Any) {
        isPaused = !isPaused
        if isPaused{
            self.pauseButton.backgroundColor = Common.Color.startButtonColor
            self.pauseButton.setTitle("activity_vc_resume_button".localized(using: "Localizable"), for: .normal)
//            pedometer.stopUpdates()
            locationManager.stopUpdatingLocation()
            //motion.stopAccelerometerUpdates()
            //activityManager.stopActivityUpdates()
        }else{
            self.pauseButton.backgroundColor = Common.Color.pauseButtonColor
            self.pauseButton.setTitle("activity_vc_pause_button".localized(using: "Localizable"), for: .normal)
//            startUpdatingStepCount()
            locationManager.startUpdatingLocation()
            //motion.startAccelerometerUpdates()
            //self.startCMMotionManager()
            //self.startCMMotionActivityManager()
        }
    }
    @IBAction func stopButtonPressed(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        secondTimer.invalidate()
        locationManager.stopUpdatingLocation()
        motion.stopAccelerometerUpdates()
//        pedometer.stopUpdates()
        performSegue(withIdentifier: Common.Segue.goToResultActivityViewController, sender: nil)
    }
    
    @IBAction func firstButtonPressed(_ sender: Any) {
        if currentTypeIndexMeasure == TypeIndexMeasure.distance {
            return
        }
        if isCompletedAnimation {
            isCompletedAnimation = false
            currentTypeIndexMeasure = TypeIndexMeasure.distance
            UIView.animate(withDuration: self.durationAnimation, animations: {
                let transform = CATransform3DIdentity;
                self.bigContainerView.layer.transform = CATransform3DRotate(transform, CGFloat(90 * Float.pi / 180), 0, 1, 0)
                
                self.firstImageView.alpha = 0.0
                self.firstTitleLabel.alpha = 0.0
                self.firstDescriptionLabel.alpha = 0.0
            
                self.firstImageView.transform = self.firstImageView.transform.scaledBy(x: 0.5, y: 0.5)
                self.firstTitleLabel.transform = self.firstTitleLabel.transform.scaledBy(x: 0.5, y: 0.5)
                self.firstDescriptionLabel.transform = self.firstDescriptionLabel.transform.scaledBy(x: 0.5, y: 0.5)
            }, completion: {completed in
                self.bigImageView.image = UIImage(named: self.firstTypeMeasure.imageName)?.withRenderingMode(.alwaysTemplate)
                self.bigImageView.tintColor = self.firstTypeMeasure.color
                self.bigLabel.text = self.firstTitleLabel.text
            
                UIView.animate(withDuration: self.durationAnimation, animations: {
                    let transform = CATransform3DIdentity;
                    self.bigContainerView.layer.transform = CATransform3DRotate(transform, CGFloat(0 * Float.pi / 180), 0, 1, 0)
                    
                    self.firstImageView.alpha = 1.0
                    self.firstTitleLabel.alpha = 1.0
                    self.firstDescriptionLabel.alpha = 1.0
                
                    self.firstImageView.transform = CGAffineTransform.identity
                    self.firstTitleLabel.transform = CGAffineTransform.identity
                    self.firstDescriptionLabel.transform = CGAffineTransform.identity
                }, completion: {completed in
                    self.isCompletedAnimation = true
                })
            })
        }
    }
    
    @IBAction func secondButtonPressed(_ sender: Any) {
        if currentTypeIndexMeasure == TypeIndexMeasure.duration {
            return
        }
        if isCompletedAnimation {
            isCompletedAnimation = false
            currentTypeIndexMeasure = TypeIndexMeasure.duration
            UIView.animate(withDuration: self.durationAnimation, animations: {
                let transform = CATransform3DIdentity;
                self.bigContainerView.layer.transform = CATransform3DRotate(transform, CGFloat(90 * Float.pi / 180), 0, 1, 0)
                
                self.secondImageView.alpha = 0.0
                self.secondTitleLabel.alpha = 0.0
                self.secondDescriptionLabel.alpha = 0.0
            
                self.secondImageView.transform = self.secondImageView.transform.scaledBy(x: 0.5, y: 0.5)
                self.secondTitleLabel.transform = self.secondTitleLabel.transform.scaledBy(x: 0.5, y: 0.5)
                self.secondDescriptionLabel.transform = self.secondDescriptionLabel.transform.scaledBy(x: 0.5, y: 0.5)
            }, completion: {completed in
                self.bigImageView.image = UIImage(named: self.secondTypeMeasure.imageName)?.withRenderingMode(.alwaysTemplate)
                self.bigImageView.tintColor = self.secondTypeMeasure.color
                self.bigLabel.text = self.secondTitleLabel.text
            
                UIView.animate(withDuration: self.durationAnimation, animations: {
                    let transform = CATransform3DIdentity;
                    self.bigContainerView.layer.transform = CATransform3DRotate(transform, CGFloat(0 * Float.pi / 180), 0, 1, 0)
                    
                    self.secondImageView.alpha = 1.0
                    self.secondTitleLabel.alpha = 1.0
                    self.secondDescriptionLabel.alpha = 1.0
                
                    self.secondImageView.transform = CGAffineTransform.identity
                    self.secondTitleLabel.transform = CGAffineTransform.identity
                    self.secondDescriptionLabel.transform = CGAffineTransform.identity
                }, completion: {completed in
                    self.isCompletedAnimation = true
                })
            })
        }
        
    }
    
    @IBAction func thirdButtonPressed(_ sender: Any) {
        if currentTypeIndexMeasure == TypeIndexMeasure.speed {
            return
        }
        if isCompletedAnimation {
            isCompletedAnimation = false
            currentTypeIndexMeasure = TypeIndexMeasure.speed
            UIView.animate(withDuration: durationAnimation, animations: {
                let transform = CATransform3DIdentity;
                self.bigContainerView.layer.transform = CATransform3DRotate(transform, CGFloat(90 * Float.pi / 180), 0, 1, 0)
                
                self.thirdImageView.alpha = 0.0
                self.thirdTitleLabel.alpha = 0.0
                self.thirdDescriptionLabel.alpha = 0.0
            
                self.thirdImageView.transform = self.thirdImageView.transform.scaledBy(x: 0.5, y: 0.5)
                self.thirdTitleLabel.transform = self.thirdTitleLabel.transform.scaledBy(x: 0.5, y: 0.5)
                self.thirdDescriptionLabel.transform = self.thirdDescriptionLabel.transform.scaledBy(x: 0.5, y: 0.5)
            }, completion: {completed in
                self.bigImageView.image = UIImage(named: self.thirdTypeMeasure.imageName)?.withRenderingMode(.alwaysTemplate)
                self.bigImageView.tintColor = self.thirdTypeMeasure.color
                self.bigLabel.text = self.thirdTitleLabel.text
            
                UIView.animate(withDuration:self.durationAnimation, animations: {
                    let transform = CATransform3DIdentity;
                    self.bigContainerView.layer.transform = CATransform3DRotate(transform, CGFloat(0 * Float.pi / 180), 0, 1, 0)
                    
                    self.thirdImageView.alpha = 1.0
                    self.thirdTitleLabel.alpha = 1.0
                    self.thirdDescriptionLabel.alpha = 1.0
                
                    self.thirdImageView.transform = CGAffineTransform.identity
                    self.thirdTitleLabel.transform = CGAffineTransform.identity
                    self.thirdDescriptionLabel.transform = CGAffineTransform.identity
                }, completion: {completed in
                    self.isCompletedAnimation = true
                })
            })
        }
        
    }
    
    @IBAction func fourthButtonPressed(_ sender: Any) {
        if currentTypeIndexMeasure == TypeIndexMeasure.calo {
            return
        }
        if isCompletedAnimation {
            isCompletedAnimation = false
            currentTypeIndexMeasure = TypeIndexMeasure.calo
            UIView.animate(withDuration: durationAnimation, animations: {
                let transform = CATransform3DIdentity;
                self.bigContainerView.layer.transform = CATransform3DRotate(transform, CGFloat(90 * Float.pi / 180), 0, 1, 0)
                
                self.fourthImageView.alpha = 0.0
                self.fourthTitleLabel.alpha = 0.0
                self.fourthDescriptionLabel.alpha = 0.0
            
                self.fourthImageView.transform = self.fourthImageView.transform.scaledBy(x: 0.5, y: 0.5)
                self.fourthTitleLabel.transform = self.fourthTitleLabel.transform.scaledBy(x: 0.5, y: 0.5)
                self.fourthDescriptionLabel.transform = self.fourthDescriptionLabel.transform.scaledBy(x: 0.5, y: 0.5)
            }, completion: {completed in
                self.bigImageView.image = UIImage(named: self.fourthTypeMeasure.imageName)?.withRenderingMode(.alwaysTemplate)
                self.bigImageView.tintColor = self.fourthTypeMeasure.color
                self.bigLabel.text = self.fourthTitleLabel.text
            
                UIView.animate(withDuration:self.durationAnimation, animations: {
                    let transform = CATransform3DIdentity;
                    self.bigContainerView.layer.transform = CATransform3DRotate(transform, CGFloat(0 * Float.pi / 180), 0, 1, 0)
                    
                    self.fourthImageView.alpha = 1.0
                    self.fourthTitleLabel.alpha = 1.0
                    self.fourthDescriptionLabel.alpha = 1.0
                
                    self.fourthImageView.transform = CGAffineTransform.identity
                    self.fourthTitleLabel.transform = CGAffineTransform.identity
                    self.fourthDescriptionLabel.transform = CGAffineTransform.identity
                }, completion: {completed in
                    self.isCompletedAnimation = true
                })
            })
        }
        
    }
    
    
    /*func startUpdatingStepCount() {
        
        pedometer = CMPedometer()
        pedometer.startUpdates(from: Date(), withHandler: { (pedometerData, error) in
            if let pedData = pedometerData {
                
                self.stepCount += pedData.numberOfSteps.intValue
                print("step from core motion:\(self.stepCount)")
                
                if let distance = pedData.distance?.doubleValue {
                     print("distance from core motion:\(distance)")
                }
                
                if #available(iOS 10.0, *) {
                    if let averageActivePace = pedData.averageActivePace?.doubleValue {
                        print("average active pace from core motion:\(averageActivePace)")
                    }
                }
                
                if let currentPace = pedData.currentPace?.doubleValue {
                    print("current pace from core motion:\(currentPace)")
                }
                
            } else {
                print("Steps: Not Available")
            }
        })
        
    }*/

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Common.Segue.goToResultActivityViewController {
            let resultActivityVC = segue.destination as? ResultActivityViewController
            //resultActivityVC?.activityResult = ActivityResult(duration: secondTotal, distance: distanceTotal, heart_rate: 142, locations: locationString)
            let activity = ActivityData()
            activity.id = currentActivity.rawValue.id
            activity.duration = secondTotal
            activity.distance = distanceTotal
            if secondTotal == 0{
                 activity.speed = 0
            }else{
                 activity.speed = distanceTotal / Float(secondTotal)
            }
            activity.calo = calories
            activity.locations = locationString
            //activity.created = NSDate()
            print("secondTotal = \(secondTotal), distanceTotal = \(distanceTotal), speed = \(distanceTotal / Float(secondTotal)) )")
            resultActivityVC?.activityResult = activity
        }
    }
}

extension ActivityViewController: UIScrollViewDelegate{
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
        if pageControl.currentPage == 0{
            self.pageControl.alpha = 1
            self.pageControl.isHidden = false
        }else{
            
            
            
            UIView.animate(withDuration: 0.5, animations: {
                self.pageControl.alpha = 0
            }, completion: {finished in
                self.pageControl.isHidden = true
                self.zoomInUserLocation()
            })
            
        }
        
        
        
    }
}

extension ActivityViewController: CLLocationManagerDelegate{
    //---------------------------------------------------------------
    // -------------------CLLocationManager Delegate-----------------
    //---------------------------------------------------------------
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ActivityViewController locationManager didFailWithError")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let currentLocation = locations[0]
        //print("currentLocation = \(currentLocation)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}

extension ActivityViewController: MKMapViewDelegate{
    //---------------------------------------------------------------
    // -------------------MKMapView Delegate-----------------
    //---------------------------------------------------------------
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        if (annotation is StartAnnotation) {
            let reuseIdentifier = "StartAnnotation"
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) {
                return annotationView
            } else {
                let startAnno = annotation as! StartAnnotation
                let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                annotationView.image = UIImage(named: "green_maker")
                if startAnno.title != "" {
                    annotationView.isEnabled = true
                    annotationView.canShowCallout = false
                }else{
                    annotationView.isEnabled = false
                    annotationView.canShowCallout = false
                }
                annotationView.isEnabled = true
                annotationView.canShowCallout = true
                let detailDisclosure = UIButton(type: UIButtonType.detailDisclosure)
                annotationView.rightCalloutAccessoryView = detailDisclosure
                annotationView.isDraggable = false
                annotationView.centerOffset = CGPoint(x: annotationView.centerOffset.x, y: annotationView.centerOffset.y - (annotationView.image?.size.height)! / 2)
                return annotationView
            }
            
        }else if (annotation is EndAnnotation) {
            let reuseIdentifier = "EndAnnotation"
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) {
                return annotationView
            } else {
                let endAnno = annotation as! EndAnnotation

                let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                annotationView.image = UIImage(named: "blue_maker")
                if endAnno.title != "" {
                    annotationView.isEnabled = true
                    annotationView.canShowCallout = false
                }else{
                    annotationView.isEnabled = false
                    annotationView.canShowCallout = false
                }
                annotationView.isEnabled = true
                annotationView.canShowCallout = true
                let detailDisclosure = UIButton(type: UIButtonType.detailDisclosure)
                annotationView.rightCalloutAccessoryView = detailDisclosure
                annotationView.isDraggable = false
                annotationView.centerOffset = CGPoint(x: annotationView.centerOffset.x, y: annotationView.centerOffset.y - (annotationView.image?.size.height)! / 2)
                return annotationView
            }
        }
        return nil
    }
}
