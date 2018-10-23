//
//  SensorData.swift
//  BLEMeteo
//
//  Created by Kultenko Sergey on 21/10/2018.
//  Copyright © 2018 Sergey Kultenko. All rights reserved.
//

import Foundation

class SensorData {
    
    private var points: [(timestamp: Date, value: Double)] = []
    
    var pointsNumber: Int {
        return points.count
    }
    
    func valueForPoint(withIndex index: Int) -> Double? {
        guard index >= 0, index < points.count else { return nil }
        return points[index].value
    }
    
    func appendPoint(atTimeStamp timestamp: Date, withValue value: Double) {
        points.append((timestamp, value))
    }
    
    func clearAllPoints() {
        points.removeAll()
    }
    
    func generateRandomData(_ numberOfItems: Int, max: Double, inTimeIntervalTillNow timeInterval: TimeInterval, shouldIncludeOutliers: Bool = true) {
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
    }
}
