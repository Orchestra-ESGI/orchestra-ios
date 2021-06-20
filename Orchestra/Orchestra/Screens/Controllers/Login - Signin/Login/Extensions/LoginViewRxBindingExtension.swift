//
//  LoginViewRxBindingExtension.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 01/05/2021.
//

import Foundation
import RxSwift
import RxCocoa

extension LoginViewController{
    func setupLoginButtonBindings(){
        self.loginButton
            .rx.tap
            .bind {
                self.userVm.checkForm(emailTf: self.emailTextField, passwordTf: self.passwordTextField)
            }
            .disposed(by: self.disposeBag)
    }
    
    func setUpPasswordBindings(){
        self.passwordForgotButton
            .rx.tap
            .bind { [weak self] in
                //self.navigationController?.pushViewController(ForgotPasswordViewController(), animated: true)
                self?.notificationUtils.showBasicBanner(title: "Forgot button clicked", subtitle: "WIP", position: .bottom, style: .info)
            }
            .disposed(by: self.disposeBag)
    }
    
    func setUpSigninButtonBindings(){
        self.signinButton
            .rx.tap
            .bind { [weak self] in
                let signinVC = SignupViewController()
                self?.navigationController?.pushViewController(signinVC, animated: true)
            }
            .disposed(by: self.disposeBag)
    }
}
