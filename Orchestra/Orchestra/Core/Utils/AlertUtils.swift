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
    
    func showAlert(for controller: UIViewController, title: String, message: String,
                   style: UIAlertController.Style = .alert,
                   actions: [UIAlertAction]){
        let alert = UIAlertController(title: title , message: message, preferredStyle: style)
        for action in actions{
            alert.addAction(action)
        }
        
        controller.present(alert, animated: true)
    }
    
    func showAlertWithTf(for controller: UIViewController, title: String, message: String, actionName: String, style: UIAlertController.Style = .alert, completion: @escaping (String) -> Void){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: actionName, style: .default) { [unowned ac] _ in
            let textField = ac.textFields![0]
            completion(textField.text!)
            // do something interesting with "answer" here
        }
        
        ac.addAction(submitAction)
        
        controller.present(ac, animated: true)
    }
}
