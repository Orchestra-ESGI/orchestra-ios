//
//  ActionsSceneDto.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/03/2021.
//

import Foundation
import ObjectMapper

class ActionSceneDto: NSObject, Mappable{
    var actionTitle: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.actionTitle <- map["title"]
    }
    
}



class SliderAction: NSObject, Mappable{
    var minVal: Int = 100
    var maxVal: Int = 500
    var currentState: Int = 0
    var type: SliderType = .BrightnessSlider
    var state: DeviceState?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.minVal <- map["min_val"]
        self.maxVal <- map["max_val"]
        self.currentState <- map["current_state"]
        
        switch map["type"].currentValue as? String {
            case "brightness":
                self.type = .BrightnessSlider
            case "color_temp":
                self.type = .ColorTempSlider
            default:
                self.type = .BrightnessSlider
        }
    }
    
}

enum SliderType {
    case BrightnessSlider
    case ColorTempSlider
}


class ColorAction: NSObject, Mappable{
    var hex: String = ""
    var currentState: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.hex <- map["hex"]
        self.currentState <- map["current_state"]
    }
    
}

class Actions: NSObject, Mappable{
    var brightness: SliderAction?
    var color: ColorAction?
    var colorTemp: SliderAction?
    var toggleAction: [String] = []
    var state: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        if(map["color"].currentValue != nil){
            self.color <- map["color"]
        }
        if(map["color_temp"].currentValue != nil){
            self.colorTemp <- map["color_temp"]
        }
        if(map["brightness"].currentValue != nil){
            self.brightness <- map["brightness"]
        }
        if(map["toggleAction"].currentValue != nil){
            self.toggleAction <- map["toggleAction"]
        }
        switch map["state"].currentValue as? String {
            case "ON":
                self.state = "on"
            case "OFF":
                self.state = "off"
            default:
                self.state = "on"
        }
    }
}


enum DeviceState {
    case Toggle
    case ON
    case OFF
}
