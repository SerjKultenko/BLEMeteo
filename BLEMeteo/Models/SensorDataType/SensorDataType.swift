//
//  SensorDataType.swift
//  BLEMeteo
//
//  Created by Sergey Kultenko on 06/01/2019.
//  Copyright © 2019 Sergey Kultenko. All rights reserved.
//

import Foundation

enum SensorDataType: String {
    case temperature = "TE"
    case humidity = "HU"
    case pressure = "PR"
    case temperatureBMP280 = "TB"
    case carbonDioxidePPM = "CO"
}
