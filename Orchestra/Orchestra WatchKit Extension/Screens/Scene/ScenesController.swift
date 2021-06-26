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
    
    let watchSessionManager = WatchSessionManager.shared
    var sessionConnectivity: WCSession?
    let listUtils = ListUtil.shared
    
    var scenes:  [Scene] = []
    private var loadingTimer = Timer()
    private var progressTracker = 1
    
    @IBOutlet weak var loadingLabel: WKInterfaceLabel!
    @IBOutlet weak var scenesList: WKInterfaceTable!
    
    @IBOutlet weak var sceneNameLabel: WKInterfaceLabel!
    
    
    
    override func awake(withContext context: Any?) {
        self.setTitle("Mes scènes")
        if WCSession.isSupported(){
            watchSessionManager.sessionConnectivity?.delegate = self
            self.sessionConnectivity = watchSessionManager.sessionConnectivity
            if self.sessionConnectivity?.activationState == .notActivated{
                self.sessionConnectivity?.activate()
            }else{
                // Session already activated
                self.syncScenesList()
            }
        }
        self.startProgressIndicator()
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
        let loadingText = "Récupération des scènes"
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
    
    private func reloadTable(){
        self.listUtils.setUpList(wkTable: self.scenesList, modelList: self.scenes, rowId: "Scene_Row", type: SceneRow.self, delegate: self)
        self.stopProgressIndicator()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        self.stopProgressIndicator()
    }
    
    func launchSceneAt(_ position: Int) {
        print("Watch send scene position: \(position)")
        
        sendSceneDataToPhone(data: [
            "scene_pos": position.description
        ])
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
    
    private func syncScenesList(){
        guard self.sessionConnectivity!.isReachable else{
            return
        }

        self.sessionConnectivity!.sendMessage(["scenes": "sync"]) { (reply) in
            print("responseHandler: \(reply)")
            if(reply.count > 0){
                self.scenes.removeAll()
                self.parsedataFromPhone(reply)
            }else{
                self.stopProgressIndicator()
                self.loadingLabel.setText("Vous n'avez encore créé aucune scène")
            }
        } errorHandler: { (err) in
            print("errorHandler: \(err)")
        }
    }
    
    
    private func parsedataFromPhone(_ message: [String: Any]){
        self.scenes.removeAll()
        for element in message.values {
            guard let sceneDict = element as? Dictionary<String, Any>,
                    let scenePosition = sceneDict["position"] as? Int,
                    let sceneName = sceneDict["name"] as? String,
                    let sceneColorComponent1 = sceneDict["color_component1"] as? Double,
                    let sceneColorComponent2 = sceneDict["color_component2"] as? Double,
                    let sceneColorComponent3 = sceneDict["color_component3"] as? Double else{
                return
            }
            let sceneBackground = UIColor(red: CGFloat(sceneColorComponent1),
                                          green: CGFloat(sceneColorComponent2),
                                          blue: CGFloat(sceneColorComponent3),
                                          alpha: 1.0)
            let  scene = Scene(position: scenePosition,name: sceneName, color:sceneBackground)
            self.scenes.append(scene)
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
        syncScenesList()
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
