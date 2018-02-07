//
//  UnitDistanceMenu.swift
//  ActivityMonitorApp
//
//  Created by Mai Nguyen Quang Tri on 10/19/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Localize_Swift

protocol UnitDistancePickerMenuDelegate: class {
    func unitDistancePickerDidSelect(unit: String, unitIndex: Int)
}

class UnitDistancePickerMenu: NSObject {
    weak var delegate: UnitDistancePickerMenuDelegate?
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
    
    var currentUnit = 0{
        didSet {
            picker.selectRow(currentUnit, inComponent: 0, animated: false)
        }
    }
    
    var firstComponent: Int = 0
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
    }
    
    func doneButtonPressed(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.alpha = 0
            self.containerView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.containerView.frame = CGRect(x: 0, y: window.frame.height, width: self.containerView.frame.width, height: self.containerView.frame.height)
            }
        }) { (completed: Bool) in
            self.delegate?.unitDistancePickerDidSelect(unit: Model.UserProfileOption.unitArray[self.currentUnit], unitIndex: self.currentUnit)
        }
    }
    
    func showUnitMenu() {
        //show menu
        titleLabel.text = "user_profile_choose_your_gender".localized(using: "Localizable")
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

extension UnitDistancePickerMenu: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Model.UserProfileOption.unitArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Model.UserProfileOption.unitArray[row].localized(using: "Localizable")
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentUnit = row
    }
    
}
