//
//  SceneViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 07/04/2021.
//

import UIKit

class SceneViewController: UIViewController {

    // MARK: - UI
    
    
    
    // MARK: Utils
    let localizeUtils = ScreensLabelLocalizableUtils()
    
    
    // MARK: - Local data
    var isUpdating: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
    }
    
    
    private func setUpUI(){
        let newSceneTitle = self.localizeUtils.newSceneVcTitle
        let updateSceneTitle = self.localizeUtils.updateSceneVcTitle
        
        self.title = self.isUpdating ? updateSceneTitle : newSceneTitle
    }
}
