//
//  SigninViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 04/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class SigninViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var explanationLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    // - MARK: Services
    let userVM = UsersViewModel()
    
    // - MARK: Utils
    let notificationUtils = NotificationsUtils.shared
    let notificationLocalize = NotificationLocalizableUtils.shared
    let progressUtils = ProgressUtils.shared
    let screenLocalize = ScreensLabelLocalizableUtils.shared
    
    let disposeBag = DisposeBag()
    
    var alert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpTextFields()
        self.setUpUI()
        self.localizeUI()
        self.setUpView()
        self.setUpObservers()
    }
    
    // - MARK: Localization
    private func localizeUI(){
        self.explanationLabel.text = self.screenLocalize.signupWelcomText
        self.emailLabel.text = self.screenLocalize.signupVcEmailLabelText
        self.passwordLabel.text = self.screenLocalize.signupVcPasswordLabelText
        self.confirmPasswordLabel.text = self.screenLocalize.signupVcPasswordVerificationLabelText
        self.nameLabel.text = self.screenLocalize.signnupVcNameLabelText
    }
    
    private func setUpUI(){
        self.emailTF.setUpRightIcon(iconName: "envelope.fill")
        self.emailTF.layer.borderWidth = 0.5
        self.emailTF.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.emailTF.layer.cornerRadius = 15.0
        self.emailTF.clipsToBounds = true
         
        self.passwordTF.setUpRightIcon(iconName: "lock.fill")
        self.passwordTF.layer.borderWidth = 0.5
        self.passwordTF.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.passwordTF.layer.cornerRadius = 15.0
        self.passwordTF.clipsToBounds = true
         
        self.confirmPasswordTF.setUpRightIcon(iconName: "lock.fill")
        self.confirmPasswordTF.layer.borderWidth = 0.5
        self.confirmPasswordTF.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.confirmPasswordTF.layer.cornerRadius = 15.0
        self.confirmPasswordTF.clipsToBounds = true
         
        self.nameTF.setUpRightIcon(iconName: "person.fill")
        self.nameTF.layer.borderWidth = 0.5
        self.nameTF.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.nameTF.layer.cornerRadius = 15.0
        self.nameTF.clipsToBounds = true
    }

    func setUpView(){
        self.title = self.screenLocalize.signupVcTitle
        
        let sendForm = UIBarButtonItem(title: self.screenLocalize.sigupVcAppbarSendFormButtonTitle, style: .plain, target: self, action: nil)

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
    
    // - MARK: Observers
    private func setUpObservers(){
        _ = self
            .userVM
            .isSignupFormValid
            .subscribe(onNext: { (isValid) in
            if(isValid){
                self.userVM.fakeUserWS.signup()
            }else{
                self.notificationUtils.showBadCredentialsNotification()
            }
        }, onError: { (err) in
            self.notificationUtils.showBadCredentialsNotification()
        }).disposed(by: self.disposeBag)
        
        observeSigninFakeUserEvent()
    }
    
    
    // - MARK: Real Data
    private func observeSignupUserEvent(){
        
    }
    
    
    // - MARK: Fake Data
    private func observeSigninFakeUserEvent(){
        _ = self
            .userVM
            .fakeUserWS
            .userSignupStream
            .subscribe(onNext: { (user) in
                self.alert!.dismiss(animated: true, completion: nil)
                self.notificationUtils
                    .showFloatingNotificationBanner(title: self.notificationLocalize.okNotificationTitle, subtitle: self.notificationLocalize.okNotificationSubtitle, position: .top, style: .success)
                
                let sceneVC = HomeViewController()
                sceneVC.userLoggedInData = user
                self.navigationController?.pushViewController(sceneVC, animated: true)
            }, onError: { (err) in
                self.notificationUtils.showBadCredentialsNotification()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func setUpTextFields(){
        self.emailTF.delegate = self
        self.passwordTF.delegate = self
        self.confirmPasswordTF.delegate = self
        self.nameTF.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
