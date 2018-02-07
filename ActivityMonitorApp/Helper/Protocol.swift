//
//  Protocol.swift
//  ActivityMonitorApp
//
//  Created by Seasoft on 9/27/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import Foundation

// Filter delegate
protocol FilterDataDelegate {
    func filterActivity(activities: [ActivityType]?, filterDateType: FilterDateType?, dateCustomFrom: Date?, dateCustomTo: Date?)
}


// Date custom selection delegate
protocol DateCustomDelegate {
    func setDateRange(dateFrom: Date, dateTo: Date)
}


// Selected date delegate
protocol DateSelectedDelegate {
    func setDate(date: Date, dateType: DateType)
}


// Setting changing delegate
protocol SettingChangedDelegate {
    func reloadSetting(settingProperty: SettingProperty)
}








