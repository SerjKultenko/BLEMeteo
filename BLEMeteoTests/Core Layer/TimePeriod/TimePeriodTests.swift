//
//  TimePeriodTests.swift
//  BLEMeteoTests
//
//  Created by Sergey Kultenko on 05/01/2019.
//  Copyright © 2019 Sergey Kultenko. All rights reserved.
//

import XCTest
@testable import BLEMeteo

class TimePeriodTests: XCTestCase {
    
    var calendar = Calendar(identifier: .gregorian)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTimePeriodTodaySince() {
        // Given
        let period = TimePeriod(period: .today)
        
        // When
        let date = period.dateSince
        
        // Then
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        var todaysComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())

        XCTAssert(components.year == todaysComponents.year)
        XCTAssert(components.month == todaysComponents.month)
        XCTAssert(components.day == todaysComponents.day)
        XCTAssert(components.hour == 0)
        XCTAssert(components.minute == 0)
        XCTAssert(components.second == 0)
    }

    func testTimePeriodTodayTill() {
        // Given
        let period = TimePeriod(period: .today)
        
        // When
        let date = period.dateTill
        
        // Then
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        var todaysComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        
        XCTAssert(components.year == todaysComponents.year)
        XCTAssert(components.month == todaysComponents.month)
        XCTAssert(components.day == todaysComponents.day)
        XCTAssert(components.hour == 23)
        XCTAssert(components.minute == 59)
        XCTAssert(components.second == 59)
    }

    func testTimePeriodThisWeekSince() {
        // Given
        var period = TimePeriod(period: .thisWeek)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let initialDate = dateFormatter.date(from: "2019-01-05")
        period.today = initialDate
        
        // When
        let date = period.dateSince
        
        // Then
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        XCTAssert(components.year == 2018)
        XCTAssert(components.month == 12)
        XCTAssert(components.day == 31)
        XCTAssert(components.hour == 0)
        XCTAssert(components.minute == 0)
        XCTAssert(components.second == 0)
    }

    func testTimePeriodThisWeekTill() {
        // Given
        var period = TimePeriod(period: .thisWeek)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let initialDate = dateFormatter.date(from: "2019-01-05")
        period.today = initialDate
        
        // When
        let date = period.dateTill
        
        // Then
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        XCTAssert(components.year == 2019)
        XCTAssert(components.month == 1)
        XCTAssert(components.day == 6)
        XCTAssert(components.hour == 23)
        XCTAssert(components.minute == 59)
        XCTAssert(components.second == 59)
    }

    func testTimePeriodThisMonthSince() {
        // Given
        var period = TimePeriod(period: .thisMonth)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let initialDate = dateFormatter.date(from: "2019-01-05")
        period.today = initialDate
        
        // When
        let date = period.dateSince
        
        // Then
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        XCTAssert(components.year == 2019)
        XCTAssert(components.month == 1)
        XCTAssert(components.day == 1)
        XCTAssert(components.hour == 0)
        XCTAssert(components.minute == 0)
        XCTAssert(components.second == 0)
    }
    
    func testTimePeriodThisMonthTill() {
        // Given
        var period = TimePeriod(period: .thisMonth)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let initialDate = dateFormatter.date(from: "2019-01-05")
        period.today = initialDate
        
        // When
        let date = period.dateTill
        
        // Then
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        XCTAssert(components.year == 2019)
        XCTAssert(components.month == 1)
        XCTAssert(components.day == 31)
        XCTAssert(components.hour == 23)
        XCTAssert(components.minute == 59)
        XCTAssert(components.second == 59)
    }
    
    func testTimePeriodThisYearSince() {
        // Given
        var period = TimePeriod(period: .thisYear)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let initialDate = dateFormatter.date(from: "2019-01-05")
        period.today = initialDate
        
        // When
        let date = period.dateSince
        
        // Then
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        XCTAssert(components.year == 2019)
        XCTAssert(components.month == 1)
        XCTAssert(components.day == 1)
        XCTAssert(components.hour == 0)
        XCTAssert(components.minute == 0)
        XCTAssert(components.second == 0)
    }
    
    func testTimePeriodThisYearTill() {
        // Given
        var period = TimePeriod(period: .thisYear)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let initialDate = dateFormatter.date(from: "2019-01-05")
        period.today = initialDate
        
        // When
        let date = period.dateTill
        
        // Then
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        XCTAssert(components.year == 2019)
        XCTAssert(components.month == 12)
        XCTAssert(components.day == 31)
        XCTAssert(components.hour == 23)
        XCTAssert(components.minute == 59)
        XCTAssert(components.second == 59)
    }
    
    func testTimePeriodLast7DaysSince() {
        // Given
        var period = TimePeriod(period: .last7Days)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let initialDate = dateFormatter.date(from: "2019-01-05")
        period.today = initialDate
        
        // When
        let date = period.dateSince
        
        // Then
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        XCTAssert(components.year == 2018)
        XCTAssert(components.month == 12)
        XCTAssert(components.day == 30)
        XCTAssert(components.hour == 0)
        XCTAssert(components.minute == 0)
        XCTAssert(components.second == 0)
    }
    
    func testTimePeriodLast7DaysTill() {
        // Given
        var period = TimePeriod(period: .last7Days)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let initialDate = dateFormatter.date(from: "2019-01-05")
        period.today = initialDate
        
        // When
        let date = period.dateTill
        
        // Then
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        XCTAssert(components.year == 2019)
        XCTAssert(components.month == 01)
        XCTAssert(components.day == 5)
        XCTAssert(components.hour == 23)
        XCTAssert(components.minute == 59)
        XCTAssert(components.second == 59)
    }
    
    func testTimePeriodLast30DaysSince() {
        // Given
        var period = TimePeriod(period: .last30Days)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let initialDate = dateFormatter.date(from: "2019-01-05")
        period.today = initialDate
        
        // When
        let date = period.dateSince
        
        // Then
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        XCTAssert(components.year == 2018)
        XCTAssert(components.month == 12)
        XCTAssert(components.day == 7)
        XCTAssert(components.hour == 0)
        XCTAssert(components.minute == 0)
        XCTAssert(components.second == 0)
    }
    
    func testTimePeriodLast30DaysTill() {
        // Given
        var period = TimePeriod(period: .last30Days)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let initialDate = dateFormatter.date(from: "2019-01-05")
        period.today = initialDate
        
        // When
        let date = period.dateTill
        
        // Then
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        XCTAssert(components.year == 2019)
        XCTAssert(components.month == 01)
        XCTAssert(components.day == 5)
        XCTAssert(components.hour == 23)
        XCTAssert(components.minute == 59)
        XCTAssert(components.second == 59)
    }
 
    func testTimePeriodCustomPeriodSince() {
        // Given
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        guard let dateStart = dateFormatter.date(from: "2019-01-05 13:01:54"), let dateEnd = dateFormatter.date(from: "2019-02-25 13:01:54") else {
            XCTFail("TimePeriodTests testTimePeriodCustomPeriodSince Error: Can't create dates")
            return
        }
        let period = TimePeriod(period: .customPeriod(dateStart, dateEnd))
        
        
        // When
        let date = period.dateSince
        
        // Then
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        XCTAssert(components.year == 2019)
        XCTAssert(components.month == 1)
        XCTAssert(components.day == 5)
        XCTAssert(components.hour == 13)
        XCTAssert(components.minute == 1)
        XCTAssert(components.second == 54)
    }
    
    func testTimePeriodCustomPeriodTill() {
        // Given
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let dateStart = dateFormatter.date(from: "2019-01-05 13:01:54"), let dateEnd = dateFormatter.date(from: "2019-02-25 13:01:54") else {
            XCTFail("TimePeriodTests testTimePeriodCustomPeriodSince Error: Can't create dates")
            return
        }
        let period = TimePeriod(period: .customPeriod(dateStart, dateEnd))
        
        
        // When
        let date = period.dateTill
        
        // Then
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        XCTAssert(components.year == 2019)
        XCTAssert(components.month == 2)
        XCTAssert(components.day == 25)
        XCTAssert(components.hour == 13)
        XCTAssert(components.minute == 1)
        XCTAssert(components.second == 54)
    }
    
}
