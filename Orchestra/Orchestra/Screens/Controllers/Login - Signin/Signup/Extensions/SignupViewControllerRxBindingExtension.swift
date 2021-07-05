//
//  SignupViewControllerRxBindingExtension.swift
//  Orchestra
//
//  Created by Nassim Morouche on 20/06/2021.
//

import Foundation
import RxSwift
import RxCocoa

extension SignupViewController {
    func setupSignupButtonBindings() {
        self.signupButton
            .rx.tap
            .bind {
                self.userVM.checkForm(emailTf: self.emailTF, passwordTf: self.passwordTF, confirmPasswordTf: self.confirmPasswordTF)
            }
            .disposed(by: self.disposeBag)
    }
    
    func setUpUiBindings(){
        self.self.userVM
            .isSignupFormValid
            .subscribe { (isValid) in
                if isValid {
                    self.progressUtils.displayV2(view: self.view, title: self.notificationLocalize.undeterminedProgressViewTitle, modeView: .MRActivityIndicatorView)
                    self.sendSignup()
                }else{
                    self.progressUtils.dismiss()
                }
            } onError: { (err) in
                // Show some error in screen
                self.notificationUtils.showBadCredentialsNotification()
            }.disposed(by: self.disposeBag)
        
    }
    
    func sendSignup(){
        _ = self.userVM
            .signup(email: self.emailTF.text!,
                    password: self.passwordTF.text!)
            .subscribe { (userLogged) in
                let checkMarkTitle = self.notificationLocalize.signupCompleteCheckmarkTitle
                self.progressUtils.dismiss()
                self.progressUtils.displayCheckMark(title: checkMarkTitle, view: self.view)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.progressUtils.dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.showInfoAlert()
                    }
                }
        } onError: { (err) in
            self.notificationUtils.handleErrorResponseNotification(err as! ServerError)
            self.progressUtils.dismiss()
        } onCompleted: {
            self.progressUtils.dismiss()
            let alertMessage = self.labelLocalization.localNetworkAuthAlertMessage
            self.alertUtils.goToParamsAlert(message: alertMessage, for: self)
        } .disposed(by: self.disposeBag)

    }
    
    func showInfoAlert(){
        let alertTitle = self.labelLocalization.signupEmailSentAlertTitle
        let alertMessage = self.labelLocalization.signupEmailSentAlertMessage
        let alertActionString = self.labelLocalization.signupEmailSentAlertAction
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: alertActionString, style: .cancel) { action in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: {})
    }
    
}
