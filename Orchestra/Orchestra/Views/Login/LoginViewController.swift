//
//  LoginViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 03/04/2021.
//

import UIKit
import RxSwift
import RxCocoa
import NotificationBannerSwift

class LoginViewController: UIViewController {
    @IBOutlet weak var bigTitle: UILabel!
    
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordForgotButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signinButton: UIButton!
    
    // - MARK : Services
    let usersWS = FakeUserServices.shared //UserServices.shared
    
    // - MARK : View models
    let userVm = UsersViewModel()
    
    
    // - MARK : Utils
    let notificationUtils = NotificationsUtils.shared
    let notificationLocalize = NotificationLocalizableUtils.shared
    let screenLocalize = ScreensLabelLocalizableUtils()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.localizeUI()
        self.setUpUiBindings()
        self.setUpObservers()
    }
    
    // - MARK: Localization
    private func localizeUI(){
        self.bigTitle.text = self.screenLocalize.loginBigText
        self.emailLabel.text = self.screenLocalize.loginEmailLabelText
        self.passwordLabel.text = self.screenLocalize.loginPasswordLabelText
        self.passwordForgotButton.setTitle(self.screenLocalize.loginPasswordForgotButtonText, for: .normal)
        self.loginButton.setTitle(self.screenLocalize.loginConnexionButtonText, for: .normal)
        self.signinButton.setTitle(self.screenLocalize.loginSigupbButtonText, for: .normal)
    }
    
    

    // - MARK: Observers
    private func setUpObservers(){
        // Login form
        self.userVm
            .isLoginFormValid
            .subscribe { (isValid) in
                if isValid {
                    self.usersWS.getAllFakeUsers()
                }else{
                    self.notificationUtils.showBadCredentialsNotification()
                }
            } onError: { (err) in
                // Show some error in screen
                self.notificationUtils.showBadCredentialsNotification()
            }.disposed(by: self.disposeBag)
        
        self.observeFakeLoginUserEvent()
        
        //self.observeLoginUserEvent()
    }
    
    
    // - MARK: RX binding
    private func setUpUiBindings(){
        self.loginButton
            .rx.tap
            .bind {
                self.userVm.checkLoginForm(emailTf: (self.emailTextField)!, passwordTf: (self.passwordTextField)!)            }
            .disposed(by: self.disposeBag)
        
        self.passwordForgotButton
            .rx.tap
            .bind { [weak self] in
                //self.navigationController?.pushViewController(ForgotPasswordViewController(), animated: true)
                self?.notificationUtils.showBasicBanner(title: "Forgot button clicked", subtitle: "WIP", position: .bottom, style: .info)
            }
            .disposed(by: self.disposeBag)
        
        self.signinButton
            .rx.tap
            .bind { [weak self] in
                let signinVC = SigninViewController()
                self?.navigationController?.pushViewController(signinVC, animated: true)
            }
            .disposed(by: self.disposeBag)
    }
    
    // - MARK: Real Data
    private func observeLoginUserEvent(){
        _ = self.userVm
            .login(email: self.emailTextField.text!, password: self.passwordTextField.text!, on: self)
            .subscribe { (userLogged) in
            print(userLogged)
            //let scenesVC = AppPresentationPagerViewController()
            // scenesVC.user = userLogged
            //self.navigationController?.pushViewController(scenesVC, animated: true)
        } onError: { (err) in
            print(err)
        }.disposed(by: self.disposeBag)
    }
    
    // - MARK: Fake Data
    private func observeFakeLoginUserEvent(){
        _ = self.usersWS
            .userStream
            .subscribe { (users) in
                let userCredentials = users.filter { (user) -> Bool in
                    return user.email == self.emailTextField.text
                        && user.password == self.passwordTextField.text
                }
                if userCredentials.count == 1 {
                    self.notificationUtils
                        .showFloatingNotificationBanner(title: self.notificationLocalize.okNotificationTitle, subtitle: self.notificationLocalize.okNotificationSubtitle, position: .top, style: .success)
                    let sceneVC = ScenesListViewController()
                    sceneVC.userLoggedInData = userCredentials[0]
                    self.navigationController?.pushViewController(sceneVC, animated: true)
//                    self.notificationUtils
//                        .showFloatingNotificationBanner(title: "Hello \(userCredentials[0].name)", subtitle: "You are successfully logged", position: .top, style: .success)
                }else{
                    self.notificationUtils.showBadCredentialsNotification()
                }
        } onError: { (err) in
            self.notificationUtils.showBadCredentialsNotification()
        }.disposed(by: self.disposeBag)
    }

}
