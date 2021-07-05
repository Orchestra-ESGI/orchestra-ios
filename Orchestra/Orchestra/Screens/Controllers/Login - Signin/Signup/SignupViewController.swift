//
//  SigninViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 04/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var explanationLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var signupButton: UIButton!
    
    var alert: UIAlertController?
    
    // - MARK: Services
    let userVM = UsersViewModel()
    let disposeBag = DisposeBag()
    
    // - MARK: Utils
    let notificationUtils = NotificationsUtils.shared
    let notificationLocalize = NotificationLocalizableUtils.shared
    let progressUtils = ProgressUtils.shared
    let labelLocalization = ScreensLabelLocalizableUtils.shared
    let stringUtils = StringUtils.shared
    let alertUtils = AlertUtils.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpTextFields()
        self.setUpUI()
        self.localizeUI()
        self.setUpView()
        self.setUpClickObserver()
        self.setUpUiBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeObserver()
    }
    
    private func setUpClickObserver(){
        self.setupSignupButtonBindings()
    }

    // - MARK: Localization
    private func localizeUI(){
        self.explanationLabel.text = self.labelLocalization.signupWelcomText
        self.emailLabel.text = self.labelLocalization.signupVcEmailLabelText
        self.passwordLabel.text = self.labelLocalization.signupVcPasswordLabelText
        self.confirmPasswordLabel.text = self.labelLocalization.signupVcPasswordVerificationLabelText
        self.signupButton.setTitle(self.labelLocalization.signupVcButtonText, for: .normal)
    }
    
    private func setUpUI(){
        self.navigationController?.navigationBar.isHidden = true
        
        self.emailTF.setUpRightIcon(iconName: "envelope.fill")
        self.emailTF.setUpBlankLeftView()
        self.emailTF.borderStyle = .none
        self.emailTF.setBottomLayer(color: ColorUtils.shared.hexStringToUIColor(hex: "#788290"))
        self.emailTF.attributedPlaceholder = stringUtils.colorText(text: self.labelLocalization.loginEmailLabelHint, color: ColorUtils.ORCHESTRA_WHITE_COLOR, alpha: 0.5)
        self.emailTF.textColor = ColorUtils.ORCHESTRA_WHITE_COLOR
        self.emailTF.clipsToBounds = true
         
        self.passwordTF.setUpRightIcon(iconName: "lock.fill")
        self.passwordTF.setUpBlankLeftView()
        self.passwordTF.borderStyle = .none
        self.passwordTF.setBottomLayer(color: ColorUtils.shared.hexStringToUIColor(hex: "#788290"))
        self.passwordTF.attributedPlaceholder = stringUtils.colorText(text: self.labelLocalization.loginPasswordLabelText, color: ColorUtils.ORCHESTRA_WHITE_COLOR, alpha: 0.5)
        self.passwordTF.textColor = ColorUtils.ORCHESTRA_WHITE_COLOR
        self.passwordTF.autocorrectionType = .no
        self.passwordTF.clipsToBounds = true
         
        self.confirmPasswordTF.setUpRightIcon(iconName: "lock.fill")
        self.confirmPasswordTF.setUpBlankLeftView()
        self.confirmPasswordTF.borderStyle = .none
        self.confirmPasswordTF.setBottomLayer(color: ColorUtils.shared.hexStringToUIColor(hex: "#788290"))
        self.confirmPasswordTF.attributedPlaceholder = stringUtils.colorText(text: self.labelLocalization.loginPasswordLabelText, color: ColorUtils.ORCHESTRA_WHITE_COLOR, alpha: 0.5)
        self.confirmPasswordTF.textColor = ColorUtils.ORCHESTRA_WHITE_COLOR
        self.confirmPasswordTF.autocorrectionType = .no
        self.confirmPasswordTF.clipsToBounds = true
        
        self.signupButton.layer.borderWidth = 3
        self.signupButton.layer.borderColor = ColorUtils.ORCHESTRA_BLUE_COLOR.cgColor
        self.signupButton.backgroundColor = ColorUtils.ORCHESTRA_RED_COLOR
        self.signupButton.layer.cornerRadius = 25.0
        self.signupButton.clipsToBounds = true
        
        self.setupFonts()
        self.setupLabelColors()
        self.localizeUI()
    }
    
    private func setupFonts() {
        self.explanationLabel.font = Font.Regular(self.explanationLabel.font.pointSize)
        self.emailLabel.font = Font.Regular(self.emailLabel.font.pointSize)
        self.emailTF.font = Font.Regular(self.emailTF.font?.pointSize ?? 19)
        self.passwordLabel.font = Font.Regular(self.passwordLabel.font.pointSize)
        self.passwordTF.font = Font.Regular(self.passwordTF.font?.pointSize ?? 19)
        self.confirmPasswordLabel.font = Font.Regular(self.confirmPasswordLabel.font.pointSize)
        self.confirmPasswordTF.font = Font.Regular(self.confirmPasswordTF.font?.pointSize ?? 19)
        self.signupButton.titleLabel?.font = Font.Bold(self.signupButton.titleLabel?.font.pointSize ?? 20)
    }
    
    private func setupLabelColors() {
        self.emailLabel.textColor = ColorUtils.ORCHESTRA_WHITE_COLOR
        self.emailTF.textColor = ColorUtils.ORCHESTRA_WHITE_COLOR
        self.passwordLabel.textColor = ColorUtils.ORCHESTRA_WHITE_COLOR
        self.passwordTF.textColor = ColorUtils.ORCHESTRA_WHITE_COLOR
        self.confirmPasswordLabel.textColor = ColorUtils.ORCHESTRA_WHITE_COLOR
        self.confirmPasswordTF.textColor = ColorUtils.ORCHESTRA_WHITE_COLOR
        
        self.signupButton.setTitleColor(ColorUtils.ORCHESTRA_WHITE_COLOR, for: .normal)
    }

    func setUpView(){
        self.title = self.labelLocalization.signupVcTitle
        
        let sendForm = UIBarButtonItem(title: self.labelLocalization.sigupVcAppbarSendFormButtonTitle, style: .plain, target: self, action: nil)

        sendForm.tintColor = #colorLiteral(red: 2.387956192e-05, green: 0.5332912803, blue: 0.8063663244, alpha: 1)
        self.navigationItem.rightBarButtonItems = [sendForm]
        sendForm.rx
            .tap
            .bind { [weak self] in
                self?.alert = UIAlertController(title: nil, message: self?.notificationLocalize.undeterminedProgressViewTitle, preferredStyle: .alert)

                let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                loadingIndicator.hidesWhenStopped = true
                loadingIndicator.style = UIActivityIndicatorView.Style.medium
                loadingIndicator.startAnimating();

                self?.alert!.view.addSubview(loadingIndicator)
                self?.present((self?.alert)!, animated: true, completion: nil)
            
                self?.userVM.checkSignupForm()
        }.disposed(by: self.disposeBag)
    
        
    }
    
    private func setUpTextFields(){
        self.emailTF.delegate = self
        self.passwordTF.delegate = self
        self.confirmPasswordTF.delegate = self
        
        self.emailTF.returnKeyType = .next
        self.passwordTF.returnKeyType = .next
        self.confirmPasswordTF.returnKeyType = .done
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        switch textField {
        case self.emailTF:
            self.passwordTF.becomeFirstResponder()
            break
        case self.passwordTF:
            self.confirmPasswordTF.becomeFirstResponder()
            break
        case self.confirmPasswordTF:
            self.confirmPasswordTF.resignFirstResponder()
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
