//
//  HouseDto.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/03/2021.
//

import Foundation
import ObjectMapper

class HouseDto: NSObject, Mappable{
    var _id: String = ""
    var houseName: String = ""
    var houseAdress: String = ""
    var scenes: [SceneDto] = []
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self._id <- map["_id"]
        self.houseName <- map["houseName"]
        self.houseAdress <- map["houseAdress"]
        self.scenes <- map["scenes"]
        
    }
    
    
}
