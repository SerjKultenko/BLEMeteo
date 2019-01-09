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
                    safeSelf.sensorsData[0].fillWithRandomData(100, max: 100, inTimeIntervalTillNow: TimeInterval(24 * 60 * 4), shouldIncludeOutliers: true)
                    safeSelf.sensorsData[1].fillWithRandomData(60, max: 40, inTimeIntervalTillNow: TimeInterval(24 * 60 * 4), shouldIncludeOutliers: true)
                    safeSelf.sensorsData[2].fillWithRandomData(24*60, max: 60, inTimeIntervalTillNow: TimeInterval(24 * 60 * 60), shouldIncludeOutliers: true)
                }
            } else {
                guard let sensorData = sensorData else { return }
                safeSelf.sensorDataStorage.save(sensorDataUnit: sensorData, completion: {[weak self] (error) in
                    guard let safeSelf = self, safeSelf.timePeriod.value.dateBelongsToPeriod(date: sensorData.timeStamp) == true  else { return }
                    
                    let sensorIndex = safeSelf.getSensorIndex(forSensorType: sensorData.type)
                    let sensorDataSet = safeSelf.sensorsData[sensorIndex]
                    
                    safeSelf.sensorDataStorage.findSensorData(withType: sensorData.type,
                                                              from: safeSelf.timePeriod.value.dateSince,
                                                              till: safeSelf.timePeriod.value.dateTill,
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
                })
            }
        }
    }
}
