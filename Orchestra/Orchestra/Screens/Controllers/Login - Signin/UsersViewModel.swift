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
    let realUserWS = UserServices()
    let fakeUserWS = FakeUserServices.shared
    
    let disposeBag = DisposeBag()
    let progressUtils = ProgressUtils.shared
    let notificationLocalizable = NotificationLocalizableUtils.shared
    
    var isLoginFormValid = PublishSubject<Bool>()
    var isSignupFormValid = PublishSubject<Bool>()
    
    let currentUser = PublishSubject<UserDto>()
    
    func login(email: String, password: String, on vewController: UIViewController) -> Observable<UserDto>{
        return Observable<UserDto>.create { (observer) -> Disposable in
            _ = self.realUserWS
                .login(email: email, password: password)
                .subscribe { (user) in
                    self.responseHandle(status: .OK, on: vewController)
                    self.saveUsreCredentials()
                    observer.onNext(user)
                } onError: { (err) in
                    self.responseHandle(status: .KOAPI, on: vewController)
                    observer.onError(err)
                }.disposed(by: self.disposeBag)
            
            return Disposables.create()
        }

    }
    
    func signin(name: String, email: String, pwd: String) -> Observable<UserDto>{
        return realUserWS.signin(name: name, email: email, password: pwd)
    }
    
    func deleteAccount(usersId: [String]) -> Observable<[String]>{
        return realUserWS.removeUser(usersId: usersId)
    }
    
    func updateUser(credentialName: String, id: String, credentialValue: String) -> Observable<UserDto>{
        return realUserWS.updateUser(credentialName, id, credentialValue)
    }
    
    func saveUsreCredentials(){
        // Save user credentials in shared pref or local storage
    }
    
    func updateUserCredentials(){
        // Update saved user credentials in shared pref or local storage
    }
    
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
    
    func checkLoginForm(emailTf: UITextField, passwordTf: UITextField){
        var isValid = false
        
        if(emailTf.text != nil && passwordTf.text != nil){
            // do some checking here
            isValid = true
        }
        self.isLoginFormValid.onNext(isValid)
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
