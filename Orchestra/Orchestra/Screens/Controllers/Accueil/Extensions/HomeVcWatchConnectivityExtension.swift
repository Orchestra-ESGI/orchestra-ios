//
//  HomeVcWatchConnectivityExtension.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 25/06/2021.
//

import Foundation
import WatchConnectivity
import UIKit

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
            guard let response = message["scene_pos"] as? String else{
                return
            }
            let scenePos = Int(response)!
            self.playAllActionsOf(for: IndexPath(row: scenePos, section: 1))
            
            replyHandler([
                "response": "Scene lancée correctement!"
            ])
            break
        case "device_action":
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
            // Syncroniser la montre et le tél sur la liste de scène
            self.parseScenesForWatch()
            replyHandler(self.dataToTranferToWatch)
            self.dataToTranferToWatch.removeAll() // clean the array for the next transfert
            break
        case "devices":
            // Syncroniser la montre et le tél sur la liste de scène
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
