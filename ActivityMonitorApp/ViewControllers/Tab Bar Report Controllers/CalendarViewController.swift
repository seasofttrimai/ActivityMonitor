//
//  CalendarViewController.swift
//  ActivityMonitorApp
//
//  Created by Seasoft on 9/28/17.
//  Copyright © 2017 Mai Nguyen Quang Tri. All rights reserved.
//

import UIKit
import Localize_Swift

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var lbDateTitle: UILabel!
    @IBOutlet weak var btToday: UIButton!
    
    @IBOutlet weak var lbSunday: UILabel!
    @IBOutlet weak var lbMonday: UILabel!
    @IBOutlet weak var lbTuesday: UILabel!
    @IBOutlet weak var lbWednesday: UILabel!
    @IBOutlet weak var lbThursday: UILabel!
    @IBOutlet weak var lbFriday: UILabel!
    @IBOutlet weak var lbSaturday: UILabel!
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    // MARK: - VARIBALES
    
    var dateSelectedDelegate: DateSelectedDelegate?
    var dateType: DateType?
    var dateSelected: Date = Date()
    
    
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        return dateFormatter
    } ()
    
    
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languageSetting()
        appearanceSetting()
    }
    
    
    
    // MARK: - IB ACTIONS
    
    @IBAction func btTodayTapped(_ sender: Any) {
        self.calendarView.deselectAllDates()
        self.calendarView.reloadData()
        self.calendarView.scrollToDate(Date()) {
            self.calendarView.selectDates([Date()])
        }
    }
    
    
    
    // MARK: - HELPER FUNCTIONS
    
    // Setting language
    func languageSetting() {
        btToday.setTitle("calendar_vc_today_button".localized(using: "Localizable"), for: .normal)
        lbSunday.text = "calendar_vc_sunday".localized(using: "Localizable")
        lbMonday.text = "calendar_vc_monday".localized(using: "Localizable")
        lbTuesday.text = "calendar_vc_tuesday".localized(using: "Localizable")
        lbWednesday.text = "calendar_vc_wednesday".localized(using: "Localizable")
        lbThursday.text = "calendar_vc_thursday".localized(using: "Localizable")
        lbFriday.text = "calendar_vc_friday".localized(using: "Localizable")
        lbSaturday.text = "calendar_vc_saturday".localized(using: "Localizable")
    }
    
    
    // Setting appearance
    func appearanceSetting() {
        
        // Done bar button, reload language notification
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneBarButtonTapped))
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadLaguage), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        
        // Setup calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        // Setup date view
        self.calendarView.scrollToDate(dateSelected, animateScroll: false) {
            self.calendarView.selectDates([self.dateSelected])
        }
        
        // Setup date labels
        calendarView.visibleDates { (visibleDates) in
            self.setupViewOfCalendar(from: visibleDates)
        }
        
    }
    
    
    // Reload language function
    func reloadLaguage() {
        languageSetting()
        calendarView.visibleDates { (visibleDates) in
            self.setupViewOfCalendar(from: visibleDates)
        }
    }
    
    
    // Done button tapped function
    func doneBarButtonTapped() {
        guard let dateType = dateType else {
            return
        }
        dateSelectedDelegate?.setDate(date: dateSelected, dateType: dateType)
        navigationController?.popViewController(animated: true)
    }
    
    
    // Text color for cells function
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCell else {
            return
        }
        
        // Handle days color
        if validCell.isSelected {
            validCell.lbDate.textColor = Common.Color.calendarTextSelectedColor
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.lbDate.textColor = Common.Color.calendarTextIndateMonthColor
            } else {
                validCell.lbDate.textColor = Common.Color.calendarTextOutdateMonthColor
            }
        }
        
        // Handle today color
        formatter.dateFormat = "yyyy MM dd"
        let todayDateString = formatter.string(from: Date())
        let monthDateString = formatter.string(from: cellState.date)
        
        if todayDateString == monthDateString {
            validCell.lbDate.textColor = Common.Color.calendarTextSelectedColor
        }
        
    }
    
    
    // Selected for cells function
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCell else {
            return
        }
        if validCell.isSelected {
            validCell.imgSelectedDate.isHidden = false
        } else {
            validCell.imgSelectedDate.isHidden = true
        }
    }
    
    
    // Set up label date showing function
    func setupViewOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let date = visibleDates.monthDates.first?.date else {
            return
        }
        lbDateTitle.text = date.localizedMonth()
    }
    
}



// MARK: - JTAPPLECALENDAR DATASOURCE

extension CalendarViewController: JTAppleCalendarViewDataSource {
    
    // Configure for Calendar
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2027 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
    
    // Calendar cell showing
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "Cell", for: indexPath) as! CalendarCell
        
        if cellState.dateBelongsTo == .thisMonth {
            cell.lbDate.text = cellState.text
            handleCellTextColor(view: cell, cellState: cellState)
            // Make sure selected view in cell is not reuse when selecting the day
            handleCellSelected(view: cell, cellState: cellState)
        } else {
            cell.lbDate.text = ""
            cell.imgSelectedDate.isHidden = true
        }
        
        return cell
    }
    
}




// MARK: - JTAPPLECALENDAR DELEGATE

extension CalendarViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewOfCalendar(from: visibleDates)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard cellState.dateBelongsTo == .thisMonth else {
            return
        }
        
        if let dateType = dateType {
            switch dateType {
            case .from:
                dateSelected = date.dateFor(.startOfDay)
            case .to:
                dateSelected = date.dateFor(.endOfDay)
            }
        }
        
        dateSelected = date
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelected(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelected(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
}
