//
//  SensorDataUnit.swift
//  BLEMeteo
//
//  Created by Kultenko Sergey on 22/10/2018.
//  Copyright © 2018 Sergey Kultenko. All rights reserved.
//

import Foundation

struct SensorDataUnit {
    
    var type: SensorDataType
    var value: Double
    var timeStamp: Date
    
    init?(fromString string: String, withTimestamp timestamp: Date) {
        guard string.count > 3 else { return nil }
        let idxFrom = string.startIndex
        let idxTo = string.index(string.startIndex, offsetBy: 2)
        let sensorTypeSubstring = string[idxFrom..<idxTo]
        guard let sensorType = SensorDataType(rawValue: String(sensorTypeSubstring))
            else { return nil }
        
        type = sensorType
        
        let index = string.index(string.startIndex, offsetBy: 2)
        let valueStr = string.suffix(from: index)
        if let value = Double(valueStr) {
            self.value = value
        } else {
            return nil
        }
        self.timeStamp = timestamp
    }
    
    init(type: SensorDataType, value: Double, timeStamp: Date) {
        self.type = type
        self.value = value
        self.timeStamp = timeStamp
    }
}
