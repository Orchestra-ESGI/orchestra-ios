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
    var isOn: Bool?
    var isFav: Bool?
    var isReachable: Bool?
    var type: HubAccessoryType = .Unknown
    var actions: Actions?
    var friendlyName: String = ""
    var reset: Bool = false
    
    
    required init?(map: Map) {
        super.init()
    }
    
    func mapping(map: Map) {
        self.name <- map["name"]
        switch map["type"].currentValue as? String {
            case "lightbulb":
                self.type = .LightBulb
            case "statelessProgrammableSwitch":
                self.type = .StatelessProgrammableSwitch
            case "occupancySensor":
                self.type = .OccupancySensor
            default:
                self.type = .Unknown
        }
        self.actions <- map["actions"]
        self.friendlyName <- map["friendly_name"]

        self.roomName <- map["room_name"]
        self.backgroundColor <- map["background_color"]
        self.manufacturer <- map["manufacturer"]
        self.model <- map["model"]
        self.isOn <- map["is_on"]
        self.isFav <- map["is_fav"]
        self.isReachable <- map["is_reachable"]
    }
    
    func toMap(needsReset: Bool) -> [String: Any]{
        var map: [String: Any] = [:]
        
        map["name"] = self.name
        switch self.type  {
            case .LightBulb:
                map["type"] = "lightbulb"
            case .StatelessProgrammableSwitch:
                map["type"] = "statelessProgrammableSwitch"
            case .OccupancySensor:
                map["type"] = "occupancySensor"
            default:
                self.type = .Unknown
        }
        map["actions"] = self.actions // fake
        map["friendly_name"] = StringUtils.shared.generateFakeId(length: 10) // fake
        map["room_name"] = self.roomName
        map["background_color"] = self.backgroundColor
        map["manufacturer"] = self.manufacturer
        map["model"] = self.model
        map["is_on"] = true // fake
        map["is_fav"] = self.isFav
        map["is_reachable"] = true // fake
        map["reset"] = needsReset
        return map
    }
    
}
