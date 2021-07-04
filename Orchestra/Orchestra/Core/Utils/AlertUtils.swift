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
    
    var ac = UIAlertController()
    
    func showAlertWithTf(for controller: UIViewController, title: String, message: String, actionName: String, style: UIAlertController.Style = .alert, completion: @escaping (String) -> Void){
        self.ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.ac.addTextField { textField in
            textField.font = Font.Regular(17)
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
        }
        
        let submitAction = UIAlertAction(title: actionName, style: .default) { [unowned ac] _ in
            let textField = ac.textFields![0]
            if (textField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true) {
                textField.isError(numberOfShakes: 3.0, revert: true)
            } else {
                completion(textField.text!)
            }
            // do something interesting with "answer" here
        }
        submitAction.isEnabled = false
        self.ac.addAction(submitAction)
        
        let cancelAction = UIAlertAction(title: self.labelLocalization.settingsAlertCancelTitle, style: .cancel, handler: nil)
        self.ac.addAction(cancelAction)
        
        controller.present(ac, animated: true)
    }
    
    @objc
    func alertTextFieldDidChange(_ sender: UITextField) {
        ac.actions[0].isEnabled = !(sender.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false)
    }
}
