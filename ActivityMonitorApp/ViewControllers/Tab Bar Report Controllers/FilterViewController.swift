//
//  FilterViewController.swift
//  ActivityMonitorApp
//
//  Created by Seasoft on 9/28/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import UIKit
import Device
import Localize_Swift

class FilterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - VARIABLES
    
    var activities: [ActivityType] = []
    var filterDateType: FilterDateType?
    
    var filterDelegate: FilterDataDelegate?
    
    var dateCustomFrom: Date?
    var dateCustomTo: Date?
    
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        return dateFormatter
    } ()
    
    
    
    // MARK: - LIFE CYCLES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languageSetting()
        appearanceSetting()
    }
    
    
    
    // MARK: - HELPER FUNCTIONS
    
    // Setting language
    func languageSetting() {
        self.navigationItem.title = "filter_vc_title".localized(using: "Localizable")
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadLaguage), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    
    // Setting appearance
    func appearanceSetting() {
        
        // Background, back button, done button, tableview footer
        self.view.backgroundColor = Common.Color.backgroundMaskColor
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneBarButtonTapped))
        tableView.tableFooterView = UIView()
        //        toggleBarButtonItemDone(enable: false)
    }
    
    
    // Reload language function
    func reloadLaguage() {
        updateSelectedItem { () -> (Void) in
            self.languageSetting()
            self.tableView.reloadData()
        }
    }
    
    
    // Done button tapped function
    func doneBarButtonTapped() {
        updateSelectedItem { () -> (Void) in
            self.filterDelegate?.filterActivity(activities: self.activities,
                                                filterDateType: self.filterDateType,
                                                dateCustomFrom: self.dateCustomFrom,
                                                dateCustomTo: self.self.dateCustomTo)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    // Prepare for perform segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Go to Date Time Picker View Controller
        if segue.identifier == Common.Segue.goToDateTimePickerVC {
            let dateTimePickerVC = segue.destination as? DateTimePickerViewController
            if let dateCustomFrom = dateCustomFrom {
                dateTimePickerVC?.dateFrom = dateCustomFrom
            }
            if let dateCustomTo = dateCustomTo {
                dateTimePickerVC?.dateTo = dateCustomTo
            }
            dateTimePickerVC?.dateCustomDelegate = self
        }
    }
    
    
    // Update selected items function
    func updateSelectedItem(completion: @escaping () -> (Void)) {
        
        guard let selectedRows = tableView.indexPathsForSelectedRows else {
            return
        }
        
        activities.removeAll()
        
        for indexPath in selectedRows {
            
            // Update activities
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    activities.append(.walking)
                    break
                case 1:
                    activities.append(.running)
                    break
                case 2:
                    activities.append(.bicycling)
                    break
                default:
                    break
                }
            }
            
            // Update filter date type
            if indexPath.section == 1 {
                switch indexPath.row {
                case 0: // All time
                    filterDateType = .allDate
                case 1: // This week
                    filterDateType = .thisWeek
                    break
                case 2: // This month
                    filterDateType = .thisMonth
                    break
                case 3: // This year
                    filterDateType = .thisYear
                    break
                case 4: // Custome time
                    filterDateType = .customDate
                    break
                default:
                    break
                }
            }
            
        }
        completion()
    }
    
}



// MARK: - UITABLEVIEW DATASOURCE

