//
//  ReportViewController.swift
//  ActivityMonitorApp
//
//  Created by Mai Nguyen Quang Tri on 9/25/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import Foundation
import UIKit
import Device
import RealmSwift
import Localize_Swift


class ReportViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - VARIBALES
    
    var trashButton =  UIButton.init(type: .custom)
    var selectAllButton = UIButton.init(type: .custom)
    
    var cancelBarButton: UIBarButtonItem?
    var selectAllBarButton: UIBarButtonItem?
    var deselectAllBarButton: UIBarButtonItem?
    var filterBarButton: UIBarButtonItem?
    var trashBarButton: UIBarButtonItem?
    
    private let refreshControl = UIRefreshControl()
    var isSelectAll: Bool = false
    
    var activitiesFilterComponent: [ActivityType] = ActivityType.allValues
    var dateTypeFilterComponent: FilterDateType = .allDate
    var today: Date = Date()
    var dateCustomFrom: Date?
    var dateCustomTo: Date?
    
    var notificationToken: NotificationToken? = nil
    var indexPathsDelete: [IndexPath] = []
    
    var listOfActivityThisWeek: Results<ActivityData>? = nil
    var listOfActivityLastWeek: Results<ActivityData>? = nil
    var listOfActivityOther2Weeks: Results<ActivityData>? = nil
    
    
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languageSetting()
        appearanceSetting()
        loadingDataFromDataBase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.edgesForExtendedLayout = .bottom
    }
    
    deinit {
        notificationToken?.stop()
    }
    
    
    
    // MARK: - HELPER FUNCTIONS
    
    // Setting language
    func languageSetting() {
        self.navigationItem.title = "report_vc_title".localized(using: "Localizable")
    }
    
    
    // Setting appearance
    func appearanceSetting() {
        
        // Background, back button, tableview footer
        self.view.backgroundColor = Common.Color.backgroundMaskColor
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tableView.tableFooterView = UIView()
        
        // Cancel bar button
        let cancelButton = UIButton.init(type: .custom)
        cancelButton.setImage(UIImage.init(named: "cancel_filled"), for: UIControlState.normal)
        cancelButton.contentMode = .scaleToFill
        cancelButton.addTarget(self, action:#selector(self.cancelBarButtonTapped), for: UIControlEvents.touchUpInside)
        cancelButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        cancelBarButton = UIBarButtonItem.init(customView: cancelButton)
        
        // Select all items bar button
        selectAllButton.setImage(UIImage.init(named: "uncheck_all"), for: UIControlState.normal)
        selectAllButton.contentMode = .scaleToFill
        selectAllButton.addTarget(self, action:#selector(self.selectAllBarButtonTapped), for: UIControlEvents.touchUpInside)
        selectAllButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        selectAllBarButton = UIBarButtonItem.init(customView: selectAllButton)
        
        // Deselect all items bar button
        let deselectAllButton = UIButton.init(type: .custom)
        deselectAllButton.setImage(UIImage.init(named: "check_all_filled"), for: UIControlState.normal)
        deselectAllButton.contentMode = .scaleToFill
        deselectAllButton.addTarget(self, action:#selector(self.deselectBarButtonTapped), for: UIControlEvents.touchUpInside)
        deselectAllButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        deselectAllBarButton = UIBarButtonItem.init(customView: deselectAllButton)
        
        // Filter bar button
        let filterButton = UIButton.init(type: .custom)
        filterButton.setImage(UIImage.init(named: "filter_and_sort_nav"), for: UIControlState.normal)
        filterButton.contentMode = .scaleToFill
        filterButton.addTarget(self, action:#selector(self.filterBarButtonTapped), for: UIControlEvents.touchUpInside)
        filterButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        filterBarButton = UIBarButtonItem.init(customView: filterButton)
        self.navigationItem.rightBarButtonItem = filterBarButton
        
        // Trash bar button
        trashButton.setImage(UIImage.init(named: "trash"), for: UIControlState.normal)
        trashButton.contentMode = .scaleToFill
        trashButton.addTarget(self, action:#selector(self.trashBarButtonTapped), for: UIControlEvents.touchUpInside)
        trashButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        trashBarButton = UIBarButtonItem.init(customView: trashButton)
        
        // Holding cell gesture
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPressMultipleDeletion(_:)))
        longGesture.minimumPressDuration = 0.5
        longGesture.delaysTouchesBegan = true
        longGesture.delegate = self
        self.tableView.addGestureRecognizer(longGesture)
        
        // Tapping ouside cell gesture
        let tapOutsideCell = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOutsideCells(_:)))
        self.tableView.backgroundView = UIView()
        self.tableView.backgroundView?.addGestureRecognizer(tapOutsideCell)
        
        // Refresh Control in Table View Setting
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        //        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing Data ...", attributes: attributes)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshActivityData(_:)), for: .valueChanged)
        
    }
    
    
    // Setting notification
    func notificationSetting() {
        // Reload language
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadLaguage), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        // Reload distance unit
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDistanceUnit), name:  NSNotification.Name(rawValue: Common.NotificationCenter.distanceUnitSettingChanged), object: nil)
    }
    
    
    // Reload language function
    func reloadLaguage() {
        languageSetting()
        tableView.reloadData()
    }
    
    // Reload distance unit function
    func reloadDistanceUnit() {
        tableView.reloadData()
    }
    
    
    // Prepare for perform segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier =  segue.identifier else {
            return
        }
        
        switch identifier {
            
        // Go to Filter View Controller
        case Common.Segue.goToFilterVC :
            
            let filterVC = segue.destination as? FilterViewController
            filterVC?.activities = activitiesFilterComponent
            filterVC?.filterDateType = dateTypeFilterComponent
            filterVC?.filterDelegate = self
            
            if dateTypeFilterComponent == .customDate {
                filterVC?.dateCustomFrom = dateCustomFrom
                filterVC?.dateCustomTo = dateCustomTo
            }
            
        // Go to Result Activity View Controller
        case Common.Segue.goToResultActivityVCFromHistoryVC:
            
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
            let activityVC = segue.destination as? ResultActivityViewController
            activityVC?.isNewRecord = false
            
            var activitiesData: ActivityData?
            
            switch indexPath.section {
            case 0:
                activitiesData = listOfActivityThisWeek?[indexPath.row]
            case 1:
                activitiesData = listOfActivityLastWeek?[indexPath.row]
            case 2:
                activitiesData = listOfActivityOther2Weeks?[indexPath.row]
            default:
                break
            }
            
            guard let activityData = activitiesData else {
                return
            }
            
            // Update indexPath for deleted rows
            indexPathsDelete.removeAll()
            indexPathsDelete.append(indexPath)
            activityVC?.activityResult = activityData
            tableView.deselectRow(at: indexPath, animated: true)
            
        default:
            break
        }
        
    }
    
    
    // MARK: - HANDLE LOADING DATA FROM DATABASE
    // Loading data first time from database
    // Default is all activities (.walking, .running, .cycling) from all date
    func loadingDataFromDataBase() {
        let predicateActivityFilter = getPredicateFilterForActivities(by: activitiesFilterComponent)
        getAllFilterdActivityData(by: predicateActivityFilter)
    }
    
    // Filter data from database depend on the compenent
    func filterDataFromDataBase() {
        let predicateActivityFilter = getPredicateFilterForActivities(by: activitiesFilterComponent)
        getAllFilterdActivityData(by: predicateActivityFilter)
    }
    
    
    // Filter all data by activities predicate (predicate bi the id of activities)
    func getAllFilterdActivityData(by predicateActivityFilter: String) {
        
        // Data from Realm
        let allActivityData = realm.objects(ActivityData.self).filter(predicateActivityFilter).sorted(byKeyPath: "created", ascending: false)
        
        // Observe results notifications. Any change in Realm database (with this predicate) will notify the notificationToken
        notificationToken = allActivityData.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                print("----initial--------------")
                print("allActivityData: \(allActivityData.count) - listOfActivityThisWeek \(self?.listOfActivityThisWeek?.count ?? 0) -listOfActivityLastWeek: \(self?.listOfActivityLastWeek?.count ?? 0) - listOfActivityOther2Weeks: \(self?.listOfActivityOther2Weeks?.count ?? 0)")
                
                // ***** Loading data and update UI only first time after the Controller loaded
                self?.filterDataByDateTimeAndSection(from: allActivityData, reloadUI: true)
                
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                print("----Update--------------")
                print("allActivityData: \(allActivityData.count) - listOfActivityThisWeek \(self?.listOfActivityThisWeek?.count ?? 0) -listOfActivityLastWeek: \(self?.listOfActivityLastWeek?.count ?? 0) - listOfActivityOther2Weeks: \(self?.listOfActivityOther2Weeks?.count ?? 0) deletions: \(deletions) - insertions: \(insertions) - modifications: \(modifications)")
                
                if self?.tableView.isEditing == true {
                    // Remove the Editing mode if it's in & Update bar button items
                    self?.tableView.setEditing(false, animated: true)
                    self?.updateBarButtonItems()
                }
                
                // ***** Update UI after Realm database deleted items
                if deletions.count > 0 {
                    self?.deleteRowsAfterUpdatingDatabase()
                }
                
                // ***** Reload all data & Update UI after Realm database inserted items
                // Realod all data make sure every items is in the correct section (this week, last week, last 2 weeks)
                if insertions.count > 0 {
                    self?.filterDataByDateTimeAndSection(from: allActivityData, reloadUI: true)
                }
                
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
        
    }
    
    
    
    
    // MARK: - HANDLE DELETE ACTION
    
    // Handle Long press on Table view Cell
    @objc private func handleLongPressMultipleDeletion(_ gesture: UILongPressGestureRecognizer) {
        
        guard tableView.isEditing == false else {
            return
        }
        
        let p = gesture.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: p)
        
        // Make sure long press on any cell (not outside the cells)
        guard indexPath != nil else {
            return
        }
        
        self.tableView.setEditing(true, animated: true)
        updateBarButtonItems()
    }
    
    
    // Handle tap on empty space below existing rows in Editing mode
    @objc private func handleTapOutsideCells(_ tap: UITapGestureRecognizer) {
        guard tableView.isEditing == true else {
            return
        }
        self.tableView.setEditing(false, animated: true)
        updateBarButtonItems()
    }
    
    
    // Handle Cancel buton tapped in Editing mode
    @objc private func cancelBarButtonTapped() {
        guard tableView.isEditing == true else {
            return
        }
        self.tableView.setEditing(false, animated: true)
        updateBarButtonItems()
    }
    
    
    // Handle Select All buton tapped in Editing mode
    // This button have 2 state of icon: "uncheck_all.png" and "check_all.png"
    @objc private func selectAllBarButtonTapped() {
        toggleAllRowEditing(isSelectAllRow: true)
    }
    
    
    // Handle Deselect All buton tapped in Editing mode
    @objc private func deselectBarButtonTapped() {
        toggleAllRowEditing(isSelectAllRow: false)
    }
    
    
    // Handle Filter buton tapped
    @objc private func filterBarButtonTapped() {
        performSegue(withIdentifier: Common.Segue.goToFilterVC, sender: nil)
    }
    
    
    // Handle Trash buton tapped
    // This button have 2 state of icon: "trash_filled.png" and "trash.png"
    @objc private func trashBarButtonTapped() {
        deleteRowsSelectedFromDataBase()
    }
    
    
    // Handle Pull down to refresh data action
    @objc private func refreshActivityData(_ sender: Any) {
        loadingDataFromDataBase()
        self.refreshControl.endRefreshing()
    }
    
    
    // HELPER FUNCTION: Update the UI after select or deselect all cells
    func toggleAllRowEditing(isSelectAllRow: Bool) {
        
        // Update UI for section This Week (section 0)
        if let thisWeek = self.listOfActivityThisWeek?.count {
            for i in 0..<thisWeek {
                if isSelectAllRow {
                    self.tableView.selectRow(at: IndexPath(row: i, section: 0), animated: true, scrollPosition: .none)
                } else {
                    self.tableView.deselectRow(at: IndexPath(row: i, section: 0), animated: true)
                }
            }
        }
        
        // Update UI for section Last Week (section 1)
        if let lastWeek = self.listOfActivityLastWeek?.count {
            for i in 0..<lastWeek {
                if isSelectAllRow {
                    self.tableView.selectRow(at: IndexPath(row: i, section: 1), animated: true, scrollPosition: .none)
                } else {
                    self.tableView.deselectRow(at: IndexPath(row: i, section: 1), animated: true)
                }
            }
        }
        
        // Update UI for section Older than 2 Weeks (section 2)
        if let other2Weeks = self.listOfActivityOther2Weeks?.count {
            for i in 0..<other2Weeks {
                if isSelectAllRow {
                    self.tableView.selectRow(at: IndexPath(row: i, section: 2), animated: true, scrollPosition: .none)
                } else {
                    self.tableView.deselectRow(at: IndexPath(row: i, section: 2), animated: true)
                }
            }
        }
        
        // Update bar button items in Editing mode
        updateBarButtonItems()
    }
    
    
    // HELPER FUNCTION: Update the Navigation Bar button Items
    // Update button depend on the EDITING MODE and ROWS HAVE SELECTED in Editing mode
    func updateBarButtonItems() {
        
        guard tableView.isEditing == true else {
            // --- EDITING MODE = false ---
            self.navigationItem.leftBarButtonItems = nil
            self.navigationItem.rightBarButtonItem = filterBarButton
            return
        }
        
        guard let indexPathsSelected = self.tableView.indexPathsForSelectedRows, indexPathsSelected.count > 0 else {
            // --- EDITING MODE = true & ROWS  SELECTED = 0 ---
            // Left Bar Button Items: "cancel_filled.png" & "uncheck_all.png"
            selectAllButton.setImage(UIImage.init(named: "uncheck_all"), for: UIControlState.normal)
            selectAllBarButton = UIBarButtonItem.init(customView: selectAllButton)
            self.navigationItem.leftBarButtonItems = [cancelBarButton!, selectAllBarButton!]
            
            // Right Bar Button Items: "trash.png"
            trashButton.setImage(UIImage.init(named: "trash"), for: UIControlState.normal)
            trashBarButton = UIBarButtonItem.init(customView: trashButton)
            self.navigationItem.rightBarButtonItem = trashBarButton
            return
        }
        
        // --- EDITING MODE = true & ROWS  SELECTED > 0 ---
        if indexPathsSelected.count == (self.tableView.numberOfRows(inSection: 0) + self.tableView.numberOfRows(inSection: 1) + self.tableView.numberOfRows(inSection: 2)) {
            // All rows selected
            // Left Bar Button Items: "cancel_filled.png" & "check_all.png"
            self.navigationItem.leftBarButtonItems = [cancelBarButton!, deselectAllBarButton!]
        } else {
            // All rows selected
            // Left Bar Button Items: "cancel_filled.png" & "check_all_filled.png"
            selectAllButton.setImage(UIImage.init(named: "check_all"), for: UIControlState.normal)
            selectAllBarButton = UIBarButtonItem.init(customView: selectAllButton)
            self.navigationItem.leftBarButtonItems = [cancelBarButton!, selectAllBarButton!]
        }
        
        // Right Bar Button Items: "trash_filled.png"
        trashButton.setImage(UIImage.init(named: "trash_filled"), for: UIControlState.normal)
        trashBarButton = UIBarButtonItem.init(customView: trashButton)
        self.navigationItem.rightBarButtonItem = trashBarButton
        
    }
    
    
    // HELPER FUNCTION: Delete selected rows in Editing mode
    func deleteRowsSelectedFromDataBase() {
        print("indexPath selected: \(tableView.indexPathsForSelectedRows.debugDescription)")
        guard let indexPathsSelected = self.tableView.indexPathsForSelectedRows, indexPathsSelected.count > 0 else {
            return
        }
        
        indexPathsDelete.removeAll()
        indexPathsDelete = indexPathsSelected
        
        var listOfDelectingActivities: [ActivityData] = []
        
        // Activity in this week
        if let listOfActivityThisWeek = self.listOfActivityThisWeek {
            let indexPathsSetion0 = indexPathsSelected.filter({ (indexPath) -> Bool in
                indexPath.section == 0
            })
            for i in indexPathsSetion0 {
                listOfDelectingActivities.append(listOfActivityThisWeek[i.row])
            }
        }
        
        // Activity in last week
        if let listOfActivityLastWeek = self.listOfActivityLastWeek {
            let indexPathsSetion1 = indexPathsSelected.filter({ (indexPath) -> Bool in
                indexPath.section == 1
            })
            for i in indexPathsSetion1 {
                listOfDelectingActivities.append(listOfActivityLastWeek[i.row])
            }
        }
        
        // Activity in last 2 weeks
        if let listOfActivityOther2Weeks = self.listOfActivityOther2Weeks {
            let indexPathsSetion2 = indexPathsSelected.filter({ (indexPath) -> Bool in
                indexPath.section == 2
            })
            for i in indexPathsSetion2 {
                listOfDelectingActivities.append(listOfActivityOther2Weeks[i.row])
            }
        }
        
        // Delete all selected activities in Realm database
        try! realm.write {
            for activity in listOfDelectingActivities {
                realm.delete(activity)
            }
        }
        
    }
    
}



