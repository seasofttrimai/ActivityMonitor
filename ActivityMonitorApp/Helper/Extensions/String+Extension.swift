//
//  String+Extension.swift
//  ActivityMonitorApp
//
//  Created by Seasoft on 9/27/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import Foundation
import UIKit


extension String {
    
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    var length: Int { // Swift 1.2
        return self.characters.count
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: from))
    }
    
    func contains(_ find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    // Truncates the string to length number of characters and appends optional trailing string if longer
    func truncate(_ length: Int, trailing: String? = "...") -> String {
        if self.characters.count > length {
            return self.substring(to: self.characters.index(self.startIndex, offsetBy: length)) + (trailing ?? "")
        } else {
            return self
        }
    }
    
    
}

