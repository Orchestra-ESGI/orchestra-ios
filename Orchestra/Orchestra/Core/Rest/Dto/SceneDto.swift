//
//  SceneDto.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/03/2021.
//

import Foundation
import ObjectMapper

class SceneDto: NSObject, Mappable{
    var id: String = ""
    var name: String = ""
    var sceneDescription: String = ""
    var color: String?
    var devices: [SceneAction] = []
   
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["_id"]
        self.name <- map["name"]
        self.sceneDescription <- map["description"]
        self.color <- map["color"]
        self.devices <- map["devices"]
    }
    
    
}
