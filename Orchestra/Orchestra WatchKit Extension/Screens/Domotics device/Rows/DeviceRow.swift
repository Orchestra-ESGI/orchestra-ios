//
//  DeviceRow.swift
//  Orchestra WatchKit Extension
//
//  Created by Ramzy Kermad on 23/05/2021.
//

import Foundation
import WatchKit

class DeviceRow: RootRowController{

    @IBOutlet weak var nameLabel: WKInterfaceLabel!
    @IBOutlet weak var rowGroup: WKInterfaceGroup!
    @IBOutlet weak var roomName: WKInterfaceLabel!
    @IBOutlet weak var deviceIcon: WKInterfaceImage!
    
    var rowPosition = 0
    
    override func refresh(object: Any) {
        guard let device = object as? Device else{
            return
        }
        var iconName = "questionmark"
        switch device.type {
        case "switch":
            iconName = "switch.2"
            break
        case "lightbulb":
            iconName = "lightbulb.fill"
            break
        case "statelessProgrammableSwitch":
            iconName = "circle.circle.fill"
            break
        case "occupancySensor":
            iconName = "figure.walk"
            break
        default:
            iconName = "questionmark"
            break
        }
        self.deviceIcon.setImage(UIImage(systemName: iconName))
        self.rowPosition = device.position
        self.nameLabel.setText(device.deviceName)
        self.rowGroup.setBackgroundColor(device.deviceColor)
        self.roomName.setText(device.deviceRoom)
    }
}
