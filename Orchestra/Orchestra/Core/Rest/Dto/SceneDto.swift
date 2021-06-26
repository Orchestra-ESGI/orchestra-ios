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
    
    func mapSceneToString(position: Int) -> [String: Any]{
        let colorComponent1 = ColorUtils.shared.hexStringToUIColor(hex: self.color!).cgColor.components![0]
        let colorComponent2 = ColorUtils.shared.hexStringToUIColor(hex: self.color!).cgColor.components![1]
        let colorComponent3 = ColorUtils.shared.hexStringToUIColor(hex: self.color!).cgColor.components![2]
        return [
            "position": position,
            "name":  self.name,
            "color_component1": colorComponent1,
            "color_component2": colorComponent2,
            "color_component3": colorComponent3,
        ]
    }
}