// MARK: - DATA FILTER DELEGATE

extension ReportViewController: FilterDataDelegate {
    
    func filterActivity(activities: [ActivityType]?, filterDateType: FilterDateType?, dateCustomFrom: Date?, dateCustomTo: Date?) {
        
        guard let activities = activities, let filterDateType = filterDateType else {
            return
        }
        
        self.activitiesFilterComponent = activities
        self.dateTypeFilterComponent = filterDateType
        self.dateCustomFrom = dateCustomFrom
        self.dateCustomTo = dateCustomTo
        
        filterDataFromDataBase()
    }
    
}



// MARK: - UITABLEVIEW DATASOURCE

extension ReportViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return self.listOfActivityThisWeek?.count ?? 0 > 0 ? 40 : 0
        case 1:
            return self.listOfActivityLastWeek?.count ?? 0 > 0 ? 40 : 0
        case 2:
            return self.listOfActivityOther2Weeks?.count ?? 0 > 0 ? 40 : 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Device.size() < Size.screen4_7Inch {
            // Your device screen is smaller than 4.7 inch
            return 80
        } else {
            // Your device screen is equal or bigger than 4.7 inch
            return 100
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.listOfActivityThisWeek?.count ?? 0
        case 1:
            return self.listOfActivityLastWeek?.count ?? 0
        case 2:
            return self.listOfActivityOther2Weeks?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "Header") as! ReportHeaderCell
        
        switch section {
        case 0:
            headerCell.lbTitle.text = "report_vc_this_week".localized(using: "Localizable")
        case 1:
            headerCell.lbTitle.text = "report_vc_last_week".localized(using: "Localizable")
        case 2:
            headerCell.lbTitle.text = "report_vc_older".localized(using: "Localizable")
        default:
            break
        }
        
        return headerCell.contentView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ReportTableViewCell
        
        switch indexPath.section {
        // Update row for This week section
        case 0:
            if let activityDataThisWeek = listOfActivityThisWeek?[indexPath.row] {
                cell.updateUI(by: activityDataThisWeek)
            }
        // Update row for Last week section
        case 1:
            if let activityDataLastWeek = listOfActivityLastWeek?[indexPath.row] {
                cell.updateUI(by: activityDataLastWeek)
            }
        // Update row for Last 2 weeks section
        case 2:
            if let activityDataOlder2Weeks = listOfActivityOther2Weeks?[indexPath.row] {
                cell.updateUI(by: activityDataOlder2Weeks)
            }
        // Return an empty cell
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
}



