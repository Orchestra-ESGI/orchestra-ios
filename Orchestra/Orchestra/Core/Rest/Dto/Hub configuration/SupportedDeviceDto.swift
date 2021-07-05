//
//  SupportedAccessoriesDto.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/05/2021.
//

import Foundation
import ObjectMapper

class SupportedDeviceDto: NSObject, Mappable{
    var brand: String = ""
    var devices: [SupportedDevicesInformationsDto] = []
       
    required init?(map: Map) {
        super.init()
    }
    
    func mapping(map: Map) {
        self.brand <- map["brand"]
        self.devices <- map["devices"]

    }
}
