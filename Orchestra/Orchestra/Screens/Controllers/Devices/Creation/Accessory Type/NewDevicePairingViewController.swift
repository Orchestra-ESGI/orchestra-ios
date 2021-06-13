//
//  NewDevicePairingViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/05/2021.
//

import UIKit

class NewDevicePairingViewController: UIViewController {
    @IBOutlet weak var accessoriesTableView: UITableView!
    
    // MARK: - Local data
    var deviceVM: DeviceViewModel?
    
    var accessories: [SupportedAccessoriesDto] = []
    
    // MARK: - Utils
    let notificationsUtils = NotificationsUtils.shared
    let localizeNotifications = NotificationLocalizableUtils.shared
    let localizeLabel = ScreensLabelLocalizableUtils.shared
    let progressUtils = ProgressUtils.shared
    
    var device: HubAccessoryConfigurationDto?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.deviceVM = DeviceViewModel(navigationCtrl: self.navigationController!)
        
        self.setupUI()
        self.setUpTableView()
        
        // listen on VM response
        self.accessoriesConfigObserve()
        // Listen to api call back with config
        self.deviceVM!.getSupportedAccessories()
        self.progressUtils.displayIndeterminateProgeress(title: self.localizeNotifications.undeterminedProgressViewTitle, view: (UIApplication.shared.windows[0].rootViewController?.view)!)
    }
    
    private func setupUI(){
        if(self.device == nil){
            self.title = self.localizeLabel.newDeviceVcTitle
        }else{
            // Set config title
            self.title = "Configurer un appareil"
        }
    }
    
    private func setUpTableView(){
        self.accessoriesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ACCESSORY_ROW")
        self.accessoriesTableView.tableFooterView = UIView()
        self.accessoriesTableView.delegate = self
        self.accessoriesTableView.dataSource = self
    }
    
    private func accessoriesConfigObserve(){
        _ = self.deviceVM!.supportedAccessoriesStrem
            .subscribe { accessories in
                self.accessories = accessories
                self.progressUtils.dismiss()
                self.progressUtils.displayCheckMark(title: self.localizeNotifications.configFinishedProgressViewTitle, view: (UIApplication.shared.windows[0].rootViewController?.view)!)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.progressUtils.dismiss()
                    self.accessoriesTableView.reloadData()
                }
        } onError: { err in
            self.notificationsUtils.showBasicBanner(title: "Une erreur est survenue", subtitle: "Impossible de récupérer la configartion actuelle du Hub", position: .top, style: .danger)
        }

    }
    
    private func getAccessoryType(confType: String) -> HubAccessoryType {
        switch confType {
        case "lightbulb":
            return .LightBulb
        case "statelessProgrammableSwitch":
            return .LightBulb
        case "occupancySensor":
            return .OccupancySensor
        default:
            return .Unknown
        }
    }

}

extension NewDevicePairingViewController: UITableViewDelegate{
    
}

extension NewDevicePairingViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accessories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ACCESSORY_ROW")!
        cell.textLabel?.text = self.accessories[indexPath.row].brand
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected accessory type at position: \(indexPath.row)")
        tableView.cellForRow(at: indexPath)?.isSelected = false
        let devicesVc = DevicesViewController()
        devicesVc.devices = self.accessories[indexPath.row].devices
        devicesVc.brand = self.accessories[indexPath.row].brand
        devicesVc.device = self.device
        self.navigationController?.pushViewController(devicesVc, animated: true)
    }
    
}