extension FilterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Device.size() < Size.screen4_7Inch {
            // Your device screen is smaller than 4.7 inch
            return 55
        } else {
            // Your device screen is equal or bigger than 4.7 inch
            return 60
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 3
        case 1:
            return 5
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "Header") as! FilterHeaderCell
        
        switch section {
        case 0:
            headerCell.lbTitle.text = "filter_vc_filter_by_activity".localized(using: "Localizable")
        case 1:
            headerCell.lbTitle.text = "filter_vc_filter_by_time".localized(using: "Localizable")
        default:
            headerCell.lbTitle.text = "filter_vc_other".localized(using: "Localizable")
        }
        
        return headerCell.contentView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! FilterTableViewCell
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                if activities.contains(.walking) {
                    tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                    cell.imgAccessory.isHidden = false
                }
                cell.lbTitle.text = "walking".localized(using: "Localizable")
                cell.imgActivity.image = UIImage(named: "walking_filled")
                cell.imgAccessory.image = UIImage(named: "checkmark_filled")
                
            case 1:
                if activities.contains(.running) {
                    tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                    cell.imgAccessory.isHidden = false
                }
                cell.lbTitle.text = "running".localized(using: "Localizable")
                cell.imgActivity.image = UIImage(named: "running_filled")
                cell.imgAccessory.image = UIImage(named: "checkmark_filled")
                
            case 2:
                if activities.contains(.bicycling) {
                    tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                    cell.imgAccessory.isHidden = false
                }
                cell.lbTitle.text = "bicycling".localized(using: "Localizable")
                cell.imgActivity.image = UIImage(named: "bicycling_road_filled")
                cell.imgAccessory.image = UIImage(named: "checkmark_filled")
                
            default:
                return UITableViewCell()
            }
        }
        
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                if filterDateType == .allDate {
                    tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                    cell.imgAccessory.isHidden = false
                }
                cell.lbTitle.text = "filter_vc_all_time".localized(using: "Localizable")
                cell.imgActivity.image = UIImage(named: "calendar_all_filled")
                cell.imgAccessory.image = UIImage(named: "checkmark_filled")
                
            case 1:
                if filterDateType == .thisWeek {
                    tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                    cell.imgAccessory.isHidden = false
                }
                cell.lbTitle.text = "filter_vc_week".localized(using: "Localizable")
                cell.imgActivity.image = UIImage(named: "calendar_7_filled")
                cell.imgAccessory.image = UIImage(named: "checkmark_filled")
                
            case 2:
                if filterDateType == .thisMonth {
                    tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                    cell.imgAccessory.isHidden = false
                }
                cell.lbTitle.text = "filter_vc_month".localized(using: "Localizable")
                cell.imgActivity.image = UIImage(named: "calendar_31_filled")
                cell.imgAccessory.image = UIImage(named: "checkmark_filled")
                
            case 3:
                if filterDateType == .thisYear {
                    tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                    cell.imgAccessory.isHidden = false
                }
                cell.lbTitle.text = "filter_vc_year".localized(using: "Localizable")
                cell.imgActivity.image = UIImage(named: "calendar_12_filled")
                cell.imgAccessory.image = UIImage(named: "checkmark_filled")
                
            case 4:
                if filterDateType == .customDate {
                    tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                    cell.imgAccessory.isHidden = false
                }
                
                if let dateCustomFrom = dateCustomFrom, let dateCustomTo = dateCustomTo {
                    cell.lbTitle.text = dateCustomFrom.compare(.isSameDay(as: dateCustomTo)) ? dateCustomFrom.localizedDate() : dateCustomFrom.localizedDate() + " - " + dateCustomTo.localizedDate()
                } else {
                    cell.lbTitle.text = "filter_vc_custom".localized(using: "Localizable")
                }
                
                cell.imgActivity.image = UIImage(named: "calendar_filled")
                cell.imgAccessory.image = UIImage(named: "right_4")
                cell.imgAccessory.isHidden = false
            default:
                return UITableViewCell()
            }
        }
        
        return cell
    }
}



// MARK: - UITABLEVIEW DELEGATE

