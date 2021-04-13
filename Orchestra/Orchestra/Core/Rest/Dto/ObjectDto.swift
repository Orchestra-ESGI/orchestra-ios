//
//  ObjectDto.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 10/04/2021.
//

import Foundation
import ObjectMapper

class ObjectDto: NSObject, Mappable{
    var _id: String?
    var name: String?
    var roomName: String?
    var manufacturer: String?
    var serialNumber: String?
    var model: String?
    var isOn: Bool?
    var isFav: Bool?
    var isReachable: Bool?
    var version: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _id <- map["_id"]
        name <- map["name"]
        roomName <- map["roomName"]
        manufacturer <- map["manufacturer"]
        serialNumber <- map["serialNumber"]
        model <- map["model"]
        isOn <- map["isOn"]
        isFav <- map["isFav"]
        isReachable <- map["isReachable"]
        version <- map["version"]
    }
    
}
