//
//  FakeDataGenerator.swift
//  BLEMeteo
//
//  Created by Sergey Kultenko on 22/03/2019.
//  Copyright © 2019 Sergey Kultenko. All rights reserved.
//

import Foundation

class FakeDataGenerator {
    
    // MARK: - Vars
    var sensorTypes: [SensorDataType]
    var sensorDataStorage: ISensorDataStorage
    var timeInterval: TimeInterval = 20.0

    private var generatorQueue = DispatchQueue.global(qos: .utility)
    private var hystoryCeneratorCount = 0

    // MARK: - Initialization
    init(sensorTypes: [SensorDataType], sensorDataStorage: ISensorDataStorage) {
        self.sensorTypes = sensorTypes
        self.sensorDataStorage = sensorDataStorage
    }
    
    // MARK: - Public functions
    func generateHistoryData(dateFrom: Date, dateTill: Date) {
        guard dateTill > dateFrom else {
            print("History generation finished")
            return
        }
        generatorQueue.async {
            self.generateOneDataSet(forTimeStamp: dateFrom, completion: {
                self.hystoryCeneratorCount += 1
                print("Hystory generator - \(self.hystoryCeneratorCount)")
                self.generateHistoryData(dateFrom: dateFrom + self.timeInterval, dateTill: dateTill)
            })

        }
    }
    
    func startGenerate() {
        generationCycle()
    }

    
    // MARK: - Private functions

    private func generationCycle() {
        let timeInterval = self.timeInterval
        generateOneDataSet(forTimeStamp: Date(), completion: {
            self.generatorQueue.asyncAfter(deadline: .now() + timeInterval) {
                self.generationCycle()
            }
        })
    }
    
    private func generateOneDataSet(forTimeStamp timeStamp: Date, completion: (() -> Void)? = nil ) {
        let  dispatchGroup = DispatchGroup()
        for type in sensorTypes {
            dispatchGroup.enter()
            let dataUnit = generateSensorDataUnit(withType: type, timeStamp: timeStamp)
            sensorDataStorage.save(sensorDataUnit: dataUnit) { (error) in
                dispatchGroup.leave()
                if error != nil {
                    print("Fake sensor data generator error: \(String(describing: error))")
                }
            }
        }
        dispatchGroup.notify(queue: generatorQueue) {
            completion?()
        }
    }
    
    private func generateSensorDataUnit(withType type: SensorDataType, timeStamp: Date) -> SensorDataUnit {
        var minValue: Double = 0.0
        let maxValue: Double
        switch type {
        case .temperature:
            minValue = 15
            maxValue = 40
        case .humidity:
            maxValue = 758
        case .pressure:
            maxValue = 900
        case .temperatureBMP280:
            minValue = 15
            maxValue = 40
        case .carbonDioxidePPM:
            maxValue = 500
        }
        let randomNumber = minValue + Double(arc4random()).truncatingRemainder(dividingBy: maxValue - minValue)
        
        let generatedData = SensorDataUnit(type: type, value: randomNumber, timeStamp: timeStamp)
        return generatedData
    }
        
}
