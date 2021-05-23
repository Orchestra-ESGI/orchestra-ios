//
//  DomoticDevicesController.swift
//  Orchestra WatchKit Extension
//
//  Created by Ramzy Kermad on 23/05/2021.
//

import WatchKit
import Foundation
import WatchConnectivity


class DomoticDevicesController: WKInterfaceController{
    let listUtils = ListUtil.shared
    var selectedDeviceIndex = 0
    var sessionConnectivity: WCSession?
    
    var devices:  [Device] = [
        Device(position: 0, name: "Détecteur de mouvements", color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), reachable: true, isFav: false),
        Device(position: 1, name: "Lampe salon", color: #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), reachable: false, isFav: false),
        Device(position: 2, name: "Éclairage Jardin", color: #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), reachable: false, isFav: true),
        Device(position: 3, name: "Smart button bureau", color: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), reachable: true, isFav: true),
        Device(position: 4, name: "Verrou porte", color: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), reachable: true, isFav: true)
    ]
    var actions: [String] = [
        "Allumer",
        "Éteindre",
        "Faire clignoter",
        "Mettre à 100%",
        "Mettre à 75%",
        "Mettre à 50%",
        "Mettre à 25%"
    ] // There will be real data, for now it just fake
    
    @IBOutlet weak var devicesList: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        self.setTitle("Mes objets")
        self.reloadTable()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    private func reloadTable(){
        listUtils.setUpList(wkTable: devicesList, modelList: devices,
                            rowId: "Device_Row", type: DeviceRow.self)
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        self.selectedDeviceIndex = rowIndex
        self.presentController(withName: "device_actions", context: self)
    }
}

