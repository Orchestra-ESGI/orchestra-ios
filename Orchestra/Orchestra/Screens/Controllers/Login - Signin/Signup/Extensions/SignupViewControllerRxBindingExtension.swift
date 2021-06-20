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
}
