//
//  HubAccessoryType.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 31/05/2021.
//

import Foundation

enum DeviceType: String {
    case LightBulb = "lightbulb"
    case StatelessProgrammableSwitch = "programmableswitch"
    case Occupancy = "occupancy"
    case Contact = "contact"
    case Temperature = "temperature"
    case Humidity = "humidity"
    case TemperatureAndHumidity = "temperatureandhumidity"
    case Switch = "switch"
    case Unknown = "unknown"
}
