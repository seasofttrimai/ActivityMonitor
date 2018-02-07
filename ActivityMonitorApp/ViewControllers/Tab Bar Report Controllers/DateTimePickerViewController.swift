//
//  DateTimePickerViewController.swift
//  ActivityMonitorApp
//
//  Created by Seasoft on 9/28/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import UIKit
import Device
import Localize_Swift

class DateTimePickerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - VARIBALES
    
    var dateCustomDelegate: DateCustomDelegate?
    var dateFrom: Date = Date().dateFor(.startOfDay)
    var dateTo: Date = Date().dateFor(.endOfDay)
    
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        return dateFormatter
    } ()
    
    
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languageSetting()
        appearanceSetting()
        notificationSetting()
    }
    
    
    
    // MARK: - HELPER FUNCTIONS
    
    // Setting language
    func languageSetting() {
        self.navigationItem.title = "date_time_picker_vc_title".localized(using: "Localizable")
    }
    
    
    // Setting appearance
    func appearanceSetting() {
        
        // Background, back button, right button
        self.view.backgroundColor = Common.Color.backgroundMaskColor
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneBarButtonTapped))
        tableView.tableFooterView = UIView()
    }
    
    
    // Setting notification
    func notificationSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadLaguage), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    
    // Reload language function
    func reloadLaguage() {
        languageSetting()
        tableView.reloadData()
    }
    
    
    // Done button tapped function
    func doneBarButtonTapped() {
        guard dateFrom < dateTo else {
            Helper.popupDateChecking()
            return
        }
        dateCustomDelegate?.setDateRange(dateFrom: dateFrom, dateTo: dateTo)
        navigationController?.popViewController(animated: true)
    }
    
    
    // Prepare for perform segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Go to Calendar View Controller
        if segue.identifier == Common.Segue.goToCalendarVC {
            let calendarVC = segue.destination as? CalendarViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                if indexPath.section == 0 && indexPath.row == 0 {
                    calendarVC?.dateType = DateType.from
                    calendarVC?.dateSelected = dateFrom
                }
                
                if indexPath.section == 1 && indexPath.row == 0 {
                    calendarVC?.dateType = DateType.to
                    calendarVC?.dateSelected = dateTo
                }
            }
            
            calendarVC?.dateSelectedDelegate = self
        }
    }
    
    
}



// MARK: - UITABLEVIEW DATASOURCE

extension DateTimePickerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Device.size() < Size.screen4_7Inch {
            // Your device screen is smaller than 4.7 inch
            return 65
        } else {
            // Your device screen is equal or bigger than 4.7 inch
            return 70
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "Header") as! DateTimePickerHeaderCell
        
        switch section {
        case 0:
            headerCell.lbTitle.text = "date_time_picker_vc_from_day".localized(using: "Localizable")
        case 1:
            headerCell.lbTitle.text = "date_time_picker_vc_to_day".localized(using: "Localizable")
        default:
            headerCell.lbTitle.text = "date_time_picker_vc_other".localized(using: "Localizable")
        }
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! DateTimePickerTableViewCell
        
        cell.updateUI(by: dateFrom, dateTo, at: indexPath)
        
        return cell
    }
    
}



// MARK: - UITABLEVIEW DELEGATE

extension DateTimePickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Common.Segue.goToCalendarVC, sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}



// MARK: - DATE SELECTED DELEGATE

extension DateTimePickerViewController: DateSelectedDelegate {
    func setDate(date: Date, dateType: DateType) {
        switch dateType {
        case .from:
            dateFrom = date.dateFor(.startOfDay)
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.automatic)
        case .to:
            dateTo = date.dateFor(.endOfDay)
            tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: UITableViewRowAnimation.automatic)
        }
    }
}

