//
//  RoomDto.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 29/06/2021.
//

import Foundation
import ObjectMapper

class RoomDto: NSObject, Mappable {
    var id: String?
    var name: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["_id"]
        self.name <- map["name"]
    }
}
