//
//  HomeVcWatchConnectivityExtension.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 25/06/2021.
//

import Foundation
import WatchConnectivity
import UIKit

extension HomeViewController{
    func syncWatchScenes(){
        guard WCSession.default.isReachable else{
            return
        }

        WCSession.default.sendMessage(dataToTranferToWatch) { (reply) in
            print("responseHandler: \(reply)")
        } errorHandler: { (err) in
            print("errorHandler: \(err)")
        }
        dataToTranferToWatch.removeAll()
    }

    func parseScenesForWatch(){
        var sceneCount = 0
        for scene in self.homeScenes {
            let sceneKey = (sceneCount).description
            self.dataToTranferToWatch[sceneKey] = scene.mapSceneToString(position: sceneCount + 1)

            print(scene)
            sceneCount += 1
        }
    }
    
    func parseDevicesForWatch(){
        var deviceCount = 0
        for device in self.hubDevices {
            let deviceKey = (deviceCount).description
            var deviceDict = device.mapDeviceToString(position: deviceCount + 1)
            self.parseDeviceActionToGetName(device: device)
            if(device.type != .Contact && device.type != .Occupancy &&
                device.type != .Temperature && device.type != .Humidity &&
                device.type != .TemperatureAndHumidity && device.type != .StatelessProgrammableSwitch &&
                device.type != .Unknown){
                deviceDict["actions"] = self.actionsName
            }else{
                deviceDict["actions"] = []
            }
            
            self.dataToTranferToWatch[deviceKey] = deviceDict

            print(device)
            deviceCount += 1
        }
    }
}


extension HomeViewController: WCSessionDelegate{

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){
        print("Activation complete on iPhone")
        syncWatchScenes()
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("Received message from watch")
        print(message)
        switch message.keys.first {
        case "scene_pos":
            // Play action on scpecific scene
            guard let response = message["scene_pos"] as? String else{
                return
            }
            let scenePos = Int(response)!
            self.playAllActions(for: IndexPath(row: scenePos, section: 1))
            
            replyHandler([
                "response": "Scene lancée correctement!"
            ])
            break
        case "device_action":
            // Play action on a specific device
            guard let response = message["device_action"] as? [String: Any],
                  let index = response["index"] as? Int,
                  let action = response["actions"] as? [String: Any] else{
                return
            }
            let actionKey = action.keys.first!
            switch actionKey {
            case "state":
                let actionValue = action[actionKey] as! String
                self.playActionOnDevice(index: index, action: [actionKey: actionValue])
                break
            case "brightness":
                let actionValue = action[actionKey] as! Int
                self.playActionOnDevice(index: index, action: [actionKey: actionValue])
                break
            case "color_temp":
                let actionValue = action[actionKey] as! Int
                self.playActionOnDevice(index: index, action: [actionKey: actionValue])
                break
            default:
                break
            }
            break
        case "scenes":
            // Sync watch and phone on scenes
            self.parseScenesForWatch()
            replyHandler(self.dataToTranferToWatch)
            self.dataToTranferToWatch.removeAll() // clean the array for the next transfert
            break
        case "devices":
            // Sync watch and phone on devices
            self.parseDevicesForWatch()
            replyHandler(self.dataToTranferToWatch)
            self.dataToTranferToWatch.removeAll() // clean the array for the next transfert
            break
        default:
            replyHandler([
                "response": "OK"
            ])
        }
    }
}

