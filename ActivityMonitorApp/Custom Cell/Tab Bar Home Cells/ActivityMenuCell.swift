//
//  ActivityMenuCell.swift
//  ActivityMonitorApp
//
//  Created by Mai Nguyen Quang Tri on 9/26/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import Foundation
import UIKit

open class ActivityMenuCell : UITableViewCell {
    
    class var identifier: String { return String.className(self) }
    class var heightOfCell: CGFloat { return 60 }
    
    lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        //imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    lazy var checkedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        imageView.image = UIImage(named: "checkmark_filled")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.rgba(0, green: 207, blue: 23, alpha: 1)
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Common.Color.mainColor
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 17)//UIFont.boldSystemFont(ofSize: 17)
        
        return label
    }()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(){
        
        self.addSubview(thumbnailImageView)
        self.addConstraint(NSLayoutConstraint(item: thumbnailImageView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 20))
        self.addConstraint(NSLayoutConstraint(item: thumbnailImageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        thumbnailImageView.addConstraint(NSLayoutConstraint(item: thumbnailImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 35))
        thumbnailImageView.addConstraint(NSLayoutConstraint(item: thumbnailImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 35))
        
        self.addSubview(checkedImageView)
        self.addConstraint(NSLayoutConstraint(item: checkedImageView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -20))
        self.addConstraint(NSLayoutConstraint(item: checkedImageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        checkedImageView.addConstraint(NSLayoutConstraint(item: checkedImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 35))
        checkedImageView.addConstraint(NSLayoutConstraint(item: checkedImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 35))
        
        self.addSubview(titleLabel)
        self.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: thumbnailImageView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 15))
        self.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: checkedImageView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: -15))
        self.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0))
        
        let borderBottom = UIView()
        borderBottom.backgroundColor = Common.Color.mainColor
        borderBottom.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(borderBottom)
        self.addConstraint(NSLayoutConstraint(item: borderBottom, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 20))
        self.addConstraint(NSLayoutConstraint(item: borderBottom, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -20))
        self.addConstraint(NSLayoutConstraint(item: borderBottom, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0))
        borderBottom.addConstraint(NSLayoutConstraint(item: borderBottom, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 1))
        
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        
        self.backgroundColor = UIColor.white
        self.selectionStyle = .none
        self.layoutIfNeeded()
    }
    
    func updateCellWith(activity: ActivityType, currentActivity: Int){
        
        titleLabel.text = activity.rawValue.name.localized(using: "Localizable").uppercased()
        
        thumbnailImageView.image = UIImage(named: activity.rawValue.img)?.withRenderingMode(.alwaysTemplate)
        thumbnailImageView.tintColor = Common.Color.mainColor
        
        checkedImageView.isHidden = activity.rawValue.id == currentActivity ? false : true
    }
    
}
