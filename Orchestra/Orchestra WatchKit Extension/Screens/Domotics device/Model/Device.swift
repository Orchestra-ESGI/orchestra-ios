//
//  Device.swift
//  Orchestra WatchKit Extension
//
//  Created by Ramzy Kermad on 23/05/2021.
//

import Foundation
import UIKit

class Device {
    var position: Int
    var deviceName: String
    var deviceColor: UIColor
    var deviceRoom: String
    
    init(position: Int,name: String, color: UIColor, room: String) {
        self.position = position
        self.deviceName = name
        self.deviceColor = color
        self.deviceRoom = room
    }
}
