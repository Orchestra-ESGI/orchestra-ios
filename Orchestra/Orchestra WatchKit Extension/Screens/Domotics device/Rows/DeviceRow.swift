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
    @IBOutlet weak var favIcon: WKInterfaceImage!
    @IBOutlet weak var rowGroup: WKInterfaceGroup!
    
    var rowPosition = 0
    
    override func refresh(object: Any) {
        guard let device = object as? Device else{
            return
        }
        let favImage = UIImage(systemName: "heart.fill")
        
        self.rowPosition = device.position
        self.favIcon.setTintColor(#colorLiteral(red: 0.8067922592, green: 0.03158546984, blue: 0.1118666604, alpha: 1))
        self.favIcon.setHidden(!device.isFav)
        self.favIcon.setImage(favImage)
        self.nameLabel.setText(device.deviceName)
        self.reachabilityLabel.setText(device.deviceReachability)
        self.rowGroup.setBackgroundColor(device.deviceColor)
    }
}
