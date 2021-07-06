//
//  AccountUtils.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 06/07/2021.
//

import Foundation
import UIKit

class AccountUtils{
    static let shared = AccountUtils()
    
    func signout() {
        UserDefaults.standard.removeObject(forKey: "bearer-token")
        UserDefaults.standard.removeObject(forKey: "email")
        
        let appWindow = UIApplication.shared.windows[0]
        appWindow.rootViewController?.removeFromParent()
        appWindow.rootViewController = UINavigationController(rootViewController: LoginViewController())
        
        let options: UIView.AnimationOptions = .transitionCrossDissolve

        let duration: TimeInterval = 0.4

        UIView.transition(with: appWindow,
                          duration: duration,
                          options: options, animations: {}, completion: nil)
    }
}
