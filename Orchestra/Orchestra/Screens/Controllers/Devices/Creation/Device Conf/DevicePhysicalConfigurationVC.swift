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
    
    var deviceDocumentationUrl: String = ""
    var deviceData: HubAccessoryConfigurationDto?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpTopBar()
        self.setUpSteps()
    }
    
    private func setUpTopBar(){
        self.title = "Configuration"
        continueAppBarButton = UIBarButtonItem(title: "Continuer", style: .done, target: self, action: #selector(self.searchDevice))
        self.navigationItem.rightBarButtonItem = continueAppBarButton
    }
    
    private func setUpSteps(){
        self.firstStepTv.text = "1. Suivez le lien suivant: " + self.deviceDocumentationUrl
        self.secondStepTv.text = "2. Allez dans la section #Pairing "
        self.thirdStepTv.text = "3. Suivez les instructions pour appairer votre objet"
        
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
        let searchVC = SearchDeviceViewController()
        searchVC.deviceData = deviceData
        searchVC.isSuccessfulyAdded = false
        self.navigationController?.pushViewController(searchVC, animated: true)
    }

}
