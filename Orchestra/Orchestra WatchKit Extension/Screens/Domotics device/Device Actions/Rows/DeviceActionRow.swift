//
//  DeviceActionRow.swift
//  Orchestra WatchKit Extension
//
//  Created by Ramzy Kermad on 28/06/2021.
//

import Foundation
import WatchKit

class DeviceActionRow: RootRowController{
    
    var rowPosition = 0
    
    @IBOutlet weak var actionNameLabel: WKInterfaceLabel!
    @IBOutlet weak var playActionBtn: WKInterfaceButton!
    var delagate: LaunchSceneDelegate?
    
    override func refresh(object: Any) {
        guard let action = object as? String else{
            return
        }
        
        self.actionNameLabel.setText(action)
    }
    
    @IBAction func playDeviceAction() {
        self.delagate?.launchSceneAt(rowPosition)
    }
}
