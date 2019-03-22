//
//  TimePeriod.swift
//  BLEMeteo
//
//  Created by Sergey Kultenko on 28/12/2018.
//  Copyright © 2018 Sergey Kultenko. All rights reserved.
//

import Foundation

struct TimePeriod {
    enum TimePeriodType {
        case today
        case thisWeek
        case thisMonth
        case thisYear
        case last7Days
        case last30Days
        case customPeriod(Date, Date)
    }
    
    static var calendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        return calendar
    }()
        
    
    var type: TimePeriodType
    
    var today: Date?

    var dateSince: Date {
        let calendar = TimePeriod.calendar
        let today = self.today ?? Date()
        
        switch type {
        case .today:
            if let dateInterval = calendar.dateInterval(of: .day, for: today) {
                return dateInterval.start
            }
        case .thisWeek:
            let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)
            return calendar.date(from: components) ?? today
        case .thisMonth:
            let components = calendar.dateComponents([.year, .month], from: today)
            return calendar.date(from: components) ?? today
        case .thisYear:
            let components = calendar.dateComponents([.year], from: today)
            return calendar.date(from: components) ?? today
        case .last7Days:
            if let date = calendar.date(byAdding: .day, value: -6, to: today), let dateInterval = calendar.dateInterval(of: .day, for: date) {
                return dateInterval.start
            }
        case .last30Days:
            if let date = calendar.date(byAdding: .day, value: -29, to: today), let dateInterval = calendar.dateInterval(of: .day, for: date) {
                return dateInterval.start
            }
        case .customPeriod(let dateSince, _):
            return dateSince
        }

        // Return Today if something goes wrong
        return today
    }
    
    var dateTill: Date {
        let calendar = TimePeriod.calendar
        let today = self.today ?? Date()
        
        switch type {
        case .today, .last7Days, .last30Days:
            if let dateInterval = calendar.dateInterval(of: .day, for: today) {
                return Date(timeInterval: dateInterval.duration - 1, since: dateInterval.start)
            }
        case .thisWeek:
            if let dateInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
                return Date(timeInterval: dateInterval.duration - 1, since: dateInterval.start)
            }
        case .thisMonth:
            if let dateInterval = calendar.dateInterval(of: .month, for: today) {
                return Date(timeInterval: dateInterval.duration - 1, since: dateInterval.start)
            }
        case .thisYear:
            if let dateInterval = calendar.dateInterval(of: .year, for: today) {
                return Date(timeInterval: dateInterval.duration - 1, since: dateInterval.start)
            }
        case .customPeriod(_, let dateTill):
            return dateTill
        }
        
        // Return Today if something goes wrong
        return today
    }
    
    func dateBelongsToPeriod(date: Date) -> Bool {
        return dateSince <= date && dateTill >= date
    }
    
    var description: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none

        switch type {
        case .today:
            return "Today"
        case .last7Days, .last30Days, .thisWeek, .thisMonth, .thisYear:
            return dateFormatter.string(from: dateSince) + " - " + dateFormatter.string(from: dateTill)
        case .customPeriod(let dateSince, let dateTill):
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            return dateFormatter.string(from: dateSince) + " - " + dateFormatter.string(from: dateTill)
        }
    }
    
    // MARK: - Initialization
    
    init(period: TimePeriodType) {
        self.type = period
    }
}

