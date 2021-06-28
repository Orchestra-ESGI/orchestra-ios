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
    var sessionConnectivity: WCSession?
    let watchSessionManager = WatchSessionManager.shared
    let listUtils = ListUtil.shared
    let watchLocalization = WatchLabelLocalizableUtils.shared
    
    private var loadingTimer = Timer()
    private var progressTracker = 1
    var selectedDeviceIndex = 0
    
    var devices: [Device] = []
    
    @IBOutlet weak var loadingLabel: WKInterfaceLabel!
    
    @IBOutlet weak var devicesList: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        if WCSession.isSupported(){
            watchSessionManager.sessionConnectivity?.delegate = self
            self.sessionConnectivity = watchSessionManager.sessionConnectivity
            if self.sessionConnectivity?.activationState == .notActivated{
                self.sessionConnectivity?.activate()
            }else{
                // Session already activated
                self.syncDevicesList()
            }
        }
        self.startProgressIndicator()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        self.stopProgressIndicator()
    }
    
    func startProgressIndicator() {
        // Reset progress and timer.
        progressTracker = 1
        loadingTimer.invalidate()

        // Schedule timer.
        loadingTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)

        loadingLabel.setHidden(false)
    }

    @objc private func updateProgress() {
        let loadingText = watchLocalization.myDevicesScreenLoaderLabelTitle
        switch progressTracker {
        case 1:
            loadingLabel.setText("\(loadingText)..")
            progressTracker = 2
        case 2:
            loadingLabel.setText("\(loadingText)...")
            progressTracker = 3
        case 3:
            loadingLabel.setText("\(loadingText).")
            progressTracker = 1
        default:
            break
        }
    }

    func stopProgressIndicator() {
        loadingTimer.invalidate()
        loadingLabel.setHidden(true)
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    private func reloadTable(){
        listUtils.setUpList(wkTable: devicesList, modelList: devices,
                            rowId: "Device_Row", type: DeviceRow.self)
        self.stopProgressIndicator()
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        self.selectedDeviceIndex = rowIndex
        self.pushController(withName: "device_actions", context: self)
    }
    
    private func syncDevicesList(){
        guard self.sessionConnectivity!.isReachable else{
            return
        }

        self.sessionConnectivity!.sendMessage(["devices": "sync"]) { (reply) in
            print("responseHandler: \(reply)")
            if(reply.count > 0){
                self.parsedataFromPhone(reply)
            }else{
                self.stopProgressIndicator()
                let emptyLabel = self.watchLocalization.emptyDevicesLabel
                self.loadingLabel.setText(emptyLabel)
                self.loadingLabel.setHidden(false)
            }
        } errorHandler: { (err) in
            print("errorHandler: \(err)")
            self.stopProgressIndicator()
            self.pop()
        }
    }
    
    private func parsedataFromPhone(_ message: [String: Any]){
        self.devices.removeAll()
        for element in message.values {
            guard let deviceDict = element as? Dictionary<String, Any>,
                    let devicePosition = deviceDict["position"] as? Int,
                    let deviceName = deviceDict["name"] as? String,
                    let deviceRoom = deviceDict["room"] as? String,
                    let deviceColorComponent1 = deviceDict["color_component1"] as? Double,
                    let deviceColorComponent2 = deviceDict["color_component2"] as? Double,
                    let deviceColorComponent3 = deviceDict["color_component3"] as? Double,
                    let actions = deviceDict["actions"] as? [[String: Any]] else{
                return
            }
            let deviceBackground = UIColor(red: CGFloat(deviceColorComponent1), green: CGFloat(deviceColorComponent2), blue: CGFloat(deviceColorComponent3), alpha: 1.0)
            
            let device = Device(position: devicePosition, name: deviceName,
                                actions: actions,
                                color: deviceBackground, room: deviceRoom)
            self.devices.append(device)
        }
        
        self.devices.sort { (device1 , device2) -> Bool in
            return device1.position < device2.position
        }
        
        self.reloadTable()
    }
}

extension DomoticDevicesController: WCSessionDelegate{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){
        print("Activation complete on watch")
        syncDevicesList()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]){
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("Received all devices from phone: \(message)")
        self.parsedataFromPhone(message)
        replyHandler([
            "response": "Data received and parsed correctly"
        ])
    }
}
