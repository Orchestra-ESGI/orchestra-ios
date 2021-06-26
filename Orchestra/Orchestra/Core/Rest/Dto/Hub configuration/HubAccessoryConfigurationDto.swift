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
    var roomName: String?
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
            case "switch":
                self.type = .Switch
            case "statelessProgrammableSwitch":
                self.type = .StatelessProgrammableSwitch
            case "sensor":
                self.type = .Sensor
            default:
                self.type = .Unknown
        }
        self.actions <- map["actions"]
        self.friendlyName <- map["friendly_name"]

        self.roomName <- map["room_name"]
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
                map["type"] = "statelessProgrammableSwitch"
            case .Sensor:
                map["type"] = "occupancySensor"
            default:
                self.type = .Unknown
        }
        map["actions"] = self.actions // fake
        map["friendly_name"] = self.friendlyName
        map["room_name"] = self.roomName
        map["background_color"] = self.backgroundColor
        map["manufacturer"] = self.manufacturer
        map["model"] = self.model
        return map
    }
    
    func mapDeviceToString(position: Int) -> [String: Any]{
        let colorComponent1 = ColorUtils.shared.hexStringToUIColor(hex: self.backgroundColor!).cgColor.components![0]
        let colorComponent2 = ColorUtils.shared.hexStringToUIColor(hex: self.backgroundColor!).cgColor.components![1]
        let colorComponent3 = ColorUtils.shared.hexStringToUIColor(hex: self.backgroundColor!).cgColor.components![2]
        return [
            "position": position,
            "name":  self.name,
            "room": self.roomName,
            "color_component1": colorComponent1,
            "color_component2": colorComponent2,
            "color_component3": colorComponent3,
        ]
    }
}
