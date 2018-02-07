//
//  UIView+Extension.swift
//  ActivityMonitorApp
//
//  Created by Seasoft on 9/26/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    // MARK: - *** Gradient applying function ***
    
    enum GradientDirection {
        case leftToRight
        case rightToLeft
        case topToBottom
        case bottomToTop
    }
    
    func gradientBackground(from color1: UIColor, to color2: UIColor, direction: GradientDirection) {
        self.layoutIfNeeded()
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [color1.cgColor, color2.cgColor]
        
        switch direction {
        case .leftToRight:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .rightToLeft:
            gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .bottomToTop:
            gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        default:
            break
        }
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    
    
    // MARK: - *** Draw custom background function ***
    
    enum LanguageSelectedPosition {
        case leftSide
        case rightSide
    }
    
    func addSelectedBackground(on side: LanguageSelectedPosition) {
        
        // Remove the last added shape layer if added before
        if let layers = self.layer.sublayers {
            for layer in layers {
                if layer.name == "shapeLayer" {
                    layer.removeFromSuperlayer()
                }
            }
        }
        
        // Draw a shape layer
        let path = UIBezierPath()
        let width:CGFloat = self.bounds.width
        let height:CGFloat = self.bounds.height
        
        switch side {
        case .leftSide:
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: width * 0.4, y: 0))
            path.addLine(to: CGPoint(x: width * 0.6, y: height))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.close()
            
        case .rightSide:
            path.move(to: CGPoint(x: width * 0.4, y: 0))
            path.addLine(to: CGPoint(x: width, y: 0))
            path.addLine(to: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: width * 0.6, y: height))
            path.close()
        }
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.fillColor = Common.Color.backgroundColor.cgColor
        shape.name = "shapeLayer"
        
        // Add shape layer to current view
        self.layer.insertSublayer(shape, at: 0)
        
    }
    
    
}
