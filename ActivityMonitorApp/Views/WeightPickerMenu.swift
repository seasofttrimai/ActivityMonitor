//
//  WeightPickerMenu.swift
//  ActivityMonitorApp
//
//  Created by Mai Nguyen Quang Tri on 10/18/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Localize_Swift

protocol WeightPickerMenuDelegate: class {
    func weightPickerDidSelect(weight: String, weightEncode: String)
}

class WeightPickerMenu: NSObject {
    weak var delegate: WeightPickerMenuDelegate?
    let blackView = UIView()
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgba(10, green: 44, blue: 54, alpha: 1)
        
        return view
    }()
    
    let picker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = UIColor.white
        
        return picker
    }()
    
    lazy var doneButton: UIButton = {
        let doneButton = UIButton(type: .system)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle("Done", for: .normal)
        doneButton.tintColor = UIColor.white
        return doneButton
    }()
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = Common.Font.titleFont
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    var currentWeight = "65$5$0"{
        didSet {
            let tempArray = currentWeight.split(separator: "$")
            if tempArray.count == 3 {
                firstComponent = Int(tempArray[0])!
                secondComponent = Int(tempArray[1])!
                thirdComponent = Int(tempArray[2])!
                picker.selectRow(firstComponent, inComponent: 0, animated: false)
                picker.selectRow(secondComponent, inComponent: 1, animated: false)
                picker.selectRow(thirdComponent, inComponent: 2, animated: false)
            }
        }
    }
    var firstComponent: Int = 0
    var secondComponent: Int = 0
    var thirdComponent: Int = 0
    let headerHeight: CGFloat = 45
    
    override init() {
        super.init()
        initDatePicker()
    }
    
    func initDatePicker(){
        picker.dataSource = self
        picker.delegate = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(picker)
        containerView.addConstraint(NSLayoutConstraint(item: picker, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: picker, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: picker, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: headerHeight))
        containerView.addConstraint(NSLayoutConstraint(item: picker, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0))
        
        
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        containerView.addSubview(doneButton)
        
        containerView.addConstraint(NSLayoutConstraint(item: doneButton, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -20))
        containerView.addConstraint(NSLayoutConstraint(item: doneButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
        //doneButton.addConstraint(NSLayoutConstraint(item: doneButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 100))
        doneButton.addConstraint(NSLayoutConstraint(item: doneButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: headerHeight))
        
        
        
        containerView.addSubview(titleLabel)
        containerView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 20))
        containerView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
        titleLabel.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: headerHeight))

        /*let tempArray = currentWeight.split(separator: "$")
        if tempArray.count == 3 {
            firstComponent = Int(tempArray[0])!
            secondComponent = Int(tempArray[1])!
            thirdComponent = Int(tempArray[2])!
            picker.selectRow(firstComponent, inComponent: 0, animated: false)
            picker.selectRow(secondComponent, inComponent: 1, animated: false)
            picker.selectRow(thirdComponent, inComponent: 2, animated: false)
        }*/
        
    }
    
    func doneButtonPressed(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.alpha = 0
            self.containerView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.containerView.frame = CGRect(x: 0, y: window.frame.height, width: self.containerView.frame.width, height: self.containerView.frame.height)
            }
        }) { (completed: Bool) in
            self.delegate?.weightPickerDidSelect(weight: "\(self.firstComponent).\(self.secondComponent) \(self.thirdComponent == 0 ? "kg" : "lb")", weightEncode: "\(self.firstComponent)$\(self.secondComponent)$\(self.thirdComponent)")
        }
    }
    
    func showWeightMenu() {
        //show menu
        titleLabel.text = "user_profile_choose_your_weight".localized(using: "Localizable")
        doneButton.setTitle("user_profile_choose_done".localized(using: "Localizable"), for: .normal)
        

        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            window.addSubview(blackView)
            
            //containerView.addSubview(tableView)
            window.addSubview(containerView)
            //let y = window.frame.height - height
            containerView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.size.width, height: (headerHeight + picker.frame.height))
            containerView.alpha = 1
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                //self.containerView.center = self.blackView.center
                self.containerView.frame.origin.y = window.frame.height - self.containerView.frame.height
                
            }, completion: nil)
        }
    }
    
    
    func handleDismiss(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.alpha = 0
            self.containerView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.containerView.frame = CGRect(x: self.containerView.frame.origin.x, y: window.frame.height, width: self.containerView.frame.width, height: self.containerView.frame.height)
                
            }
            
        }) { (completed: Bool) in
            print("do nothing")
        }
    }
    
    
    
    
    
}

extension WeightPickerMenu: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 500
        case 1:
            return 10
        default:
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row)"
        case 1:
            return ".\(row)"
        default:
            if row == 0{
                return "kg"
            }else{
                return "lb"
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0:
            firstComponent = row
        case 1:
            secondComponent = row
        default:
            thirdComponent = row
        }
    }
    
}