// MARK: - UITABLEVIEW DELEGATE

extension ReportViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.isEditing == false {
            self.performSegue(withIdentifier: Common.Segue.goToResultActivityVCFromHistoryVC, sender: nil)
        } else {
            updateBarButtonItems()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        updateBarButtonItems()
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else {
            return
        }
        
        var activitiesData: ActivityData?
        
        switch indexPath.section {
        case 0:
            activitiesData = listOfActivityThisWeek?[indexPath.row]
        case 1:
            activitiesData = listOfActivityLastWeek?[indexPath.row]
        case 2:
            activitiesData = listOfActivityOther2Weeks?[indexPath.row]
        default:
            break
        }
        
        guard let activityData = activitiesData else {
            return
        }
        
        indexPathsDelete.removeAll()
        indexPathsDelete.append(indexPath)
        try! realm.write {
            realm.delete(activityData)
        }
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing == true {
            return UITableViewCellEditingStyle.init(rawValue: 3)!
        } else {
            return .delete
        }
    }
    
    
}



// MARK: - FILTER DATA FROM REALM DATABASE HELPERS
extension ReportViewController {
    
    
    func filterDataByDateTimeAndSection(from results: Results<ActivityData>, reloadUI: Bool) {
        
        getDateTypeFilterComponent(by: dateTypeFilterComponent) { (dateFrom, dateTo) in
            
            self.filterAllFilterComponent(by: dateFrom, dateTo, completion: { (startOfThisWeek, endOfThisWeek, startOfLastWeek, endOfLastWeek, startOfLast2Weeks, endOfLast2Weeks) in
                
                var isThisWeekDataUpdated: Bool = false
                var isLastWeekDataUpdated: Bool = false
                var isLast2WeeksDataUpdated: Bool = false
                
                if isThisWeekDataUpdated == false {
                    // This week data
                    self.getDataForSection(from: results, dateFrom: startOfThisWeek, dateTo: endOfThisWeek, completion: { (thisWeek) in
                        self.listOfActivityThisWeek = thisWeek
                        isThisWeekDataUpdated = true
                        self.refreshUIAfterDataUpdated(reloadUI, after: isThisWeekDataUpdated, isLastWeekDataUpdated, isLast2WeeksDataUpdated)
                        
                    })
                }
                
                if isLastWeekDataUpdated == false {
                    // Last week data
                    self.getDataForSection(from: results, dateFrom: startOfLastWeek, dateTo: endOfLastWeek, completion: { (lastWeek) in
                        self.listOfActivityLastWeek = lastWeek
                        isLastWeekDataUpdated = true
                        self.refreshUIAfterDataUpdated(reloadUI, after: isThisWeekDataUpdated, isLastWeekDataUpdated, isLast2WeeksDataUpdated)
                    })
                }
                
                if isLast2WeeksDataUpdated == false {
                    // Last 2 week data
                    self.getDataForSection(from: results, dateFrom: startOfLast2Weeks, dateTo: endOfLast2Weeks, completion: { (last2Weeks) in
                        self.listOfActivityOther2Weeks = last2Weeks
                        isLast2WeeksDataUpdated = true
                        self.refreshUIAfterDataUpdated(reloadUI, after: isThisWeekDataUpdated, isLastWeekDataUpdated, isLast2WeeksDataUpdated)
                    })
                }
                
            })
            
        }
        
    }
    
    
    func refreshUIAfterDataUpdated(_ isReloadUI: Bool, after thisWeekUpdated: Bool, _ lastWeekUpdated: Bool, _ last2WeeksUpdated: Bool) {
        
        guard isReloadUI && thisWeekUpdated && lastWeekUpdated && last2WeeksUpdated else {
            return
        }
        
        self.tableView.reloadData()
        
    }
    
    
    func getDataForSection(from results: Results<ActivityData>, dateFrom: Date?, dateTo: Date?, completion: @escaping (Results<ActivityData>) -> ()) {
        
        if let dateFrom = dateFrom, let dateTo = dateTo {
            let predicate = NSPredicate(format: "created >= %@ AND created <= %@", dateFrom as CVarArg, dateTo as CVarArg)
            let result = results.filter(predicate)
            completion(result)
            return
        }
        
        if let dateFrom = dateFrom {
            let predicate = NSPredicate(format: "created >= %@", dateFrom as CVarArg)
            let result = results.filter(predicate)
            completion(result)
            return
        }
        
        if let dateTo = dateTo {
            let predicate = NSPredicate(format: "created <= %@", dateTo as CVarArg)
            let result = results.filter(predicate)
            completion(result)
            return
        }
        
    }
    
    
    func filterAllFilterComponent(by dateFrom: Date?, _ dateTo: Date?, completion: @escaping (Date?, Date?, Date?, Date?, Date?, Date?) -> ()) {
        
        
        // Activity of This week
        
        var startOfThisWeek = today.dateFor(.startOfWeek)
        var endOfThisWeek = today.dateFor(.endOfWeek)
        
        if let dateFrom = dateFrom, dateFrom > startOfThisWeek {
            startOfThisWeek = dateFrom
        }
        
        if let dateTo = dateTo, dateTo < endOfThisWeek {
            endOfThisWeek = dateTo
        }
        
        
        // Activity of Last week
        
        var startOfLastWeek = today.dateFor(.startOfLastWeek)
        var endOfLastWeek = today.dateFor(.endOfLastWeek)
        
        if let dateFrom = dateFrom, dateFrom > startOfLastWeek {
            startOfLastWeek = dateFrom
        }
        
        if let dateTo = dateTo, dateTo < endOfLastWeek {
            endOfLastWeek = dateTo
        }
        
        
        // Activity of Older than 2 weeks
        
        var startOfLast2Weeks: Date?
        var endOfLast2Weeks = today.dateFor(.startOfLastWeek).adjust(.second, offset: -1)
        
        
        // Having dateFrom only
        if let dateFrom = dateFrom {
            startOfLast2Weeks = dateFrom
        }
        
        // Having dateTo only
        if let dateTo = dateTo, dateTo < endOfLast2Weeks {
            endOfLastWeek = dateTo
        }
        
        // Having dateFrom and  dateTo
        if let dateFrom = dateFrom, let dateTo = dateTo {
            
            if dateTo <= endOfLast2Weeks {
                startOfLast2Weeks = dateFrom
                startOfLast2Weeks = dateTo
            } else {
                startOfLast2Weeks = dateFrom
                endOfLast2Weeks = today.dateFor(.startOfLastWeek).adjust(.second, offset: -1)
            }
            
        }
        
        
        completion(startOfThisWeek, endOfThisWeek, startOfLastWeek, endOfLastWeek, startOfLast2Weeks, endOfLast2Weeks)
    }
    
    
    func getDateTypeFilterComponent(by  filterDateType: FilterDateType?, completion: @escaping (Date?, Date?) -> ()) {
        
        guard let filterDateType = filterDateType else {
            return
        }
        
        switch filterDateType {
            
        case .allDate: // All time
            completion(nil, nil)
            return
            
        case .thisWeek: // This week
            let dateFrom = today.dateFor(.startOfWeek)
            let dateTo = today.dateFor(.endOfWeek)
            completion(dateFrom, dateTo)
            return
            
        case .thisMonth: // This month
            let dateFrom = today.dateFor(.startOfMonth)
            let dateTo = today.dateFor(.endOfMonth)
            completion(dateFrom, dateTo)
            return
            
        case .thisYear: // This year
            let dateFrom = today.dateFor(.startOfYear)
            let dateTo = today.dateFor(.endOfYear)
            completion(dateFrom, dateTo)
            return
            
        case .customDate: // Custome time
            guard let dateCustomFrom = dateCustomFrom, let dateCustomTo = dateCustomTo else {
                //                completion(nil, nil)
                return
            }
            completion(dateCustomFrom, dateCustomTo)
            return
        }
    }
    
    
    func getPredicateFilterForActivities(by activities: [ActivityType]?) -> String {
        var predicateActivities = ""
        if let activities = activities, activities.isEmpty == false {
            for activity in activities {
                if predicateActivities == "" {
                    predicateActivities = "id = \(activity.rawValue.id)"
                } else {
                    predicateActivities += " OR id = \(activity.rawValue.id)"
                }
            }
        }
        return predicateActivities
    }
    
    
    func deleteRowsAfterUpdatingDatabase() {
        guard self.indexPathsDelete.count > 0 else {
            return
        }
        self.tableView.deleteRows(at: indexPathsDelete, with: .fade)
        
        if (self.listOfActivityThisWeek?.count ?? 0) == 0 {
            self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
        }
        
        if (self.listOfActivityThisWeek?.count ?? 0) == 0 {
            self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
        }
        
        if (self.listOfActivityThisWeek?.count ?? 0) == 0 {
            self.tableView.reloadSections(IndexSet(integer: 2), with: .none)
        }
    }
    
    
}













