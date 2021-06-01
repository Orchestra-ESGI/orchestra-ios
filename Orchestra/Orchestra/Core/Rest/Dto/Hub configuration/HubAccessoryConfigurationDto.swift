//
//  HubAccessoryConfigurationDto.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 31/05/2021.
//

import Foundation
import ObjectMapper

class HubAccessoryConfigurationDto: NSObject, Mappable{
    var id: String?
    var name: String?
    var roomName: String?
    var backgroundColor: String?
    var manufacturer: String?
    var serialNumber: String?
    var model: String?
    var isOn: Bool?
    var isFav: Bool?
    var isReachable: Bool?
    var version: String?
    var type: HubAccessoryType = .Unknown
    var actions: [ActionSceneDto] = []
    var friendlyName: String = ""
    
    
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
        self.id <- map["id"]
        self.roomName <- map["roomName"]
        self.backgroundColor <- map["backgroundColor"]
        self.manufacturer <- map["manufacturer"]
        self.serialNumber <- map["serialNumber"]
        self.model <- map["model"]
        self.isOn <- map["isOn"]
        self.isFav <- map["isFav"]
        self.isReachable <- map["isReachable"]
        self.version <- map["version"]
    }
    
    
    
}
