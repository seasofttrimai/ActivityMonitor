//
//  UIImage+Extension.swift
//  ActivityMonitorApp
//
//  Created by Seasoft on 10/9/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    // MARK: - *** Masking image by color function ***
    
    func maskWith(color: UIColor) {
        guard let tempImage = image?.withRenderingMode(.alwaysTemplate) else { return }
        image = tempImage
        tintColor = color
    }
    
}
