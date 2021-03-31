//
//  TestMapper.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/03/2021.
//

import Foundation
import ObjectMapper

class ErrorDto: NSObject, Mappable, Error{
    var code: String = ""
    var message: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
    }
}
