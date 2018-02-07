//
//  Model.swift
//  ActivityMonitorApp
//
//  Created by Seasoft on 9/26/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import Foundation
import MapKit
import RealmSwift


// MARK: - REALM OBJECT

let realm = try! Realm()

// Activity Data Realm Object
class ActivityData: Object {
    dynamic var id: Int = 0
    dynamic var duration: Int = 0
    dynamic var distance: Float = 0.0
    dynamic var locations: String = ""
    dynamic var speed: Float = 0.0
    dynamic var calo: Float = 0.0
    dynamic var created: Date = Date()
}


// User Profile Realm Object
class UserProfile : Object {
    //    dynamic var id: Int = 0
    dynamic var email: String = ""
    //    dynamic var name: String = ""
    dynamic var weightEncode: String = "65$5$0"
    dynamic var genderIndex: Int = 0
    dynamic var birthDay: Date = Date()
    dynamic var unitIndex: Int = 0
    
    override class func primaryKey() -> String? {
        return "email"
    }
}



// MARK: - STRUCT OBJECT

public struct Model {
    
    public struct SettingOption {
        public static let languages = ["en", "vi"]
        public static let distance = ["kilometers", "miles"]
        public static let countdownDelay = [3, 5, 10, 15]
    }
    
    public struct UserProfileOption {
        public static let genderArray: [String] = ["user_profile_not_specified", "user_profile_male", "user_profile_female"]
        public static let unitArray: [String] = ["Kilometer", "Mile"]
    }

}



// MARK: - LOCAL CLASS OBJECT

// Activity Result Class Object
enum TypeIndexMeasure: Int {
    case speed = 0
    case distance = 1
    case calo = 2
    case duration = 3
}

class ActivityResult: NSObject {
    let duration: Int
    let distance: Float
    let heart_rate: Int
    let locations: String
    
    init(duration: Int, distance: Float, heart_rate: Int, locations: String) {
        self.duration = duration
        self.distance = distance
        self.heart_rate = heart_rate
        self.locations = locations
    }
}


// Type Measure Class Object
class TypeMeasure: NSObject {
    var title: String
    var imageName: String
    var sub: String
    var color: UIColor
    var type: TypeIndexMeasure
    init(title: String, imageName: String, sub: String, color: UIColor, type: TypeIndexMeasure) {
        self.title = title
        self.imageName = imageName
        self.sub = sub
        self.color = color
        self.type = type
    }
    
    init(measure: TypeMeasure){
        self.title = measure.title
        self.imageName = measure.imageName
        self.sub = measure.sub
        self.color = measure.color
        self.type = measure.type
    }
}


// Start Map Annotation Class Object
class StartAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}


// End Map Annotation Class Object
class EndAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}



// MARK: - ENUM OBJECT

// Activity Type Enum
public enum ActivityType {
    case walking
    case running
    case bicycling
    
    static let allValues = [walking, running, bicycling]
    static let allIDs = [1, 2, 3]
    
    var rawValue: (id: Int, name: String, img: String) {
        switch self {
        case .walking: return (id: 1, name: "walking", img: "walking_filled")
        case .running: return (id: 2, name: "running", img: "running_filled")
        case .bicycling: return (id: 3, name: "bicycling", img: "bicycling_road_filled")
        }
    }
    
    static func getActivityBy(id: Int) -> ActivityType {
        switch id {
        case 1:
            return .walking
        case 2:
            return .running
        case 3:
            return .bicycling
        default:
            return .walking
        }
    }
}


// Filter Date Type Enum
public enum FilterDateType {
    case allDate
    case thisWeek
    case thisMonth
    case thisYear
    case customDate
    
    static let allValues = [allDate, thisWeek, thisMonth, thisYear, customDate]
}


//Date Type Enum
public enum DateType: String {
    case from = "from"
    case to = "to"
}


// Setting Property Enum
public enum SettingProperty: String {
    case language = "language"
    case distance = "distance"
    case countdownDelay = "countdownDelay"
}


// Language Property Enum
public enum LanguageProperty: String {
    case english = "english"
    case vietnamese = "vietnamese"
}


// Distance Property Enum
public enum DistanceProperty: String {
    case kilometers = "kilometers"
    case miles = "miles"
}


// Countdown Delay Property Enum
public enum CountdownDelayProperty: Int {
    case three = 3
    case five = 5
    case ten = 10
    case fifteen = 15
}

