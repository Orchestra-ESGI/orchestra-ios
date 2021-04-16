//
//  HubPairingViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 16/04/2021.
//

import UIKit
import RxCocoa
import RxSwift

class HubPairingViewController: UIViewController, UITextFieldDelegate {

    // MARK: - UI
    @IBOutlet weak var pairingCodeLabel: UILabel!
    @IBOutlet weak var pairingCodeTf: UITextField!
    @IBOutlet weak var whereToFindCodeButton: UIButton!
    var pairHubButton: UIBarButtonItem?
    
    @IBOutlet weak var reachableHubAroundTitle: UILabel!
    @IBOutlet weak var reachableHubAroundTableView: UITableView!
    
    
    // MARK: - Utils
    let notificationUtils = NotificationsUtils.shared
    let notificationLocalize = NotificationLocalizableUtils.shared
    let screenLabelLocalize = ScreensLabelLocalizableUtils()
    let progressUtils = ProgressUtils.shared
    
    
    // MARK: - Services
    
    
    
    // MARK: - Local data
    var hubsAround: [String] = ["Hub Philips Hue", "Hub IKEA", "Hub Xiaomi"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.localizeLabels()
        self.setUpTopBar()
        self.setUpTableView()
        self.setUpClickObservers()
        self.setUpTextFields()
    }
    
    
    // MARK: UI setup
    private func setUpTopBar(){
        self.title = self.screenLabelLocalize.hubPairingVcTitle
        
        pairHubButton = UIBarButtonItem(image: UIImage(systemName: "paperplane.fill"), style: .done, target: self, action: nil)
        pairHubButton?.tintColor = #colorLiteral(red: 2.387956192e-05, green: 0.5332912803, blue: 0.8063663244, alpha: 1)
        
        self.navigationItem.rightBarButtonItem = pairHubButton
        
    }
    
    private func setUpTableView(){
        self.reachableHubAroundTableView.delegate = self
        self.reachableHubAroundTableView.dataSource = self
        self.reachableHubAroundTableView.register(UITableViewCell.self, forCellReuseIdentifier: "HUB_CELL")
        self.reachableHubAroundTableView.tableFooterView = UIView()
    }
    
    private func setUpTextFields(){
        self.pairingCodeTf.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    private func localizeLabels(){
        self.pairingCodeLabel.text = self.screenLabelLocalize.hubPairingVcPairingCodeLabel
        self.reachableHubAroundTitle.text = self.screenLabelLocalize.hubPairingVcReachableHubLabel
    }
    
    
    // MARK: Observer setup
    private func setUpClickObservers(){
        _ = self.whereToFindCodeButton
            .rx
            .tap.bind{
                self.showIndicationAlert()
            }
        
        _ = self.pairHubButton?
            .rx
            .tap.bind{
                self.tryPairingPhoneAndHub()
            }
    }
    
    
    // MARK: Local functions
    private func showIndicationAlert(){
        let alertTitle = self.screenLabelLocalize.hubPairingAlertInfoTitle
        let alertBodyText = self.screenLabelLocalize.hubPairingAlertInfoBodyText
        let alertOkActionTitle = self.screenLabelLocalize.hubPairingAlertInfoOkButtonText
        
        let alert = UIAlertController(title: alertTitle, message: alertBodyText, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: alertOkActionTitle, style: .default, handler: nil))

        self.present(alert, animated: true)
    }
    
    private func tryPairingPhoneAndHub(){
        let alertTitle = self.screenLabelLocalize.hubPairingProgressAlertTitle
        self.progressUtils.displayIndeterminateProgeress(title: alertTitle, view: self.view)
    }

}

extension HubPairingViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hubsAround.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HUB_CELL")!
        cell.textLabel?.text = self.hubsAround[indexPath.row]
        return cell
    }
    
}


extension HubPairingViewController: UITableViewDelegate{
    
}
