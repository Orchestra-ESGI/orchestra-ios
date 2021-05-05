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
    var title: String = ""
    var sceneDescription: String = ""
    var backgroundColor: String?
    var idUser: String = ""
    var actions: [ActionSceneDto] = []
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.title <- map["title"]
        self.sceneDescription <- map["sceneDescription"]
        self.backgroundColor <- map["backgroundColor"]
        self.idUser <- map["idUser"]
        self.actions <- map["actions"]
    }
    
    
}
