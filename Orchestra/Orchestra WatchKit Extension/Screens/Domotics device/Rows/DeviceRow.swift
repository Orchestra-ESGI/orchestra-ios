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
    @IBOutlet weak var reachabilityLabel: WKInterfaceLabel!
    @IBOutlet weak var rowGroup: WKInterfaceGroup!
    
    var rowPosition = 0
    
    override func refresh(object: Any) {
        guard let device = object as? Device else{
            return
        }
        
        self.rowPosition = device.position
        self.nameLabel.setText(device.deviceName)
        self.rowGroup.setBackgroundColor(device.deviceColor)
    }
}
