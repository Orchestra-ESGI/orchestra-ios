//
//  InterfaceController.swift
//  Orchestra WatchKit Extension
//
//  Created by Ramzy Kermad on 23/03/2021.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        self.setTitle("Orchestra")
    }
    
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    
    @IBAction func showScenesController() {
        self.pushController(withName: "scenes_controller", context: nil)
    }
    
    @IBAction func showDevicesController() {
        self.pushController(withName: "devices_controller", context: nil)
    }
}
