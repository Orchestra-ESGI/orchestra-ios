//
//  HubAccessoryConfigurationDto.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 31/05/2021.
//

import Foundation
import ObjectMapper

class HubAccessoryConfigurationDto: NSObject, Mappable{
    var name: String?
    var room: RoomDto?
    var backgroundColor: String?
    var manufacturer: String?
    var model: String?
    var isReachable: Bool?
    var type: HubAccessoryType = .Unknown
    var actions: Actions?
    var friendlyName: String = ""
    
    
    required init?(map: Map) {
        super.init()
    }
    
    func mapping(map: Map) {
        self.name <- map["name"]
        switch map["type"].currentValue as? String {
        case "lightbulb":
            self.type = .LightBulb
            break
        case "switch":
            self.type = .Switch
            break
        case "programmableswitch":
            self.type = .StatelessProgrammableSwitch
            break
        case "occupancy":
            self.type = .Occupancy
            break
        case "contact":
            self.type = .Contact
            break
        case "temperature":
            self.type = .Temperature
            break
        case "humidity":
            self.type = .Humidity
        case "temperatureandhumidity":
            self.type = .TemperatureAndHumidity
        default:
            self.type = .Unknown
            break
        }
        self.actions <- map["actions"]
        self.friendlyName <- map["friendly_name"]
        
        self.room <- map["room"]
        self.backgroundColor <- map["background_color"]
        self.manufacturer <- map["manufacturer"]
        self.model <- map["model"]
        self.isReachable <- map["is_reachable"]
    }
    
    func toMap() -> [String: Any]{
        var map: [String: Any] = [:]
        
        map["name"] = self.name
        switch self.type  {
        case .Switch:
            map["type"] = "switch"
        case .LightBulb:
            map["type"] = "lightbulb"
        case .StatelessProgrammableSwitch:
            map["type"] = "programmableswitch"
        case .Occupancy:
            map["type"] = "occupancysensor"
        case .Contact:
            map["type"] = "contact"
        case .Temperature:
            map["type"] = "temperature"
        case .Humidity:
            map["type"] = "humidity"
        case .TemperatureAndHumidity:
            map["type"] = "temperatureandhumidity"
        default:
            self.type = .Unknown
        }
        map["actions"] = self.actions // fake
        map["friendly_name"] = self.friendlyName
        map["room"] = [
            "_id": self.room?.id,
            "name": self.room?.name
        ]
        map["background_color"] = self.backgroundColor
        map["manufacturer"] = self.manufacturer
        map["model"] = self.model
        return map
    }
    
    func mapDeviceToString(position: Int) -> [String: Any]{
        let colorComponent1 = ColorUtils.shared.hexStringToUIColor(hex: self.backgroundColor!).cgColor.components![0]
        let colorComponent2 = ColorUtils.shared.hexStringToUIColor(hex: self.backgroundColor!).cgColor.components![1]
        let colorComponent3 = ColorUtils.shared.hexStringToUIColor(hex: self.backgroundColor!).cgColor.components![2]
        var type: String = "";
        switch self.type  {
        case .Switch:
            type = "switch"
        case .LightBulb:
            type = "lightbulb"
        case .StatelessProgrammableSwitch:
            type = "programmableswitch"
        case .Occupancy:
            type = "occupancysensor"
        case .Contact:
            type = "contact"
        case.Temperature:
            type = "temperature"
        case.Humidity:
            type = "humidity"
        case .TemperatureAndHumidity:
            type = "temperatureandhumidity"
        default:
            type = "Unknown"
        }
        
        return [
            "position": position,
            "name":  self.name ?? NSLocalizedString("undefined.value.dto", comment: ""),
            "room": NSLocalizedString(self.room?.name ?? "", comment: "") ?? NSLocalizedString("undefined.value.dto", comment: ""),
            "color_component1": colorComponent1,
            "color_component2": colorComponent2,
            "color_component3": colorComponent3,
            "type": type
        ]
    }
}
