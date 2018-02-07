//
//  ActivityMenu.swift
//  ActivityMonitorApp
//
//  Created by Mai Nguyen Quang Tri on 9/26/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Localize_Swift

protocol ActivityMenuDelegate: class {
    func didSelectActivityMenu(activity: ActivityType)
}

class ActivityMenu: NSObject, UITableViewDelegate, UITableViewDataSource {
    weak var delegate: ActivityMenuDelegate?
    var currentActivity: ActivityType?{
        didSet {
            self.tableView.reloadData()
        }
    }
    
    let blackView = UIView()
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Common.Color.mainColor
        view.layer.cornerRadius = 3
        return view
    }()
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = UIColor.white
        table.separatorStyle = .none
        return table
    }()
    
    let cellId = "cellId"
    let cellHeight: CGFloat = ActivityMenuCell.heightOfCell
    let headerHeight: CGFloat = 60
    let cellWidth: CGFloat = 280
    let borderHeight: CGFloat = 3
    let titleLabel = UILabel()
    let activities: [ActivityType] = {
        return [.walking, .running, .bicycling]
    }()
    
    
    
    func showActivityMenu() {
        //show menu
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            window.addSubview(blackView)
            
            //containerView.addSubview(tableView)
            window.addSubview(containerView)
            
            var height: CGFloat = CGFloat(activities.count) * cellHeight
            if activities.count > 4 {
                height = cellHeight * 4
            }
            height = height + headerHeight
            //let y = window.frame.height - height
            containerView.frame = CGRect(x: (window.frame.size.width - cellWidth)/2.0, y: window.frame.height, width: cellWidth, height: height)
            containerView.alpha = 1
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                self.containerView.center = self.blackView.center
                //self.tableView.frame = CGRect(x: 0, y: y, width: 280, height: self.tableView.frame.height)
                
            }, completion: nil)
        }
    }
    
    func handleDismissWithActivity(activity: ActivityType) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.alpha = 0
            self.containerView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.containerView.frame = CGRect(x: self.containerView.frame.origin.x, y: window.frame.height, width: self.containerView.frame.width, height: self.containerView.frame.height)
                
            }
            
        }) { (completed: Bool) in
            self.delegate?.didSelectActivityMenu(activity: activity)
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
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activityCell = tableView.dequeueReusableCell(withIdentifier: ActivityMenuCell.identifier, for: indexPath) as! ActivityMenuCell
        activityCell.updateCellWith(activity: activities[indexPath.row], currentActivity: (currentActivity?.rawValue.id)!)
        return activityCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //handleDismiss(activity: activities[indexPath.row])
        handleDismissWithActivity(activity: self.activities[indexPath.row])
    }
    
    
    
    override init() {
        super.init()
        initHeader()
        initTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadLaguage), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        //self.blackView.addGestureRecognizer(tapGesture)
    }
    
    func reloadLaguage() {
        languageSetting()
    }
    
    func languageSetting() {
        titleLabel.text = "activity_menu_title".localized(using: "Localizable")
    }
    
    func initHeader() {
        let headerView = UIView.init(frame: CGRect(x: borderHeight, y: borderHeight, width: cellWidth-(borderHeight*2), height: headerHeight-(borderHeight*2)))
        headerView.backgroundColor = UIColor.white
        let thumbnailImageView = UIImageView()
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.image = UIImage(named: "activities")
        headerView.addSubview(thumbnailImageView)
        headerView.addConstraint(NSLayoutConstraint(item: thumbnailImageView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: headerView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 20))
        headerView.addConstraint(NSLayoutConstraint(item: thumbnailImageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: headerView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        thumbnailImageView.addConstraint(NSLayoutConstraint(item: thumbnailImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 40))
        thumbnailImageView.addConstraint(NSLayoutConstraint(item: thumbnailImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 40))
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = Common.Color.mainColor
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 25)//UIFont.boldSystemFont(ofSize: 25)
        titleLabel.text = "activity_menu_title".localized(using: "Localizable")
        titleLabel.textAlignment = .center
        headerView.addSubview(titleLabel)
        headerView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: thumbnailImageView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 10))
        headerView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: headerView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -8))
        headerView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: headerView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
        headerView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: headerView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0))
        
        let boderView = UIView(frame: CGRect(x: 0, y: headerHeight - borderHeight, width: cellWidth - (borderHeight * 2), height: borderHeight))
        boderView.backgroundColor = Common.Color.mainColor
        boderView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(boderView)
        
        containerView.addSubview(headerView)
    }
    
    func initTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ActivityMenuCell.self, forCellReuseIdentifier: ActivityMenuCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(tableView)
        containerView.addConstraint(NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: borderHeight))
        containerView.addConstraint(NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -borderHeight))
        containerView.addConstraint(NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: headerHeight))
        containerView.addConstraint(NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -borderHeight))
    }
    
    func handleTap(){
        handleDismiss()
    }
}
