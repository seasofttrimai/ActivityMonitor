//
//  DatePickerMenu.swift
//  ActivityMonitorApp
//
//  Created by Mai Nguyen Quang Tri on 10/18/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Localize_Swift

protocol DatePickerMenuDelegate: class {
    func datePickerDidSelect(date: Date)
}

class DatePickerMenu: NSObject {
    weak var delegate: DatePickerMenuDelegate?
    let blackView = UIView()
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgba(10, green: 44, blue: 54, alpha: 1)
        
        return view
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePickerMode.date
        
        return datePicker
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
    
    var currentDate:Date = Date(){
        didSet {
            datePicker.setDate(currentDate, animated: false)
        }
    }
    
    
    let headerHeight: CGFloat = 45
    
    override init() {
        super.init()
        initDatePicker()
        
        
        
    }
    
    func initDatePicker(){
        datePicker.setDate(currentDate, animated: false)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(datePicker)
        containerView.addConstraint(NSLayoutConstraint(item: datePicker, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: datePicker, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: datePicker, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: headerHeight))
        containerView.addConstraint(NSLayoutConstraint(item: datePicker, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0))
        
        
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
            self.delegate?.datePickerDidSelect(date: self.datePicker.date)
        }
    }
    
    func showDateMenu() {
        //show menu
        titleLabel.text = "user_profile_choose_your_birth_day".localized(using: "Localizable")
        doneButton.setTitle("user_profile_choose_done".localized(using: "Localizable"), for: .normal)
        
        datePicker.locale = Locale(identifier: Localize.currentLanguage())
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            window.addSubview(blackView)
            
            //containerView.addSubview(tableView)
            window.addSubview(containerView)
            //let y = window.frame.height - height
            containerView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.size.width, height: (headerHeight + datePicker.frame.height))
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
