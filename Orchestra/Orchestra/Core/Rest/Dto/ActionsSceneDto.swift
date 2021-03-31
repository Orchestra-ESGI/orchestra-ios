//
//  ActionsSceneDto.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/03/2021.
//

import Foundation
import ObjectMapper

class ActionSceneDto: NSObject, Mappable{
    var title: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.title <- map["title"]
    }
    
    
}
