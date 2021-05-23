//
//  SceneRow.swift
//  Orchestra WatchKit Extension
//
//  Created by Ramzy Kermad on 23/05/2021.
//

import Foundation
import WatchKit

class SceneRow: RootRowController{
    
    @IBOutlet weak var rowGroup: WKInterfaceGroup!
    @IBOutlet weak var playSceneButton: WKInterfaceButton!
    @IBOutlet weak var sceneNameLabel: WKInterfaceLabel!
    
    var sceneToLaunch: Scene?
    var delegate: LaunchSceneDelegate?
    
    override func refresh(object: Any) {
        guard let scene = object as? Scene else{
            return
        }
        
        self.sceneToLaunch = scene
        self.rowGroup.setBackgroundColor(scene.sceneColor)
        self.sceneNameLabel.setText(scene.sceneName)
    }
    
    @IBAction func playScene() {
        guard let scenePosition = sceneToLaunch?.position else{
            return
        }
        self.delegate?.launchSceneAt(scenePosition)
    }
}
