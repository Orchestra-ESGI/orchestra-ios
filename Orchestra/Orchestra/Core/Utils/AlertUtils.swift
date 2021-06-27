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
    let labelLocalization = ScreensLabelLocalizableUtils.shared
    
    func goToParamsAlert(message: String , for controller: UIViewController){
        let alertTitle = self.labelLocalization.localNetworkAuthAlertTitle
        let goParamsActionTitle = self.labelLocalization.localNetworkAuthAlertActionTitle
        let cancelActionTitle = self.labelLocalization.noResponseFromServerActionTitle
        
        let alert = UIAlertController(title: alertTitle , message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: goParamsActionTitle, style: .default, handler: { action in
            controller.navigationController?.popViewController(animated: true)
            if let bundleIdentifier = Bundle.main.bundleIdentifier, let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
                if UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings)
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel) { action in
            
        }
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        
        controller.present(alert, animated: true)
    }
}
