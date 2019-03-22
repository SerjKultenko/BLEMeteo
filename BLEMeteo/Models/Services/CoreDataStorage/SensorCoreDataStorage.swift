//
//  SensorCoreDataStorage.swift
//  BLEMeteo
//
//  Created by Sergey Kultenko on 09/11/2018.
//  Copyright © 2018 Sergey Kultenko. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class SensorCoreDataStorage: ISensorDataStorage {
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    // MARK: - ISensorDataStorage
    
    func save(sensorDataUnit: SensorDataUnit, completion: @escaping (Error?) -> ()) {
        container?.performBackgroundTask { context in
            do {
                _ = SensorDataEntity.saveDTOToSensorDataEntity(sensorData: sensorDataUnit, in: context)
                try context.save()
            } catch {
                completion(error)
                return
            }
            completion(nil)
        }

    }
    
    func findSensorData(withType type: SensorDataType, from: Date?, till: Date?, completion: @escaping ([SensorDataUnit]) -> ()) {
        container?.performBackgroundTask { [weak self] context in
            let request: NSFetchRequest<SensorDataEntity> = SensorDataEntity.fetchRequest()
            request.predicate = self?.getPredicateForConditions(type: type, from: from, till: till)

            var foundSensorData = [SensorDataUnit]()
            do {
                let requestResult = try context.fetch(request)
                if requestResult.count > 0 {
                    for sensorDataEntity in requestResult {
                        try foundSensorData.append(sensorDataEntity.createDTO())
                    }
                }
            } catch {
                completion([])
            }
            completion(foundSensorData)
        }
    }

    func findSensorData(withType type: SensorDataType, from: Date?, till: Date?, pointsMaxCount: Int, completion: @escaping ([SensorDataUnit]) -> ()) {
        container?.performBackgroundTask { [weak self] context in
            let request: NSFetchRequest<SensorDataEntity> = SensorDataEntity.fetchRequest()
            request.predicate = self?.getPredicateForConditions(type: type, from: from, till: till)
            request.sortDescriptors = [
                NSSortDescriptor(key: "timestamp", ascending: true),
            ]
            
            var foundSensorData = [SensorDataUnit]()
            do {
                let requestResult = try context.fetch(request)
                if requestResult.count > 0 {
                    if requestResult.count > pointsMaxCount {
                            foundSensorData = self?.reduceSensorData(sensorData: requestResult, datefrom: from, datetill: till, pointsMaxCount: pointsMaxCount) ?? []
                    } else {
                        for sensorDataEntity in requestResult {
                            try foundSensorData.append(sensorDataEntity.createDTO())
                        }
                    }
                }
            } catch {
                completion([])
            }
            completion(foundSensorData)
        }
    }
    
    private func reduceSensorData(sensorData: [SensorDataEntity], datefrom: Date?, datetill: Date?, pointsMaxCount: Int) -> [SensorDataUnit] {
        guard let startDate = datefrom ?? sensorData.first?.timestamp, let endDate = datetill ?? sensorData.last?.timestamp else {
            return []
        }
        guard let typeString = sensorData.first?.type, let sensorDataType = SensorDataType(rawValue: typeString) else {
            return []
        }
        var result = [SensorDataUnit]()
        var pointsCount = 0
        var accumulator = 0.0
        let dateStep = endDate.timeIntervalSince(startDate) / Double(pointsMaxCount)
        var nextPeriodThreshold: Date = startDate.addingTimeInterval(dateStep)
        for sensorDataEntity in sensorData {
            if let time = sensorDataEntity.timestamp, time > nextPeriodThreshold {
                let pointTime = nextPeriodThreshold.addingTimeInterval(-dateStep/2.0)
                result.append(SensorDataUnit(type: sensorDataType, value: accumulator / Double(pointsCount), timeStamp: pointTime))
                
                nextPeriodThreshold = nextPeriodThreshold.addingTimeInterval(dateStep)
                accumulator = 0.0
                pointsCount = 0
            }
            accumulator += sensorDataEntity.value
            pointsCount += 1
        }
        return result
    }

    
    // Counting
    func countSensorData(withType type: SensorDataType, from: Date?, till: Date?, completion: @escaping (Int?, Error?) -> ()) {
        container?.performBackgroundTask { [weak self ] context in
            let request: NSFetchRequest<SensorDataEntity> = SensorDataEntity.fetchRequest()
            request.predicate = self?.getPredicateForConditions(type: type, from: from, till: till)
            
            do {
                let recordsCount = try context.count(for: request)
                completion(recordsCount, nil)
            } catch {
                completion(nil, error)
            }
        }

    }

    func removeSensorData(withType type: SensorDataType?, from: Date?, till: Date?, completion: @escaping (Bool) -> ()) {
        container?.performBackgroundTask { [weak self ] context in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SensorDataEntity")
            request.predicate = self?.getPredicateForConditions(type: type, from: from, till: till)

            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            
            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                completion(false)
            }
            completion(true)
        }
    }

    // MARK: - Utilities
    
    private func getPredicateForConditions(type: SensorDataType?, from: Date?, till: Date?) -> NSPredicate {
        var predicates = [NSPredicate]()
        if let type = type {
            predicates.append(NSPredicate(format: "type = %@", type.rawValue))
        }
        if from != nil {
            predicates.append(NSPredicate(format: "timestamp >= %@", from! as NSDate))
        }
        if till != nil {
            predicates.append(NSPredicate(format: "timestamp <= %@", till! as NSDate))
        }
        if predicates.count == 0 {
            return NSPredicate(value: true)
        } else {
            return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
    }

}
