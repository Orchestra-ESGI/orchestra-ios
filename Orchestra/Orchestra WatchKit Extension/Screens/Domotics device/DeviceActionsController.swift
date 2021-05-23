//
//  DeviceActionsController.swift
//  Orchestra WatchKit Extension
//
//  Created by Ramzy Kermad on 23/05/2021.
//

import WatchKit
import Foundation
import WatchConnectivity

class DeviceActionsController: WKInterfaceController{
    // MARK: - Local data
    var controllerTitle = ""
    var objectColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var actions: [String] = []
    var currentActionIndex = 0
    
    
    // MARK: - Outlets
    @IBOutlet weak var objectNameLabel: WKInterfaceLabel!
    @IBOutlet weak var actionPicker: WKInterfacePicker!
    @IBOutlet weak var playActionButton: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        guard let domoticData = context as? DomoticDevicesController else{
            return
        }
        let currentDevice = domoticData.devices[domoticData.selectedDeviceIndex]
        self.controllerTitle = currentDevice.deviceName
        self.objectColor = currentDevice.deviceColor
        self.actions = domoticData.actions
        self.setUpUI()
    }
    
    private func setUpUI(){
        self.setUpPicker()
        self.objectNameLabel.setTextColor(self.objectColor)
        self.objectNameLabel.setText(self.controllerTitle)
    }
    
    private func setUpPicker(){
        self.actionPicker.focus()
        var pickerItems: [WKPickerItem] = []
        for action in self.actions{
            let pickerItem = WKPickerItem()
            pickerItem.title = action
            pickerItem.caption = "Choisissez une action"
            pickerItems.append(pickerItem)
        }
        self.actionPicker.setItems(pickerItems)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    @IBAction func currentPickerItem(_ value: Int) {
        self.currentActionIndex = value
        print(value)
    }
    
    @IBAction func playAction() {
        let playingAction = self.actions[currentActionIndex]
        print("Playing \"\(playingAction)...\"")
    }
    
}
