//
//  ResultActivityViewController.swift
//  ActivityMonitorApp
//
//  Created by Mai Nguyen Quang Tri on 9/28/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MapKit
import Localize_Swift
import RealmSwift

class ResultActivityViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var firstImageView: UIImageView!{
        didSet{
            firstImageView.image = UIImage(named:"highway_filled")?.withRenderingMode(.alwaysTemplate)
            firstImageView.tintColor = UIColor.rgba(50, green: 192, blue: 252, alpha: 1)
        }
    }
    @IBOutlet weak var firstTitleLabel: UILabel!
    @IBOutlet weak var firstDescriptionLabel: UILabel!{
        didSet{
            firstDescriptionLabel.text = "result_activity_vc_total_distance".localized(using: "Localizable")
        }
    }
    
    @IBOutlet weak var secondImageView: UIImageView!{
        didSet{
            secondImageView.image = UIImage(named:"time_filled")?.withRenderingMode(.alwaysTemplate)
            secondImageView.tintColor = UIColor.rgba(204, green: 156, blue: 47, alpha: 1)
        }
    }
    @IBOutlet weak var secondTitleLabel: UILabel!
    @IBOutlet weak var secondDescriptionLabel: UILabel!{
        didSet{
            secondDescriptionLabel.text = "result_activity_vc_total_time".localized(using: "Localizable")
        }
    }
    
    @IBOutlet weak var thirdImageView: UIImageView!{
        didSet{
            thirdImageView.image = UIImage(named:"speed_filled")?.withRenderingMode(.alwaysTemplate)
            thirdImageView.tintColor = UIColor.rgba(153, green: 212, blue: 98, alpha: 1)
        }
    }
    @IBOutlet weak var thirdTitleLabel: UILabel!
    @IBOutlet weak var thirdDescriptionLabel: UILabel!{
        didSet{
            thirdDescriptionLabel.text = "result_activity_vc_average_speed".localized(using: "Localizable")
        }
    }
    
    @IBOutlet weak var fourthImageView: UIImageView!{
        didSet{
            fourthImageView.image = UIImage(named:"ic_calories")?.withRenderingMode(.alwaysTemplate)
            fourthImageView.tintColor = UIColor.rgba(241, green: 113, blue: 91, alpha: 1)
        }
    }
    @IBOutlet weak var fourthTitleLabel: UILabel!{
        didSet{
            fourthTitleLabel.text = "0.00"
        }
    }
    @IBOutlet weak var fourthDescriptionLabel: UILabel!{
        didSet{
            fourthDescriptionLabel.text = "result_activity_vc_calories".localized(using: "Localizable")
        }
    }
    
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var zoomInButton: UIButton!
    @IBOutlet weak var zoomOutButton: UIButton!
    @IBOutlet weak var chevronImageView: UIImageView!{
        didSet{
            chevronImageView.image = UIImage(named:"chevron_down")?.withRenderingMode(.alwaysTemplate)
            chevronImageView.tintColor = UIColor.white
            let angle:CGFloat = (180.0 * CGFloat.pi / 180.0)
            let rotation = CGAffineTransform(rotationAngle: angle)
            chevronImageView.transform = rotation
        }
    }
    @IBOutlet weak var saveButton: UIButton!{
        didSet{
            if self.isNewRecord {
                self.saveButton.setTitle("result_activity_vc_save_button".localized(using: "Localizable"), for: .normal)
            }else{
                self.saveButton.setTitle("result_activity_vc_cancel_button".localized(using: "Localizable"), for: .normal)
            }
        }
    }
    
    @IBOutlet weak var deleteButton: UIButton!{
        didSet{
            self.deleteButton.setTitle("result_activity_vc_delete_button".localized(using: "Localizable"), for: .normal)
            
        }
    }
    var isZoomIn: Bool = false
    //var activityResult: ActivityResult!
    var activityResult: ActivityData!
    var locationManager: CLLocationManager = CLLocationManager()
    var isNewRecord: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL?.absoluteString as Any)
        self.initMapView()
        self.initProperties()
        //NotificationCenter.default.addObserver(self, selector: #selector(self.reloadLaguage), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }

    func initMapView(){
        locationManager.delegate = self
        //self.mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    func initProperties(){
        if self.activityResult != nil {
            //print("self.activityResult = \(self.activityResult)")
            if UserDefaults.standard.string(forKey: Common.UserDefaults.distance) == DistanceProperty.kilometers.rawValue{
                let km = (self.activityResult.distance / 1000.0)
                let speed = self.self.activityResult.speed * 3.6
                
                self.firstTitleLabel.text = String(format: "%.02f km", km)
                self.thirdTitleLabel.text = String(format: "%.02f km/h", speed)
            }else{
                let mile = self.activityResult.distance / (1000.0 * Common.Constant.aMile)
                let speed = self.self.activityResult.speed * 3.6 / Common.Constant.aMile
                self.firstTitleLabel.text = String(format: "%.02f mi", mile)
                self.thirdTitleLabel.text = String(format: "%.02f mi/h", speed)
            }
            
            let second = self.activityResult.duration % 60
            let minute = self.activityResult.duration / 60;
            let hour = minute / 60;
            secondTitleLabel.text = String(format: "%02i:%02i:%02i", hour, minute, second)
            fourthTitleLabel.text = String(format: "%.02f", self.activityResult.calo)
            let locations = self.activityResult.locations.components(separatedBy: "$")
            if self.activityResult.locations != ""{
                var coordinates:[CLLocationCoordinate2D] = []
                for location in locations {
                    let arrary = location.components(separatedBy: ",")
                    let coordinate = CLLocationCoordinate2DMake(Double(arrary[0])!, Double(arrary[1])!)
                    coordinates.append(coordinate)
                }
                DispatchQueue.main.async {
                    // Update UI
                    print("locations = \(locations)")
                    let pathPolyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
                    self.mapView.removeOverlays(self.mapView.overlays)
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.mapView.addOverlays([pathPolyline])
                    
                    if coordinates.count > 0 {
                        let firstPoint = coordinates.first
                        let region = MKCoordinateRegionMakeWithDistance(
                            firstPoint!, 2000, 2000)
                        self.mapView.setRegion(region, animated: true)
                        
                        self.addStartAnnotation(coordinate: firstPoint!)
                        let lastPoint = coordinates.last
                        self.addEndAnnotation(coordinate: lastPoint!)
                    }
                    let firstPoint = coordinates[0]
                    let region = MKCoordinateRegionMakeWithDistance(
                        firstPoint, 2000, 2000)
                    self.mapView.setRegion(region, animated: true)
                    
                }
            }
            
        }
    }
    
    func reloadLaguage() {
//        languageSetting()
    }
    
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        if !self.isNewRecord {
            let alert = UIAlertController(
                title: "",
                message: "Are you sure you wanna delete this activity",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
                
            })
            alert.addAction(UIAlertAction(title: "Yes", style: .default) { action in
                self.removeActivity(activity: self.activityResult)
                self.dismiss(animated: true, completion: nil)
            })
            self.present(alert, animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if self.isNewRecord {
            self.addNewActivity(activity: self.activityResult)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func zoomOutButtonDragInside(_ sender: Any) {
        
    }
    @IBAction func zoomOutButtonPressed(_ sender: Any) {
        print("self.isZoomIn = \(self.isZoomIn)")
        if self.isZoomIn {
            UIView.animate(withDuration: 0.5, animations: {
                let angle:CGFloat = (180.0 * CGFloat.pi / 180.0)
                let rotation = CGAffineTransform(rotationAngle: angle)
                self.chevronImageView.transform = rotation
                self.topConstraint.constant = 0
                
                self.view.layoutIfNeeded()
            }, completion: {completed in
                self.isZoomIn = false
                self.zoomInButton.isHidden = false
            })
            
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                let angle:CGFloat = (0 * CGFloat.pi / 180.0)
                let rotation = CGAffineTransform(rotationAngle: angle)
                self.chevronImageView.transform = rotation
                self.topConstraint.constant = 0 - self.containerView.frame.height
                self.view.layoutIfNeeded()
            }, completion: {completed in
                self.isZoomIn = true
                self.zoomInButton.isHidden = true
            })
        }
        
    }
    
    @IBAction func zoomInButtonPressed(_ sender: Any) {
        self.isZoomIn = true
        self.containerView.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            let angle:CGFloat = (0 * CGFloat.pi / 180.0)
            let rotation = CGAffineTransform(rotationAngle: angle)
            self.chevronImageView.transform = rotation
            
            self.topConstraint.constant = 0 - self.containerView.frame.height
            self.view.layoutIfNeeded()
        }, completion: {completed in
            UIView.animate(withDuration: 0.5, animations: {
                self.zoomInButton.isHidden = true
            })
        })
    }
    
    func addNewActivity(activity: ActivityData) {
//        let realm = try! Realm()
        try! realm.write {
            realm.add(activity)
        }
    }
    
    func removeActivity(activity: ActivityData) {
//        let realm = try! Realm()
        try! realm.write {
            realm.delete(activity)
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
            
            //placemarks?.first
            
            /*let placemark = placemarks?.first
            
            print("placemark = \(String(describing: placemark))")

            // Location name
            if let locationName = placemark?.addressDictionary!["Name"] as? String, let street = placemark?.addressDictionary!["Thoroughfare"] as? String, let city = placemark?.addressDictionary!["City"] as? String{
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
        /*let endAnno = EndAnnotation(coordinate: coordinate, title: "End Title", subtitle: "Sub Titlle")
        mapView.addAnnotation(endAnno)*/
    }
    
    /*@IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        if isZoomIn {
            let translation = recognizer.translation(in: self.view)
            self.topConstraint.constant += translation.y
            if self.topConstraint.constant > 20 {
                self.topConstraint.constant = 20
            }else if self.topConstraint.constant < 60 - self.containerView.frame.height {
                self.topConstraint.constant = 60 - self.containerView.frame.height
            }
            self.view.layoutIfNeeded()
            recognizer.setTranslation(CGPoint.zero, in: self.view)
            
            print("translation cur = \(translation.y)")
            if recognizer.state == UIGestureRecognizerState.ended {
                print("translation = \(translation.y), self.topConstraint.constant = \(self.topConstraint.constant)")
                if self.topConstraint.constant != 20 {
                    isZoomIn = false
                    self.zoomInButton.isHidden = false
                    UIView.animate(withDuration: 0.5, animations: {
                        self.topConstraint.constant = 20
                        self.view.layoutIfNeeded()
                        self.zoomOutButton.alpha = 0.0
                    }, completion: {completed in
                        self.zoomOutButton.isHidden = true
                    })
                }else if self.topConstraint.constant == 20 {
                    isZoomIn = false
                    self.zoomInButton.isHidden = false
                    UIView.animate(withDuration: 0.5, animations: {
                        self.zoomOutButton.alpha = 0.0
                    }, completion: {completed in
                        self.zoomOutButton.isHidden = true
                    })
                }
            }
        }
        
    }*/
}

extension ResultActivityViewController: MKMapViewDelegate{
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
extension ResultActivityViewController: CLLocationManagerDelegate{
    //---------------------------------------------------------------
    // -------------------CLLocationManager Delegate-----------------
    //---------------------------------------------------------------
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //print("locationManager didFailWithError")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let currentLocation = locations[0]
        //print("currentLocation = \(currentLocation)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}
