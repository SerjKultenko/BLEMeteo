//
//  DashBoardViewModel.swift
//  BLEMeteo
//
//  Created by Kultenko Sergey on 19/10/2018.
//  Copyright © 2018 Sergey Kultenko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DashBoardViewModel: BaseViewModel {
    
    private var appState: StateStorage
    private var btService: BTConnectionService = BTConnectionService()
    private var sensorDataStorage: ISensorDataStorage = SensorCoreDataStorage()
    
    // MARK: - Vars
    var timePeriod = BehaviorRelay<TimePeriod>(value: TimePeriod(period: .today))
    var reloadDataSignal = BehaviorSubject<Int>(value: -1)
    
    var sensorsData: [SensorDataSet] = [SensorDataSet(type: .temperature),
                                        SensorDataSet(type: .humidity),
                                        SensorDataSet(type: .pressure),
                                        SensorDataSet(type: .temperatureBMP280),
                                        SensorDataSet(type: .carbonDioxidePPM)]
    
    var sensorsCount: Int {
        return sensorsData.count
    }

    private let sensorNames: [String] = ["Temperature ºC", "Humidity %", "Pressure Pa", "Temperature BMP280 ºC", "Carbon Dioxide PPM"]
    func sensorName(forIndex index: Int) -> String {
        guard index >= 0, index < sensorNames.count else { return "" }
        return sensorNames[index]
    }
    
    func sensor(withIndex index: Int) -> SensorDataSet? {
        guard index >= 0, index < sensorsData.count else { return nil }
        return sensorsData[index]
    }
    
    private func getSensorIndex(forSensorType type: SensorDataType) -> Int {
        switch type {
        case .temperature:
            return 0
        case .humidity:
            return 1
        case .pressure:
            return 2
        case .temperatureBMP280:
            return 3
        case .carbonDioxidePPM:
            return 4
        }
    }
    
    // MARK: - Initialization
    init(withRouter router: IRouter, appState: StateStorage) {
        self.appState = appState
        super.init(with: router)
        sensorsData[2].numberFormatter.locale = NSLocale.current
        sensorsData[2].numberFormatter.numberStyle = NumberFormatter.Style.decimal
        sensorsData[2].numberFormatter.usesGroupingSeparator = true
        sensorsData[2].numberFormatter.maximumFractionDigits = 0

        btService.setupService {[weak self] (error, sensorData) in
            guard let safeSelf = self else { return }
            if error != nil {
                if let btServiceError = error as? BTConnectionServiceError, btServiceError == .bluetoothStatusUnsuported {
                    //safeSelf.generateFakeHistoryData()
                }
            } else {
                if let sensorData = sensorData {
                    safeSelf.didReceive(sensorData: sensorData)
                }
            }
        }
        
        timePeriod.subscribe(onNext: { [weak self] (period) in
            self?.reloadAllSensorsData()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Utilites
    
    private func reloadAllSensorsData() {
        for sensor in sensorsData {
            reloadSensorData(withType: sensor.type)
        }
    }

    
    private func generateFakeHistoryData() {
        let fakeDataGenerator = FakeDataGenerator(sensorTypes: [.temperature, .humidity, .pressure, .temperatureBMP280, .carbonDioxidePPM], sensorDataStorage: sensorDataStorage)
        let dateTill = Date()
        let dateFrom = dateTill.addingTimeInterval(-30*24*60*60)
        fakeDataGenerator.generateHistoryData(dateFrom: dateFrom, dateTill: dateTill)
    }

    private func setupSensorsWithFakeData() {
        sensorsData[0].fillWithRandomData(100, max: 100, inTimeIntervalTillNow: TimeInterval(24 * 60 * 4), shouldIncludeOutliers: true)
        sensorsData[1].fillWithRandomData(60, max: 40, inTimeIntervalTillNow: TimeInterval(24 * 60 * 4), shouldIncludeOutliers: true)
        sensorsData[2].fillWithRandomData(24*60, max: 60, inTimeIntervalTillNow: TimeInterval(24 * 60 * 60), shouldIncludeOutliers: true)
    }
    
    private func didReceive(sensorData: SensorDataUnit) {
        sensorDataStorage.save(sensorDataUnit: sensorData, completion: {[weak self] (error) in
            guard let safeSelf = self, safeSelf.timePeriod.value.dateBelongsToPeriod(date: sensorData.timeStamp) == true  else { return }
            
            safeSelf.reloadSensorData(withType: sensorData.type)
        })
        
    }
    
    private func reloadSensorData(withType type: SensorDataType) {
        let sensorIndex = getSensorIndex(forSensorType: type)
        let sensorDataSet = sensorsData[sensorIndex]

        sensorDataStorage.findSensorData(withType: type,
                                                  from: timePeriod.value.dateSince,
                                                  till: timePeriod.value.dateTill,
                                                  pointsMaxCount: sensorDataSet.pointsMaxNumber,
                                                  completion:
            { [weak self] (sensorDataArray) in
                let pointsData: [(timestamp: Date, value: Double)] = sensorDataArray.map({ (sensorDataUnit) -> (timestamp: Date, value: Double) in
                    return (sensorDataUnit.timeStamp, sensorDataUnit.value)
                })
                
                sensorDataSet.setData(withPoints: pointsData)
                DispatchQueue.main.async {
                    self?.reloadDataSignal.onNext(sensorIndex)
                }
        })

    }
    
}
