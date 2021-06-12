//
//  SupportedAccessoriesDto.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/05/2021.
//

import Foundation
import ObjectMapper

class SupportedAccessoriesDto: NSObject, Mappable{
    var type: String = ""
    var category: String = ""
    var devices: [SupportedDevicesInformationsDto] = []
       
    required init?(map: Map) {
        super.init()
    }
    
    func mapping(map: Map) {
        self.type <- map["type"]
        self.devices <- map["devices"]
        
        switch map["type"].currentValue as? String {
            case "lightbulb":
                self.category = "Light bulb"
            case "statelessProgrammableSwitch":
                self.category = "Switch"
            case "occupancySensor":
                self.category = "Motion sensor"
            default:
                self.category = "Type inconnu"
        }
    }
}
