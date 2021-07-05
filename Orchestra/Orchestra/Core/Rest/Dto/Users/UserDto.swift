//
//  UserDto.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/03/2021.
//

import Foundation
import ObjectMapper

class UserDto: NSObject, Mappable{
    var id: String = ""
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var is_removed: Bool = false

    
    required init?(map: Map) {
        super.init()
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.name <- map["name"]
        self.email <- map["email"]
        self.password <- map["password"]
        self.is_removed <- map["is_removed"]
    }
    
    
    
}
