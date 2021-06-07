//
//  SearchDeviceViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 03/06/2021.
//

import UIKit

class SearchDeviceViewController: UIViewController {

    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var successTitle: UILabel!
    @IBOutlet weak var successImageView: UIImageView!
    @IBOutlet weak var returnHomeBtn: UIButton!
    
    var deviceData: HubAccessoryConfigurationDto?
    var deviceVM: DeviceViewModel?
    let progressUtil = ProgressUtils.shared
    var isSuccessfulyAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.deviceVM = DeviceViewModel(navigationCtrl: self.navigationController!)
        
        self.setUpTopBar()
        self.returnHomeBtn.layer.cornerRadius = 23.0
        self.setUpViews()
    }

    private func setUpTopBar(){
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @IBAction func returnHome(_ sender: Any) {
        if(self.isSuccessfulyAdded){
            self.navigationController?.pushViewController(HomeViewController(), animated: false)
//            self.deviceData?.friendlyName = StringUtils.shared.generateFakeId(length: 20)
//            self.deviceData?.isReachable = true
//            self.deviceVM!.saveDevice(deviceData: self.deviceData!)
            
        }else{
            // do something to retry adding device
            self.progressUtil.displayIndeterminateProgeress(title: "Veuillez patienter...", view: (UIApplication.shared.windows[0].rootViewController?.view)!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isSuccessfulyAdded = true
                self.setUpViews()
                self.progressUtil.dismiss()
                self.progressUtil.displayCheckMark(title: "Succès!", view: (UIApplication.shared.windows[0].rootViewController?.view)!)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.progressUtil.dismiss()
                }
            }
        }
    }
    
    private func setUpViews(){
        if( isSuccessfulyAdded){
            self.successImageView.image = UIImage(named: "check")
            self.successTitle.text = "C'est fait!"
            self.successTitle.textColor = #colorLiteral(red: 0.177152276, green: 0.669238627, blue: 0.3678025007, alpha: 1)
            self.successLabel.text = "Votre objet a été correctement créé!"
            self.returnHomeBtn.backgroundColor = #colorLiteral(red: 0.177152276, green: 0.669238627, blue: 0.3678025007, alpha: 1)
            self.returnHomeBtn.setTitle("Revenir à l'accueil", for: .normal)
        }else{
            self.successImageView.image = UIImage(named: "cancel")
            self.successTitle.text = "Oops!"
            self.successTitle.textColor = #colorLiteral(red: 1, green: 0.2390179634, blue: 0.2027955651, alpha: 1)
            self.successLabel.text = "Un problème est survenu durant l'ajout!"
            self.returnHomeBtn.backgroundColor = #colorLiteral(red: 1, green: 0.2390179634, blue: 0.2027955651, alpha: 1)
            self.returnHomeBtn.setTitle("Réessayer", for: .normal)
        }
    }
    
    
}
