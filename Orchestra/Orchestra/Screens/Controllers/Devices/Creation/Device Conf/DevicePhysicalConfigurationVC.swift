//
//  DevicePhysicalConfigurationVC.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 03/06/2021.
//

import UIKit

class DevicePhysicalConfigurationVC: UIViewController {

    @IBOutlet weak var indicationLabelText: UILabel!
    
    @IBOutlet weak var firstStepTv: UITextView!
    @IBOutlet weak var secondStepTv: UITextView!
    @IBOutlet weak var secondStepScreenShot: UIImageView!
    @IBOutlet weak var thirdStepTv: UITextView!
    
    var continueAppBarButton: UIBarButtonItem?
    let labelLocalization = ScreensLabelLocalizableUtils.shared
    
    var deviceDocumentationUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.indicationLabelText.text = self.labelLocalization.configurationScreenHeaderText
        self.setUpTopBar()
        self.setUpSteps()
    }
    
    private func setUpTopBar(){
        let screenTitle = self.labelLocalization.configurationScreenTitle
        let continueButtonTitle = self.labelLocalization.configurationScreenContinueButton
        
        self.title = screenTitle
        continueAppBarButton = UIBarButtonItem(title: continueButtonTitle, style: .done, target: self, action: #selector(self.searchDevice))
        self.navigationItem.rightBarButtonItem = continueAppBarButton
    }
    
    private func setUpSteps(){
        let step1Text = self.labelLocalization.configurationScreenStep1Text
        let step2Text = self.labelLocalization.configurationScreenStep2Text
        let step3Text = self.labelLocalization.configurationScreenStep3Text
        
        self.firstStepTv.text = step1Text + self.deviceDocumentationUrl
        self.secondStepTv.text = step2Text
        self.thirdStepTv.text = step3Text
        
        self.secondStepScreenShot.contentMode = .scaleAspectFill
        self.secondStepScreenShot.layer.borderWidth = 1.0
        if self.traitCollection.userInterfaceStyle == .dark {
            self.secondStepScreenShot.layer.borderColor  = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }else{
            self.secondStepScreenShot.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        self.secondStepScreenShot.layer.cornerRadius = 10.0
        self.secondStepScreenShot.image = UIImage(named: "pairing_screen_shot")
    }

    @objc func searchDevice(){
        let alertTitle = self.labelLocalization.configurationScreenAlertTitle
        let alertMessage = self.labelLocalization.configurationScreenAlertMessage
        let alertActionText = self.labelLocalization.configurationScreenAlertActionTitle
        
        let alert = UIAlertController(title: alertTitle,
                                      message: alertMessage,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: alertActionText, style: .cancel) { action in
            self.navigationController?.pushViewController(HomeViewController(), animated: false)
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

}
