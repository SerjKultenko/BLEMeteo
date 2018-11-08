//
//  DashBoardViewModel.swift
//  BLEMeteo
//
//  Created by Kultenko Sergey on 19/10/2018.
//  Copyright © 2018 Sergey Kultenko. All rights reserved.
//

import Foundation
import RxSwift

class DashBoardViewModel: BaseViewModel {
    
    private var appState: StateStorage
    private var btService: BTConnectionService = BTConnectionService()
    
    // MARK: - Vars
    var reloadDataSignal = BehaviorSubject<Bool>(value: false)
    
    var sensorsData: [SensorData] = [SensorData(), SensorData(), SensorData(), SensorData(), SensorData()]
    
    var sensorsCount: Int {
        return sensorsData.count
    }

    private let sensorNames: [String] = ["Temperature", "Humidity", "Pressure", "Temperature BMP280", "Carbon Dioxide PPM"]
    func sensorName(forIndex index: Int) -> String {
        guard index >= 0, index < sensorNames.count else { return "" }
        return sensorNames[index]
    }
    
    func sensor(withIndex index: Int) -> SensorData? {
        guard index >= 0, index < sensorsData.count else { return nil }
        return sensorsData[index]
    }
    
    // MARK: - Initialization
    init(withRouter router: IRouter, appState: StateStorage) {
        self.appState = appState
        super.init(with: router)
        //sensorsData[0].fillWithRandomData(100, max: 100, shouldIncludeOutliers: true)
        //sensorsData[1].fillWithRandomData(60, max: 40, shouldIncludeOutliers: false)
        //sensorsData[2].fillWithRandomData(24*60, max: 60, inTimeIntervalTillNow: TimeInterval(24 * 60 * 60), shouldIncludeOutliers: true)
        btService.setupService {[weak self] (sensorData) in
            guard let safeSelf = self else { return }
            switch sensorData.type {
            case .temperature:
                safeSelf.sensorsData[0].appendPoint(atTimeStamp: sensorData.timeStamp, withValue: sensorData.value)
                safeSelf.reloadDataSignal.onNext(true)
            case .humidity:
                safeSelf.sensorsData[1].appendPoint(atTimeStamp: sensorData.timeStamp, withValue: sensorData.value)
                safeSelf.reloadDataSignal.onNext(true)
            case .pressure:
                safeSelf.sensorsData[2].appendPoint(atTimeStamp: sensorData.timeStamp, withValue: sensorData.value)
                safeSelf.reloadDataSignal.onNext(true)
            case .temperatureBMP280:
                safeSelf.sensorsData[3].appendPoint(atTimeStamp: sensorData.timeStamp, withValue: sensorData.value)
                safeSelf.reloadDataSignal.onNext(true)
            case .carbonDioxidePPM:
                safeSelf.sensorsData[4].appendPoint(atTimeStamp: sensorData.timeStamp, withValue: sensorData.value)
                safeSelf.reloadDataSignal.onNext(true)
            //default:
            //    break
            }
        }
    }
}
