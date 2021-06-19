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
import SPPermissions

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var bigTitle: UILabel!
    
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordForgotButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signinButton: UIButton!
    
    // - MARK : View models
    let userVm = UsersViewModel()
    
    
    // - MARK : Utils
    let stringUtils = StringUtils.shared
    let notificationUtils = NotificationsUtils.shared
    let notificationLocalize = NotificationLocalizableUtils.shared
    let screenLocalize = ScreensLabelLocalizableUtils.shared
    let progressUtils = ProgressUtils.shared
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getPermissionsUser()
        self.setUpTextFields()
        self.setUpUI()
        self.setUpUiBindings()
        self.setUpObservers()
    }
    
    private func getPermissionsUser(){
        let controller = SPPermissions.dialog([.notification, .locationWhenInUse])

        // Overide texts in controller
        controller.titleText = self.screenLocalize.permissionsAlertTitle
        controller.headerText = self.screenLocalize.permissionsAlertHeaderTitle
        controller.footerText = self.screenLocalize.permissionAlertFooterTitle
        
        controller.dataSource = self
        controller.delegate = self
        
        controller.present(on: self)
    }
    
    
    // - MARK: Localization
    private func localizeUI(){
        self.bigTitle.attributedText = stringUtils.colorTextWithOptions(text: self.screenLocalize.loginBigText, color: ColorUtils.ORCHESTRA_WHITE_COLOR, linkColor: ColorUtils.ORCHESTRA_WHITE_COLOR, shouldBold: true, fontSize: self.bigTitle.font.pointSize)
        self.emailLabel.text = self.screenLocalize.loginEmailLabelText
        self.passwordLabel.text = self.screenLocalize.loginPasswordLabelText
        self.passwordForgotButton.setTitle(self.screenLocalize.loginPasswordForgotButtonText, for: .normal)
        self.loginButton.setTitle(self.screenLocalize.loginConnexionButtonText.uppercased(), for: .normal)
        
        let attr = NSMutableAttributedString(string: self.screenLocalize.noAccountLabelText)
        attr.addAttribute(.underlineStyle, value: 1, range: NSMakeRange(0, attr.length))
        self.signinButton.setAttributedTitle(attr, for: .normal)
    }
    
    private func setUpUI(){
        self.navigationController?.navigationBar.isHidden = true
        
        self.emailTextField.setUpRightIcon(iconName: "envelope.fill")
        self.emailTextField.setUpBlankLeftView()
        self.emailTextField.borderStyle = .none
        self.emailTextField.setBottomLayer(color: ColorUtils.shared.hexStringToUIColor(hex: "#788290"))
        self.emailTextField.attributedPlaceholder = stringUtils.colorText(text: self.screenLocalize.loginEmailLabelHint, color: ColorUtils.ORCHESTRA_WHITE_COLOR, alpha: 0.5)
        self.emailTextField.textColor = ColorUtils.ORCHESTRA_WHITE_COLOR
        self.emailTextField.clipsToBounds = true

        self.passwordTextField.setUpRightIcon(iconName: "lock.fill")
        self.passwordTextField.setUpBlankLeftView()
        self.passwordTextField.borderStyle = .none
        self.passwordTextField.setBottomLayer(color: ColorUtils.shared.hexStringToUIColor(hex: "#788290"))
        self.passwordTextField.attributedPlaceholder = stringUtils.colorText(text: self.screenLocalize.loginPasswordLabelText, color: ColorUtils.ORCHESTRA_WHITE_COLOR, alpha: 0.5)
        self.passwordTextField.textColor = ColorUtils.ORCHESTRA_WHITE_COLOR
        self.passwordTextField.clipsToBounds = true
        
        self.loginButton.layer.borderWidth = 3
        self.loginButton.layer.borderColor = ColorUtils.ORCHESTRA_BLUE_COLOR.cgColor
        self.loginButton.backgroundColor = ColorUtils.ORCHESTRA_RED_COLOR
        self.loginButton.layer.cornerRadius = 25.0
        self.loginButton.clipsToBounds = true
        
        self.setupFonts()
        self.setupLabelColors()
        self.localizeUI()
    }
    
    private func setupLabelColors() {
        self.emailLabel.textColor = ColorUtils.ORCHESTRA_WHITE_COLOR
        self.emailTextField.textColor = ColorUtils.ORCHESTRA_WHITE_COLOR
        self.passwordLabel.textColor = ColorUtils.ORCHESTRA_WHITE_COLOR
        self.passwordTextField.textColor = ColorUtils.ORCHESTRA_WHITE_COLOR
        
        self.passwordForgotButton.setTitleColor(ColorUtils.ORCHESTRA_RED_COLOR, for: .normal)
        self.loginButton.setTitleColor(ColorUtils.ORCHESTRA_WHITE_COLOR, for: .normal)
        
        self.signinButton.setTitleColor(ColorUtils.ORCHESTRA_WHITE_COLOR, for: .normal)
    }
    
    private func setupFonts() {
        self.bigTitle.font = Font.Regular(self.bigTitle.font.pointSize)
        self.emailLabel.font = Font.Regular(self.emailLabel.font.pointSize)
        self.emailTextField.font = Font.Regular(self.emailTextField.font?.pointSize ?? 19)
        self.passwordLabel.font = Font.Regular(self.passwordLabel.font.pointSize)
        self.passwordTextField.font = Font.Regular(self.passwordTextField.font?.pointSize ?? 19)
        self.passwordForgotButton.titleLabel?.font = Font.Regular(self.passwordForgotButton.titleLabel?.font.pointSize ?? 15)
        self.loginButton.titleLabel?.font = Font.Bold(self.loginButton.titleLabel?.font.pointSize ?? 20)
        self.passwordForgotButton.titleLabel?.font = Font.Bold(self.passwordForgotButton.titleLabel?.font.pointSize ?? 17)
        self.signinButton.titleLabel?.font = Font.Bold(self.signinButton.titleLabel?.font.pointSize ?? 15)
    }
    
    // - MARK: Observers
    private func setUpObservers(){
        // Login form
        self.userVm
            .isLoginFormValid
            .subscribe { (isValid) in
                if isValid {
                    self.progressUtils.displayV2(view: self.view, title: self.notificationLocalize.undeterminedProgressViewTitle, modeView: .MRActivityIndicatorView)
                    self.userVm.fakeUserWS.getAllFakeUsers()
                }else{
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
        self.setupLoginButtonBindings()
        self.setUpPasswordBindings()
        self.setUpSigninButtonBindings()
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
        _ = self.userVm.fakeUserWS
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
                        let homeVC = HomeViewController()
                        homeVC.userLoggedInData = userCredentials[0]
                        self.navigationController?.pushViewController(homeVC, animated: true)
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

extension LoginViewController: SPPermissionsDelegate {
    
}

extension LoginViewController: SPPermissionsDataSource{
    func configure(_ cell: SPPermissionTableViewCell, for permission: SPPermission) -> SPPermissionTableViewCell {
        return OrchestraPermissions(category: permission.rawValue, cell).setPermissionCell()
    }
}
