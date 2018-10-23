//
//  SensorData.swift
//  BLEMeteo
//
//  Created by Kultenko Sergey on 21/10/2018.
//  Copyright © 2018 Sergey Kultenko. All rights reserved.
//

import Foundation

class SensorData {
    
    private var points: [Double] = []
    
    var pointsNumber: Int {
        return points.count
    }
    
    func valueForPoint(withIndex index: Int) -> Double? {
        guard index >= 0, index < points.count else { return nil }
        return points[index]
    }
    
    func appendPoint(withValue value: Double) {
        points.append(value)
    }
    
    func clearAllPoints() {
        points.removeAll()
    }
    
    func generateRandomData(_ numberOfItems: Int, max: Double, shouldIncludeOutliers: Bool = true) {
        var data = [Double]()
        for _ in 0 ..< numberOfItems {
            var randomNumber = Double(arc4random()).truncatingRemainder(dividingBy: max)
            
            if(shouldIncludeOutliers) {
                if(arc4random() % 100 < 10) {
                    randomNumber *= 3
                }
            }
            
            data.append(randomNumber)
        }
        points = data
    }
}
