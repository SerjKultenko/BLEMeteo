//
//  SensorDataEntity+CoreDataClass.swift
//  BLEMeteo
//
//  Created by Sergey Kultenko on 09/11/2018.
//  Copyright © 2018 Sergey Kultenko. All rights reserved.
//
//

import Foundation
import CoreData

@objc(SensorDataEntity)
public class SensorDataEntity: NSManagedObject {
    class func saveDTOToSensorDataEntity(sensorData: SensorDataUnit, in context: NSManagedObjectContext) -> SensorDataEntity {
        // We dont check whether we already have that data or not
        let sensorDataEntity = SensorDataEntity(context: context)
        sensorDataEntity.setupFromDTO(sensorDataDTO: sensorData)
        return sensorDataEntity
    }
    
    func setupFromDTO(sensorDataDTO sensorData: SensorDataUnit) {
        type = sensorData.type.rawValue
        value = sensorData.value
        timestamp = sensorData.timeStamp
    }
    
    func createDTO() throws -> SensorDataUnit {
        guard let typeString = self.type, let type = SensorDataType(rawValue: typeString), let timeStamp = self.timestamp
            else {
                throw ErrorWithNote(description: "Can't create SensorDataUnit. Data in DB is not consistent.")
        }
        return SensorDataUnit(type: type, value: self.value, timeStamp: timeStamp)
    }
}
