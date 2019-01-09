//
//  ISensorDataStorage.swift
//  BLEMeteo
//
//  Created by Sergey Kultenko on 09/11/2018.
//  Copyright © 2018 Sergey Kultenko. All rights reserved.
//

import Foundation

import Foundation

protocol ISensorDataStorage {
    func save(sensorDataUnit: SensorDataUnit, completion: @escaping (Error?) -> ())
    func findSensorData(withType type: SensorDataType, from: Date?, till: Date?, completion: @escaping ([SensorDataUnit]) -> ())
    func findSensorData(withType type: SensorDataType, from: Date?, till: Date?, pointsMaxCount: Int, completion: @escaping ([SensorDataUnit]) -> ())
    func removeSensorData(withType type: SensorDataType?, from: Date?, till: Date?, completion: @escaping (Bool) -> ())

    
    // Counting
    func countSensorData(withType type: SensorDataType, from: Date?, till: Date?, completion: @escaping (Int?, Error?) -> ())
}
