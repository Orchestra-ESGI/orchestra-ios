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

class LoginViewController: UIViewController, UITextFieldDelegate {
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
    let progressUtils = ProgressUtils.shared
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpTextFields()
        self.setUpUI()
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
        self.signinButton.setTitle(self.screenLocalize.loginSigupbButtonText.uppercased(), for: .normal)
    }
    
    private func setUpUI(){
        self.emailTextField.setUpLeftIcon(iconName: "envelope.fill")
        self.emailTextField.layer.borderWidth = 0.5
        self.emailTextField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.emailTextField.layer.cornerRadius = 30.0
        self.emailTextField.clipsToBounds = true

        self.passwordTextField.setUpLeftIcon(iconName: "lock.fill")
        self.passwordTextField.layer.borderWidth = 0.5
        self.passwordTextField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.passwordTextField.layer.cornerRadius = 30.0
        self.passwordTextField.clipsToBounds = true

        self.loginButton.layer.borderWidth = 0.5
        self.loginButton.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.loginButton.layer.cornerRadius = 30.0
        self.loginButton.clipsToBounds = true
    }

    // - MARK: Observers
    private func setUpObservers(){
        // Login form
        self.userVm
            .isLoginFormValid
            .subscribe { (isValid) in
                if isValid {
                    self.progressUtils.displayV2(view: self.view, title: self.notificationLocalize.undeterminedProgressViewTitle, modeView: .MRActivityIndicatorView)
                    self.usersWS.getAllFakeUsers()
                }else{
                    self.notificationUtils.showBadCredentialsNotification()
                    self.progressUtils.dismiss()
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
                self.userVm.checkLoginForm(emailTf: (self.emailTextField)!, passwordTf: (self.passwordTextField)!)
            }
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
                    let welcomeNotificationTitle = self.notificationLocalize.loginWelcomeNotificatiionTitle + userCredentials[0].name
                    let welcomeNotificationSubtitle = self.notificationLocalize.loginWelcomeNotificationSubtitle
                    let checkMarkTitle = self.notificationLocalize.loginCompleteCheckmarkTitle
                    self.notificationUtils
                        .showFloatingNotificationBanner(title: welcomeNotificationTitle, subtitle: welcomeNotificationSubtitle, position: .top, style: .success)
                    self.progressUtils.displayCheckMark(title: checkMarkTitle, view: self.view)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.progressUtils.dismiss()
                        let sceneVC = ScenesListViewController()
                        sceneVC.userLoggedInData = userCredentials[0]
                        self.navigationController?.pushViewController(sceneVC, animated: true)
                    }
                }else{
                    self.notificationUtils.showBadCredentialsNotification()
                    self.progressUtils.dismiss()
                }
        } onError: { (err) in
            self.notificationUtils.showBadCredentialsNotification()
        }.disposed(by: self.disposeBag)
    }
    
    private func setUpTextFields(){
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

}
