//
//  SensorData.swift
//  BLEMeteo
//
//  Created by Kultenko Sergey on 21/10/2018.
//  Copyright © 2018 Sergey Kultenko. All rights reserved.
//

import Foundation

class SensorDataSet {
    
    // MARK: - Vars
    var type: SensorDataType
    
    //var sensorDataStorage: ISensorDataStorage?
    var pointsMaxNumber: Int = 500
    
    private let lock: NSLock = NSLock()
    private var points: [(timestamp: Date, value: Double)] = []
    
    var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumIntegerDigits = 1
        return numberFormatter
    }()
    
    var pointsNumber: Int {
        lock.lock()
        let count = points.count
        lock.unlock()
        return count
    }
    
    func minTimeStamp() -> Date? {
        lock.lock()
        let result = points.min { (lhs, rhs) -> Bool in
            return lhs.timestamp < rhs.timestamp
        }?.timestamp
        lock.unlock()
        return result
    }

    func maxTimeStamp() -> Date? {
        lock.lock()
        let result = points.max { (lhs, rhs) -> Bool in
            return lhs.timestamp < rhs.timestamp
            }?.timestamp
        lock.unlock()
        return result
    }

    func valueForPoint(withIndex index: Int) -> Double? {
        guard index >= 0, index < points.count else { return nil }
        lock.lock()
        let result = points[index].value
        lock.unlock()
        return result
    }

    func timestampForPoint(withIndex index: Int) -> Date? {
        guard index >= 0, index < points.count else { return nil }
        lock.lock()
        let result = points[index].timestamp
        lock.unlock()
        return result
    }
    
    /*func appendPoint(atTimeStamp timestamp: Date, withValue value: Double) {
        lock.lock()
        points.append((timestamp, value))
        lock.unlock()
    }*/
    
    func setData(withPoints points: [(timestamp: Date, value: Double)]) {
        lock.lock()
        self.points = points
        lock.unlock()
    }
    
    func clearAllPoints() {
        lock.lock()
        points.removeAll()
        lock.unlock()
    }
    
    func fillWithRandomData(_ numberOfItems: Int, max: Double, inTimeIntervalTillNow timeInterval: TimeInterval, shouldIncludeOutliers: Bool = true) {
        lock.lock()
        var data = [(timestamp: Date, value: Double)]()
        let period = timeInterval / Double(numberOfItems)
        let initialTime = Date().addingTimeInterval( 0 - timeInterval)
        for i in 0 ..< numberOfItems {
            let time = initialTime.addingTimeInterval(Double(i) * period)
            var randomNumber = Double(arc4random()).truncatingRemainder(dividingBy: max)
            
            if(shouldIncludeOutliers) {
                if(arc4random() % 100 < 10) {
                    randomNumber *= 3
                }
            }
            
            data.append((timestamp: time, value: randomNumber))
        }
        points = data
        lock.unlock()
    }
    
    
    // MARK: - Initialization
    init(type: SensorDataType) {
        self.type = type
    }
}
