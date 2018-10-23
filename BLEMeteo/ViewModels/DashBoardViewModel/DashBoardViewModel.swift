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
    
    var sensorsData: [SensorData] = [SensorData(), SensorData(), SensorData()]
    
    var sensorsCount: Int {
        return 3
    }
    
    private let sensorNames: [String] = ["Temperature", "Humidity", "Pressure"]
    func sensorName(forIndex index: Int) -> String {
        guard index >= 0, index < sensorNames.count else { return "" }
        return sensorNames[index]
    }
    
    func sensor(withIndex index: Int) -> SensorData? {
        guard index >= 0, index < sensorsData.count else { return nil }
        return sensorsData[index]
    }
    
//    func pointsNumber(inSensorWithIndex index: Int) -> Int {
//        guard let sensor = sensor(withIndex: index) else { return 0 }
//        return sensor.pointsNumber
//    }
//
//    func value(forPointWithIndex pointIndex: Int, inSensor index: Int) -> Double? {
//        guard let sensor = sensor(withIndex: index) else { return nil }
//        return sensor.valueForPoint(withIndex: pointIndex)
//    }
    
/*    var presetUpdated: PublishSubject<GeneratorPreset> {
        return appState.currPresetUpdated
    }
    
    // MARK: - Utilities
    
    
    // MARK: - Actions
    func reloadData() {
        showHUDSignal.onNext(true)
        
        DispatchQueue.global().async { [weak self] in
            guard let safeSelf = self else { return }
            
            var units = [LanguageUnit]()
            for generator in safeSelf.appState.currentPreset.generators {
                if generator.active {
                    units.append(contentsOf: generator.generate())
                }
            }
            safeSelf.languageUnits = units
            safeSelf.showHUDSignal.onNext(false)
        }
    }
    
    func changePreset() {
        router.route(with: MainScreenRouter.RouteType.changePreset, animated: true, completion: nil)
    }
    */
    
    // MARK: - Initialization
    init(withRouter router: IRouter, appState: StateStorage) {
        self.appState = appState
        super.init(with: router)
        //sensorsData[0].generateRandomData(100, max: 100, shouldIncludeOutliers: true)
        //sensorsData[1].generateRandomData(60, max: 40, shouldIncludeOutliers: false)
        sensorsData[2].generateRandomData(24*60, max: 60, inTimeIntervalTillNow: TimeInterval(24 * 60 * 60), shouldIncludeOutliers: true)
        btService.setupService {[weak self] (sensorData) in
            guard let safeSelf = self else { return }
            switch sensorData.type {
            case .temperature:
                safeSelf.sensorsData[0].appendPoint(atTimeStamp: sensorData.timeStamp, withValue: sensorData.value)
                safeSelf.reloadDataSignal.onNext(true)
            case .humidity:
                safeSelf.sensorsData[1].appendPoint(atTimeStamp: sensorData.timeStamp, withValue: sensorData.value)
                safeSelf.reloadDataSignal.onNext(true)
            }
        }
    }
}
