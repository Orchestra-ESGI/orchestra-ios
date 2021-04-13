//
//  SigninViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 04/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class SigninViewController: UIViewController {
    
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
    let userWS = FakeUserServices.shared
    
    
    // - MARK: Utils
    let notificationUtils = NotificationsUtils.shared
    let notificationLocalize = NotificationLocalizableUtils.shared
    let progressUtils = ProgressUtils.shared
    let screenLocalize = ScreensLabelLocalizableUtils()
    
    let disposeBag = DisposeBag()
    
    var alert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                self.userWS.signup()
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
            .userWS
            .userSignupStream
            .subscribe(onNext: { (user) in
                self.alert!.dismiss(animated: true, completion: nil)
                self.notificationUtils
                    .showFloatingNotificationBanner(title: self.notificationLocalize.okNotificationTitle, subtitle: self.notificationLocalize.okNotificationSubtitle, position: .top, style: .success)
                
                let sceneVC = ScenesListViewController()
                sceneVC.userLoggedInData = user
                self.navigationController?.pushViewController(sceneVC, animated: true)
            }, onError: { (err) in
                self.notificationUtils.showBadCredentialsNotification()
            })
            .disposed(by: self.disposeBag)
    }
}
