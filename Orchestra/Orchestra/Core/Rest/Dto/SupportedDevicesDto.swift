//
//  SupportedDevicesInformationsDto.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/05/2021.
//

import Foundation
import ObjectMapper

class SupportedDevicesInformationsDto: NSObject, Mappable{
    var name: String = ""
    var image: String = ""
    var doc_url: String?
    var model: String? = ""
    var manufacturer: String? = ""
   
    required init?(map: Map) {
        super.init()
    }
    
    func mapping(map: Map) {
        self.name <- map["name"]
        self.image <- map["image"]
        self.doc_url <- map["documentation"]
        self.model <- map["model"]
        self.manufacturer <- map["manufacturer"]
    }
}
