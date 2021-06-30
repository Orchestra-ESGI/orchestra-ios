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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var passwordForgotButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    // - MARK : View models
    let userVm = UsersViewModel()
    
    
    // - MARK : Utils
    let stringUtils = StringUtils.shared
    let notificationUtils = NotificationsUtils.shared
    let notificationLocalize = NotificationLocalizableUtils.shared
    let labelLocalization = ScreensLabelLocalizableUtils.shared
    let progressUtils = ProgressUtils.shared
    let alertUtils = AlertUtils.shared
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getPermissionsUser()
        self.setUpTextFields()
        self.setUpUI()
        self.setUpUiBindings()
        self.setUpObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeObserver()
    }
    
    private func getPermissionsUser(){
        let controller = SPPermissions.dialog([.notification, .locationWhenInUse, .camera])

        // Overide texts in controller
        controller.titleText = self.labelLocalization.permissionsAlertTitle
        controller.headerText = self.labelLocalization.permissionsAlertHeaderTitle
        controller.footerText = self.labelLocalization.permissionAlertFooterTitle
        
        controller.dataSource = self
        controller.delegate = self
        
        controller.present(on: self)
    }
    
    
    // - MARK: Localization
    private func localizeUI(){
        self.bigTitle.attributedText = stringUtils.colorTextWithOptions(text: self.labelLocalization.loginBigText, color: ColorUtils.ORCHESTRA_WHITE_COLOR, linkColor: ColorUtils.ORCHESTRA_WHITE_COLOR, shouldBold: true, fontSize: self.bigTitle.font.pointSize)
        self.emailLabel.text = self.labelLocalization.loginEmailLabelText
        self.passwordLabel.text = self.labelLocalization.loginPasswordLabelText
        self.passwordForgotButton.setTitle(self.labelLocalization.loginPasswordForgotButtonText, for: .normal)
        self.loginButton.setTitle(self.labelLocalization.loginConnexionButtonText.uppercased(), for: .normal)
        
        let attr = NSMutableAttributedString(string: self.labelLocalization.noAccountLabelText)
        attr.addAttribute(.underlineStyle, value: 1, range: NSMakeRange(0, attr.length))
        self.signupButton.setAttributedTitle(attr, for: .normal)
    }
    
    private func setUpUI(){
        self.navigationController?.navigationBar.isHidden = true
        
        self.emailTextField.setUpRightIcon(iconName: "envelope.fill")
        self.emailTextField.setUpBlankLeftView()
        self.emailTextField.borderStyle = .none
        self.emailTextField.setBottomLayer(color: ColorUtils.shared.hexStringToUIColor(hex: "#788290"))
        self.emailTextField.attributedPlaceholder = stringUtils.colorText(text: self.labelLocalization.loginEmailLabelHint, color: ColorUtils.ORCHESTRA_WHITE_COLOR, alpha: 0.5)
        self.emailTextField.textColor = ColorUtils.ORCHESTRA_WHITE_COLOR
        self.emailTextField.clipsToBounds = true

        self.passwordTextField.setUpRightIcon(iconName: "lock.fill")
        self.passwordTextField.setUpBlankLeftView()
        self.passwordTextField.borderStyle = .none
        self.passwordTextField.setBottomLayer(color: ColorUtils.shared.hexStringToUIColor(hex: "#788290"))
        self.passwordTextField.attributedPlaceholder = stringUtils.colorText(text: self.labelLocalization.loginPasswordLabelText, color: ColorUtils.ORCHESTRA_WHITE_COLOR, alpha: 0.5)
        self.passwordTextField.textColor = ColorUtils.ORCHESTRA_WHITE_COLOR
        self.passwordTextField.autocorrectionType = .no
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
        
        self.signupButton.setTitleColor(ColorUtils.ORCHESTRA_WHITE_COLOR, for: .normal)
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
        self.signupButton.titleLabel?.font = Font.Bold(self.signupButton.titleLabel?.font.pointSize ?? 15)
    }
    
    // - MARK: Observers
    private func setUpObservers(){
        // Login form
        self.userVm
            .isLoginFormValid
            .subscribe { (isValid) in
                if isValid {
                    self.progressUtils.displayV2(view: self.view, title: self.notificationLocalize.undeterminedProgressViewTitle, modeView: .MRActivityIndicatorView)
                    self.sendLogin()
                }else{
                    self.progressUtils.dismiss()
                }
            } onError: { (err) in
                // Show some error in screen
                self.notificationUtils.showBadCredentialsNotification()
            }.disposed(by: self.disposeBag)
    }
    
    
    // - MARK: RX binding
    private func setUpUiBindings(){
        self.setupLoginButtonBindings()
        self.setUpPasswordBindings()
        self.setUpSigninButtonBindings()
    }
    
    
    
    // - MARK: Real Data
    private func sendLogin(){
        _ = self.userVm
            .login(email: self.emailTextField.text!, password: self.passwordTextField.text!, on: self)
            .subscribe { (userLogged) in
                let checkMarkTitle = self.notificationLocalize.loginCompleteCheckmarkTitle
                self.progressUtils.dismiss()
                self.progressUtils.displayCheckMark(title: checkMarkTitle, view: self.view)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.progressUtils.dismiss()
                    let homeVC = HomeViewController()
                    homeVC.userLoggedInData = userLogged
                    self.navigationController?.pushViewController(homeVC, animated: true)
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
    
    private func setUpTextFields(){
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        self.emailTextField.returnKeyType = .next
        self.passwordTextField.returnKeyType = .done
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        switch textField {
        case self.emailTextField:
            self.passwordTextField.becomeFirstResponder()
            break
        case self.passwordTextField:
            self.passwordTextField.resignFirstResponder()
            break
        default:
            break
        }
        return true
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { notification in
            self.keyboardWillHide(notification: notification)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { notification in
            self.keyboardWillShow(notification: notification)
        }
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height + 20, right: 0)
        self.scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification: Notification) {
        self.scrollView.contentInset = UIEdgeInsets.zero
    }

}

extension LoginViewController: SPPermissionsDelegate {
    
}

extension LoginViewController: SPPermissionsDataSource{
    func configure(_ cell: SPPermissionTableViewCell, for permission: SPPermission) -> SPPermissionTableViewCell {
        return OrchestraPermissions(category: permission.rawValue, cell).setPermissionCell()
    }
}
