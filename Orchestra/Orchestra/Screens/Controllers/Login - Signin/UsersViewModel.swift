//
//  UsersViewModel.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 31/03/2021.
//

import Foundation
import RxSwift
import RxCocoa

class UsersViewModel{
    let userWS = UserServices()
    let userDataStream = PublishSubject<UserDto>()
    
    let disposeBag = DisposeBag()
    let progressUtils = ProgressUtils.shared
    let notificationLocalizable = NotificationLocalizableUtils.shared
    
    var isLoginFormValid = PublishSubject<Bool>()
    var isSignupFormValid = PublishSubject<Bool>()
    
    let currentUser = PublishSubject<UserDto>()
    
    func login(email: String, password: String, on vewController: UIViewController) -> Observable<UserDto>{
        return self.userWS.login(email: email, password: password)

    }
    
    func signup(email: String, password: String) -> Observable<UserDto>{
        return self.userWS.signup(email: email, password: password)
    }
    
    func deleteAccount(email: String) -> Observable<Bool>{
        return self.userWS.removeUser(email)
    }
    
//    func updateUser(credentialName: String, id: String, credentialValue: String) -> Observable<UserDto>{
//        return realUserWS.updateUser(credentialName, id, credentialValue)
//    }
    
    func responseHandle(status: StatusInsert, on viewController: UIViewController) {
        self.progressUtils.dismiss()
        var redirect = false
        switch status {
            case .UNREACHABLE:
                NotificationsUtils.shared.showFloatingNotificationBanner(title: notificationLocalizable.unreachableNotificationTitle, subtitle: notificationLocalizable.unreachableNotificationSubtitle, position: .top, style: .danger)
                redirect = true
            case .OK:
                NotificationsUtils.shared.showFloatingNotificationBanner(title: notificationLocalizable.okNotificationTitle, subtitle: notificationLocalizable.okNotificationSubtitle, position: .top, style: .success)
                redirect = true
            case .KOAPI:
                NotificationsUtils.shared.showFloatingNotificationBanner(title: notificationLocalizable.koApiNotificationTitle, subtitle: notificationLocalizable.koApiNotificationSubtitle, position: .top, style: .danger)
                redirect = true
            case .KO:
                NotificationsUtils.shared.showFloatingNotificationBanner(title: notificationLocalizable.koNotificationTitle, subtitle: notificationLocalizable.koNotificationSubtitle, position: .top, style: .danger)
                redirect = false
        }
        if redirect {
            self.redirect()
        }
    }
    
    func redirect(){
    }
    
    func checkForm(emailTf: UITextField, passwordTf: UITextField, confirmPasswordTf: UITextField? = nil){
        let isValid = isFormFilled(emailTf: emailTf, passwordTf: passwordTf, confirmPasswordTf: confirmPasswordTf)
        if (confirmPasswordTf == nil) {
            self.isLoginFormValid.onNext(isValid)
        } else {
            self.isSignupFormValid.onNext(isValid)
        }
        
    }
    
    private func isFormFilled(emailTf: UITextField, passwordTf: UITextField, confirmPasswordTf: UITextField? = nil) -> Bool {
        guard let emailText = emailTf.text,
            let passwordText = passwordTf.text else {
                return false
        }
        
        
        if (emailText.count > 0 && passwordText.count > 0 && emailText.isEmailValid() && passwordText.isPasswordValid()) {
            if let confirmPassword = confirmPasswordTf {
                if (confirmPassword.text != passwordText) {
                    checkOnWichTextFieldIsError(emailTf: emailTf, passwordTf: passwordTf, confirmPasswordTf: confirmPasswordTf)
                    return false
                }
            }
            
            resetTextFields(emailTf: emailTf, passwordTf: passwordTf, confirmPasswordTf: confirmPasswordTf)
            return true
        } else {
            checkOnWichTextFieldIsError(emailTf: emailTf, passwordTf: passwordTf, confirmPasswordTf: confirmPasswordTf)
        }
        
        return false
    }
    
    private func resetTextFields(emailTf: UITextField, passwordTf: UITextField, confirmPasswordTf: UITextField? = nil) {
        
        emailTf.setBottomLayer(color: ColorUtils.shared.hexStringToUIColor(hex: "#788290"))
        passwordTf.setBottomLayer(color: ColorUtils.shared.hexStringToUIColor(hex: "#788290"))
        if let confirmPassword = confirmPasswordTf {
            confirmPassword.setBottomLayer(color: ColorUtils.shared.hexStringToUIColor(hex: "#788290"))
        }
    }
    
    private func checkOnWichTextFieldIsError(emailTf: UITextField, passwordTf: UITextField, confirmPasswordTf: UITextField? = nil){
        if (emailTf.text!.count == 0 || !emailTf.text!.isEmailValid()) {
            emailTf.isError(numberOfShakes: 3.0, revert: true)
            emailTf.setBottomLayer(color: ColorUtils.ORCHESTRA_RED_COLOR)
        } else {
            emailTf.setBottomLayer(color: ColorUtils.shared.hexStringToUIColor(hex: "#788290"))
        }
        
        if (passwordTf.text!.count == 0 || !passwordTf.text!.isPasswordValid()) {
            passwordTf.isError(numberOfShakes: 3.0, revert: true)
            passwordTf.setBottomLayer(color: ColorUtils.ORCHESTRA_RED_COLOR)
        } else {
            passwordTf.setBottomLayer(color: ColorUtils.shared.hexStringToUIColor(hex: "#788290"))
        }
        
        if let confirmPassword = confirmPasswordTf {
            if (confirmPassword.text!.count == 0 || !confirmPassword.text!.isPasswordValid() || confirmPassword.text != passwordTf.text) {
                confirmPassword.isError(numberOfShakes: 3.0, revert: true)
                confirmPassword.setBottomLayer(color: ColorUtils.ORCHESTRA_RED_COLOR)
            } else {
                confirmPassword.setBottomLayer(color: ColorUtils.shared.hexStringToUIColor(hex: "#788290"))
            }
        }
    }
    
    func checkSignupForm(){
        self.isSignupFormValid.onNext(true)
    }
}

enum StatusInsert {
    case OK
    case KO
    case KOAPI
    case UNREACHABLE
}
