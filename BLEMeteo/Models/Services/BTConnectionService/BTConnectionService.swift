//
//  BTConnectionService.swift
//  BLEMeteo
//
//  Created by Kultenko Sergey on 21/10/2018.
//  Copyright © 2018 Sergey Kultenko. All rights reserved.
//

import Foundation
import CoreBluetooth

enum BTConnectionServiceError: Error {
    case bluetoothStatusUnsuported
}

class BTConnectionService: NSObject {

    // MARK: - Core Bluetooth service IDs
    let BLE_Arduino_Meteo_Service_CBUUID = CBUUID(string: "0xFFE0")

    // MARK: - Core Bluetooth characteristic IDs
    let BLE_Arduino_Meteo_Characteristic_CBUUID = CBUUID(string: "0xFFE1")

    
    // MARK: - Core Bluetooth class member variables
    private var centralManager: CBCentralManager?
    private var peripheralMeteoMonitor: CBPeripheral?
    private var dataCallBack: ((_ error: Error?, _ sensorDataUnit: SensorDataUnit?) -> Void)?
    
    // Buffer for receiving data
    private var dataBuffer: String = ""
    
    func setupService(withSensorDataCallback callback: @escaping (_ error: Error?, _ sensorDataUnit: SensorDataUnit?) -> Void) {
        let centralQueue: DispatchQueue = DispatchQueue(label: "com.Serj.Kultenko.BLEMeteo.BTCentralManagerQueue", attributes: .concurrent)
        dataCallBack = callback
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
    }
    
    // MARK: - Utilities
    
    func decodePeripheralState(peripheralState: CBPeripheralState) {
        
        switch peripheralState {
        case .disconnected:
            print("Peripheral state: disconnected")
        case .connected:
            print("Peripheral state: connected")
        case .connecting:
            print("Peripheral state: connecting")
        case .disconnecting:
            print("Peripheral state: disconnecting")
        }
        
    }
    
}

// MARK: - CBCentralManagerDelegate
extension BTConnectionService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .unknown:
            print("Bluetooth status is UNKNOWN")
        case .resetting:
            print("Bluetooth status is RESETTING")
        case .unsupported:
            dataCallBack?(BTConnectionServiceError.bluetoothStatusUnsuported, nil)
            print("Bluetooth status is UNSUPPORTED")
        case .unauthorized:
            print("Bluetooth status is UNAUTHORIZED")
        case .poweredOff:
            print("Bluetooth status is POWERED OFF")
        case .poweredOn:
            print("Bluetooth status is POWERED ON")
            centralManager?.scanForPeripherals(withServices: [BLE_Arduino_Meteo_Service_CBUUID])
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral.name ?? "")
        decodePeripheralState(peripheralState: peripheral.state)
        peripheralMeteoMonitor = peripheral
        peripheralMeteoMonitor?.delegate = self
        
        // Stop scanning to preserve battery life;
        // re-scan if disconnected
        centralManager?.stopScan()
        
        centralManager?.connect(peripheralMeteoMonitor!)
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")

        peripheralMeteoMonitor?.discoverServices([BLE_Arduino_Meteo_Service_CBUUID])
        
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected!")
        centralManager?.scanForPeripherals(withServices: [BLE_Arduino_Meteo_Service_CBUUID])
        
    }

    
}

// MARK: - CBPeripheralDelegate
extension BTConnectionService: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            if service.uuid == BLE_Arduino_Meteo_Service_CBUUID {
                print("Service: \(service)")
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            print(characteristic)
            
            if characteristic.uuid == BLE_Arduino_Meteo_Characteristic_CBUUID {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == BLE_Arduino_Meteo_Characteristic_CBUUID {
            let data = characteristic.value
            guard data != nil else { return }
            
            // then the string
            if let str = String(data: data!, encoding: String.Encoding.utf8) {
                print("Received - \(str)")
                parseSensorData(str: str)
            } else {
                print("Received an invalid string!")
            }

        }
    }
    
    private func parseSensorData(str: String) {
        let data = self.dataBuffer + str
        var nextChank = ""
        
        let timestamp = Date()
        for char in data {
            if char == " " {
                if let sensorData = SensorDataUnit(fromString: String(nextChank), withTimestamp: timestamp) {
                    dataCallBack?(nil, sensorData)
                }
                nextChank = ""
            } else {
                nextChank += String(char)
            }
        }
        self.dataBuffer = nextChank // Add data without terminal space (" ")
    }
}
