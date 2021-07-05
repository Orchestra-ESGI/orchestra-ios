//
//  DeviceActionsController.swift
//  Orchestra WatchKit Extension
//
//  Created by Ramzy Kermad on 23/05/2021.
//

import WatchKit
import Foundation
import WatchConnectivity

class DeviceActionsController: WKInterfaceController, LaunchSceneDelegate{
    private let watchSessionManager = WatchSessionManager.shared
    private var sessionConnectivity: WCSession?
    
    // - MARK: Utils
    private let listUtils = ListUtil.shared
    private let watchLocalization = WatchLabelLocalizableUtils.shared
    
    // MARK: - Local data
    private var controllerTitle = ""
    private var objectColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    private var actionsDict: [[String: Any]] = []
    private var actionsList: [String] = []
    private var currentActionIndex = 0
    private var selectedDeviceIndex = 0
    
    
    // MARK: - Outlets
    @IBOutlet weak var objectNameLabel: WKInterfaceLabel!
    @IBOutlet weak var actionsTable: WKInterfaceTable!
    @IBOutlet weak var listHeaderLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.localizeScreen()
        if WCSession.isSupported(){
            watchSessionManager.sessionConnectivity?.delegate = self
            self.sessionConnectivity = watchSessionManager.sessionConnectivity
            if self.sessionConnectivity?.activationState == .notActivated{
                self.sessionConnectivity?.activate()
            }
        }
        guard let domoticData = context as? DomoticDevicesController else{
            return
        }
        selectedDeviceIndex = domoticData.selectedDeviceIndex
        let currentDevice = domoticData.devices[domoticData.selectedDeviceIndex]
        self.controllerTitle = currentDevice.deviceName
        self.objectColor = currentDevice.deviceColor
        self.actionsDict = domoticData.devices[selectedDeviceIndex].actions
        self.setUpUI()
    }
    
    private func localizeScreen(){
        self.setTitle(self.watchLocalization.deviceDetailTitle)
    }
    
    private func reloadTable(){
        listUtils.setUpList(wkTable: actionsTable, modelList: self.actionsList,
                            rowId: "Device_Action_Row", type: DeviceActionRow.self,
                            delegate: self)
    }
    
    private func setUpUI(){
        self.setUpList()
        if(actionsDict.count > 0){
            self.listHeaderLabel.setText(self.watchLocalization.deviceSelectActionLabelTitle)
        }else{
            self.listHeaderLabel.setText(self.watchLocalization.deviceNoActionLabelTitle)
        }
        self.objectNameLabel.setTextColor(self.objectColor)
        self.objectNameLabel.setText(self.controllerTitle)
    }
    
    private func setUpList(){
        for action in self.actionsDict{
            self.actionsList.append(action["key"] as! String)
        }
        self.reloadTable()
    }
    
    func launchSceneAt(_ position: Int) {
        self.currentActionIndex = position
        playAction()
    }
    
    private func playAction() {
        let actionType = self.actionsDict[currentActionIndex]["type"] as! String
        let actionValue = self.actionsDict[currentActionIndex]["val"]
        let actions: [String: Any] = [
            actionType: actionValue
        ]
        let data: [String: Any] = [
            "index": selectedDeviceIndex,
            "actions": actions
        ]
        self.sendSceneDataToPhone(data: ["device_action":data])
    }
    
    private func sendSceneDataToPhone(data: [String: Any]){
        guard self.sessionConnectivity!.isReachable else{
            return
        }

        self.sessionConnectivity!.sendMessage(data) { (reply) in
            print("responseHandler: \(reply)")
        } errorHandler: { (err) in
            print("errorHandler: \(err)")
        }
    }
}

extension DeviceActionsController: WCSessionDelegate{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]){
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
    }
}
