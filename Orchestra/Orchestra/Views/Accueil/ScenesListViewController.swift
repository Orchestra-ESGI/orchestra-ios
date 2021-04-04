//
//  ScenesListViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 04/04/2021.
//

import UIKit

class ScenesListViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }

    private func setUpView(){
        self.navigationItem.hidesBackButton = true
    }
}
