//
//  ScenesController.swift
//  Orchestra WatchKit Extension
//
//  Created by Ramzy Kermad on 23/05/2021.
//

import WatchKit
import Foundation
import WatchConnectivity

class ScenesController: WKInterfaceController, LaunchSceneDelegate{
    
    var scenes:  [Scene] = [
        Scene(position: 0, name: "Netflix & Chill", color: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)),
        Scene(position: 1, name: "Rideaux élctriques", color: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)),
        Scene(position: 2, name: "Ma routine du matin", color: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)),
        Scene(position: 3, name: "Ma routine de la soirée", color: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)),
        Scene(position: 4, name: "Nuit", color: #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1))
    ]
    var sessionConnectivity: WCSession?
    let listUtils = ListUtil.shared
    
    @IBOutlet weak var scenesList: WKInterfaceTable!
    
    
    override func awake(withContext context: Any?) {
        self.setTitle("Mes scènes")
        if WCSession.isSupported(){
            let session = WCSession.default
            session.delegate = self
            session.activate()
            self.sessionConnectivity = session
        }
        self.reloadTable()
    }
    
    override func willActivate() {
        super.willActivate()
        if WCSession.isSupported(){
            let session = WCSession.default
            session.delegate = self
            session.activate()
            self.sessionConnectivity = session
        }
        //syncScenesList()
        self.reloadTable()

    }
    
    private func reloadTable(){
        self.listUtils.setUpList(wkTable: self.scenesList, modelList: self.scenes, rowId: "Scene_Row", type: SceneRow.self, delegate: self)
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func launchSceneAt(_ position: Int) {
        print("Watch send scene position: \(position)")
        
//        sendSceneDataToPhone(data: [
//            "scene_pos": position.description
//        ])
    }
    
    private func sendSceneDataToPhone(data: [String: Any]){
        guard WCSession.default.isReachable else{
            return
        }


        WCSession.default.sendMessage(data) { (reply) in
            print("responseHandler: \(reply)")
        } errorHandler: { (err) in
            print("errorHandler: \(err)")
        }
    }
    
    private func syncScenesList(){
        guard self.sessionConnectivity!.isReachable else{
            return
        }

        self.sessionConnectivity!.sendMessage(["action": "sync"]) { (reply) in
            print("responseHandler: \(reply)")
            if(reply.count > 0){
                self.scenes.removeAll()
            }
            self.parsedataFromPhone(reply)
        } errorHandler: { (err) in
            print("errorHandler: \(err)")
        }
    }
    
    private func parsedataFromPhone(_ message: [String: Any]){
        self.scenes.removeAll()
        for element in message.values {
            guard let scene = element as? Dictionary<String, Any>,
                    let scenePosition = scene["position"] as? Int,
                    let sceneName = scene["name"] as? String,
                    let sceneColorComponent1 = scene["color_component1"] as? Double,
                    let sceneColorComponent2 = scene["color_component2"] as? Double,
                    let sceneColorComponent3 = scene["color_component3"] as? Double else{
                return
            }
            self.scenes.append(Scene(position: scenePosition,
                                     name: sceneName,
                                     color: UIColor(red: CGFloat(sceneColorComponent1),
                                                    green: CGFloat(sceneColorComponent2),
                                                   blue: CGFloat(sceneColorComponent3),
                                                   alpha: 1.0)
                )
            )
        }
        
        self.scenes.sort { (scene1, scene2) -> Bool in
            return scene1.position < scene2.position
        }
        
        self.reloadTable()
    }
}


extension ScenesController: WCSessionDelegate{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){
        print("Activation complete on watch")
        //syncScenesList()
        reloadTable()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]){
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("Received message from phone")
        print(message)
        self.parsedataFromPhone(message)
        replyHandler([
            "response": "Data received and parsed correctly"
        ])
    }
     
    
}
