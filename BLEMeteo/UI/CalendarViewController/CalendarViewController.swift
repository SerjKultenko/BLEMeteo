//
//  CalendarViewController.swift
//  BLEMeteo
//
//  Created by Sergey Kultenko on 13/03/2019.
//  Copyright © 2019 Sergey Kultenko. All rights reserved.
//

import UIKit
import CrispyCalendar

protocol CalendarCustomDateRangeProtocol: class {
    func didSelectDateRange(_ dateRange: CountableRange <CPCDay>)
}

class CalendarViewController: UIViewController {

    @IBOutlet weak var weekView: CPCWeekView!
    @IBOutlet weak var calendarView: CPCCalendarView!
    
    private var selectedDays: CountableRange <CPCDay> = .today ..< .today {
        didSet {
            delegate?.didSelectDateRange(selectedDays)
        }
    }
//    var selection: CPCViewSelection = .range(.today ..< .today) { //.unordered ([])/*.range(.today ..< .today)*/ {
//        didSet {
//            print(selection)
//        }
//    }

    weak var delegate: CalendarCustomDateRangeProtocol?
    
    var selection: CPCViewSelection { //.unordered ([])/*.range(.today ..< .today)*/ {
        get {
            return .range(selectedDays)
        }
        set {
            switch newValue {
            case .range(let selectedRange):
                selectedDays = selectedRange
            default:
                break
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        weekView.backgroundColor = .gray;
        
        let weekViewLayer = weekView.layer;
        weekViewLayer.shadowColor = UIColor (white: 0.0, alpha: 1.0).cgColor;
        weekViewLayer.shadowOpacity = 0.1;
        weekViewLayer.shadowRadius = 8.0;
        weekViewLayer.shadowOffset = .zero;
        
        calendarView.columnCount = 1
        calendarView.selectionDelegate = self
        calendarView.allowsSelection = true
    }

}

extension CalendarViewController: CPCCalendarViewSelectionDelegate {

    func calendarView (_ calendarView: CPCCalendarView, shouldSelect day: CPCDay) -> Bool {
        let newRange: CountableRange <CPCDay>;
        if (self.selectedDays.count == 1) {
            let selectedDay = self.selectedDays.lowerBound;
            if (day < selectedDay) {
                newRange = day ..< selectedDay.next;
            } else {
                newRange = selectedDay ..< day.next;
            }
        } else {
            newRange = day ..< day.next;
        }
        
        selectedDays = newRange
        return true
    }
    
    func calendarView (_ calendarView: CPCCalendarView, shouldDeselect day: CPCDay) -> Bool {
        let newRange: CountableRange <CPCDay>;
        if (self.selectedDays.count > 1) {
            newRange = day ..< self.selectedDays.upperBound;
        } else {
            newRange = day ..< day.next;
        }
        selectedDays = newRange
        return true
    }
}

extension CPCDay {
    var date: Date? {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        let dateComponents = DateComponents(calendar: calendar, year: self.year, month: self.month, day: self.day)
        return dateComponents.date
    }
}
