//
//  SensorDataUnit.swift
//  BLEMeteo
//
//  Created by Kultenko Sergey on 22/10/2018.
//  Copyright © 2018 Sergey Kultenko. All rights reserved.
//

import Foundation

struct SensorDataUnit {
    enum SensorDataUnitType: Character {
        case temperature = "T"
        case humidity = "H"
    }
    var type: SensorDataUnitType
    var value: Double
    
    init?(fromString string: String) {
        guard let sensorChar = string.first, let sensorType = SensorDataUnitType(rawValue: sensorChar)
            else { return nil }
        
        type = sensorType
        
        let index = string.index(string.startIndex, offsetBy: 1)
        let valueStr = string.suffix(from: index)
        if let value = Double(valueStr) {
            self.value = value
        } else {
            return nil
        }
    }
}
