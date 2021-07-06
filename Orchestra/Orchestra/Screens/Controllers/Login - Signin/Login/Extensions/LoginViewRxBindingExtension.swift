//
//  LoginViewRxBindingExtension.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 01/05/2021.
//

import Foundation
import RxSwift
import RxCocoa

extension LoginViewController{
    func setupLoginButtonBindings(){
        self.loginButton
            .rx.tap
            .bind {
                self.userVm.checkForm(emailTf: self.emailTextField, passwordTf: self.passwordTextField)
            }
            .disposed(by: self.disposeBag)
    }
    
    func setUpPasswordBindings(){
        self.passwordForgotButton
            .rx.tap
            .bind { [weak self] in
                //self.navigationController?.pushViewController(ForgotPasswordViewController(), animated: true)
                self?.notificationUtils.showBasicBanner(title: "Forgot button clicked", subtitle: "WIP", position: .bottom, style: .info)
            }
            .disposed(by: self.disposeBag)
    }
    
    func setUpSigninButtonBindings(){
        self.signupButton
            .rx.tap
            .bind { [weak self] in
                let QRCodeReaderNavController = UINavigationController(rootViewController: QRCodeReaderViewController())
                self?.present(QRCodeReaderNavController, animated: true, completion: nil)
            }
            .disposed(by: self.disposeBag)
    }
    
    func setUpProblemOccuredButtonBinding(){
        _ = self.helpButton
            .rx.tap
            .bind{
                let cancelAlertAction = self.notificationLocalize.homeWarningAlertCancelAction
                let closeAlertAction = self.notificationLocalize.homeHelpAlertClose
                let warningAlertContinueAction = self.notificationLocalize.homeWarningAlertContinueAction
                
                let helpAlertFaqAction = self.notificationLocalize.homeHelpAlertActionFaq
                let helpRebootHubAction = self.notificationLocalize.homeHelpAlertResetAction
                
                let alertTitle = self.notificationLocalize.homeHelpAlertTitle
                let alertMessage = self.notificationLocalize.homeHelpAlertMessage
                
                let faqAction = UIAlertAction(title: helpAlertFaqAction, style: .default) { action in
                    let genericWebView = GenericWebViewController(pageTitle: helpAlertFaqAction,
                                                                  url: self.userVm.rootApi.FAQ_URL)
                    self.navigationController?.present(UINavigationController(rootViewController: genericWebView), animated: true)
                }
                let factoryResetAction = UIAlertAction(title: helpRebootHubAction, style: .default) { action in
                    let warningAlertTitle = self.notificationLocalize.homeWarningAlertTitle
                    let warningAlertMessage = self.notificationLocalize.homeWarningAlertMessage
                    let warningAlertContinueAction = UIAlertAction(title: warningAlertContinueAction, style: .destructive) { action in
                        self.userVm.factoryResetHub()
                    }
                    let warningAlertCancelAction = UIAlertAction(title: cancelAlertAction, style: .cancel) { action in
                    }
                    self.alertUtils.showAlert(for: self,
                                              title: warningAlertTitle,
                                              message: warningAlertMessage,
                                              actions: [warningAlertCancelAction, warningAlertContinueAction])
                }
                let cloesAction = UIAlertAction(title: closeAlertAction, style: .default) { action in

                }
                self.alertUtils.showAlert(for: self, title: alertTitle,
                                          message: alertMessage,
                                          actions: [faqAction, factoryResetAction, cloesAction])
        }
    }
    
    func setUpPrivacyPolicyButtonBinding(){
        _ = self.privacyPolicyButton
            .rx.tap.bind{
                let privacyPolicyLabel = self.labelLocalization.privacyLabelText
                let genericWebView = GenericWebViewController(pageTitle: privacyPolicyLabel,
                                                              url: self.userVm.rootApi.PRIVACY_URL)
                self.navigationController?.present(UINavigationController(rootViewController: genericWebView), animated: true)
        }
    }
}