extension FilterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath selected <<-->> indexPath: \(String(describing: tableView.indexPathsForSelectedRows?.debugDescription))")
        
        guard let cell = tableView.cellForRow(at: indexPath) as? FilterTableViewCell else {
            return
        }
        
        cell.imgAccessory.isHidden = false
        //        toggleBarButtonItemDone(enable: true)
        
        if indexPath.section == 1 && indexPath.row == 4 {
            performSegue(withIdentifier: Common.Segue.goToDateTimePickerVC, sender: nil)
            //            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("indexPath deselected <<--->> indexPath: \(String(describing: tableView.indexPathsForSelectedRows?.debugDescription))")
        
        guard let cell = tableView.cellForRow(at: indexPath) as? FilterTableViewCell else {
            return
        }
        
        if indexPath.section == 1 && indexPath.row == 4 {
            cell.imgAccessory.isHidden = false
        } else {
            cell.imgAccessory.isHidden = true
        }
        
        if tableView.indexPathsForSelectedRows == nil {
            //            toggleBarButtonItemDone(enable: false)
        }
        
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        print("will select <<-- row: \(indexPath.row) - section: \(indexPath.section)")
        
        // Deselect multiple selection in section 1 (filter by time)
        // Make sure section 0 is multiple section and section 1 is single selection
        // If the second row in section 1 is selected, it will deselect the previous selected row in section 1
        
        // Make sure this code only perform when user interact in section 1  (filter by time) && except the custom time selection
        //        guard indexPath.section == 1 && indexPath.row != 3  else {
        //            return indexPath
        //        }
        
        // Make sure this code only perform when user interact in section 1  (filter by time)
        guard indexPath.section == 1 else {
            return indexPath
        }
        
        // Make sure this code only perform when table view have rows selected before (filter by time)
        guard let indexPathsSelected = tableView.indexPathsForSelectedRows else {
            return indexPath
        }
        
        guard indexPathsSelected.count > 0  else {
            return indexPath
        }
        
        print("will indexPathsSelected <<-- indexPathsSelected: \(indexPathsSelected.debugDescription)")
        
        // Deselect the previous selected row in section 1
        for indexPathPrevious in indexPathsSelected {
            if indexPathPrevious.section == 1 {
                tableView.deselectRow(at: indexPathPrevious, animated: false)
                if let cell = tableView.cellForRow(at: indexPathPrevious) as? FilterTableViewCell {
                    if indexPathPrevious.row == 4 {
                        cell.imgAccessory.isHidden = false
                    } else {
                        cell.imgAccessory.isHidden = true
                    }
                }
            }
        }
        
        return indexPath
    }
    
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        
        guard let indexPathsSelected = tableView.indexPathsForSelectedRows else {
            return nil
        }
        
        if indexPath.section == 0 {
            let a =  indexPathsSelected.filter { (indexPath) -> Bool in
                indexPath.section == 0
            }
            if a.count <= 1  {
                return nil
            }
        }
        
        if indexPath.section == 1 && indexPath.row != 4 {
            let b =  indexPathsSelected.filter { (indexPath) -> Bool in
                indexPath.section == 1
            }
            if b.count <= 1  {
                return nil
            }
        }
        
        
        if indexPath.section == 1 && indexPath.row == 4 {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
            performSegue(withIdentifier: Common.Segue.goToDateTimePickerVC, sender: nil)
            return nil
        }
        
        return indexPath
    }
    
    
    //    func toggleBarButtonItemDone(enable: Bool) {
    //        guard self.navigationItem.rightBarButtonItem?.isEnabled == !enable else {
    //            return
    //        }
    //        self.navigationItem.rightBarButtonItem?.isEnabled = enable
    //    }
    
}



// MARK: - DATE CUSTOM DELEGATE

extension FilterViewController: DateCustomDelegate {
    
    func setDateRange(dateFrom: Date, dateTo: Date) {
        dateCustomFrom = dateFrom
        dateCustomTo = dateTo
        guard let cell = tableView.cellForRow(at: IndexPath(row: 4, section: 1)) as? FilterTableViewCell else {
            return
        }
        cell.lbTitle.text = dateFrom.compare(.isSameDay(as: dateTo)) ? dateFrom.localizedDate() : dateFrom.localizedDate() + " - " + dateTo.localizedDate()
        print("Set date range")
    }
    
}
