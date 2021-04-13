//
//  SceneViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 07/04/2021.
//

import UIKit

class SceneViewController: UIViewController {

    // MARK: - Local data
    var isUpdating: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
    }
    
    
    private func setUpUI(){
        self.title = self.isUpdating ? "Nouvelle scène" : "Modification"
    }
}
