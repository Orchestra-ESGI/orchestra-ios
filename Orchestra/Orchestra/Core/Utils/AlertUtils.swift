//
//  AlertUtils.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 22/06/2021.
//

import Foundation
import UIKit

class AlertUtils {
    static let shared = AlertUtils()
    
    func goToParamsAlert(message: String , for controller: UIViewController){
        let alertTitle = "Action requise"
        let actionTitle = "Aller au paramètres"
        let alert = UIAlertController(title: alertTitle  , message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: actionTitle, style: .default, handler: { action in
            controller.navigationController?.popViewController(animated: true)
            if let bundleIdentifier = Bundle.main.bundleIdentifier, let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
                if UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings)
                }
            }
        })
        alert.addAction(defaultAction)
        
        controller.present(alert, animated: true)
    }
}
