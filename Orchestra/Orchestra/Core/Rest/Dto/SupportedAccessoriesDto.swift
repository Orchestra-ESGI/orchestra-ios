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
        self.category <- map["category"]
        self.devices <- map["devices"]
    }
}
