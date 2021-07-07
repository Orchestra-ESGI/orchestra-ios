//
//  DevicesViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/05/2021.
//

import UIKit
import RxCocoa
import RxSwift


class DevicesViewController: UIViewController {
    @IBOutlet weak var devicesTableView: UITableView!
    
    // MARK: - Local data
    var deviceVM: DeviceViewModel?
    var devices: [SupportedDevicesInformationsDto] = []
    var brand: String = ""
    
    // MARK: - Utils
    let notificationsUtils = NotificationsUtils.shared
    let localizeNotifications = NotificationLocalizableUtils.shared
    let labelLocalization = ScreensLabelLocalizableUtils.shared
    let progressUtils = ProgressUtils.shared
    var device: DeviceDto?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.deviceVM = DeviceViewModel(navigationCtrl: self.navigationController!)
        self.setupUI()
        self.setUpTableView()
    }
    
    private func setupUI(){
        self.view.backgroundColor = ColorUtils.ORCHESTRA_BLUE_COLOR
        self.title = self.brand
    }
    
    private func setUpTableView(){
        self.devicesTableView.register(UINib(nibName: "DeviceTableViewCell", bundle: nil), forCellReuseIdentifier: "DEVICE_ROW")
        self.devicesTableView.tableFooterView = UIView()
        self.devicesTableView.delegate = self
        self.devicesTableView.dataSource = self
        self.devicesTableView.backgroundColor = .clear
    }
}

extension DevicesViewController: UITableViewDelegate{
    
}

extension DevicesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DEVICE_ROW") as! DeviceTableViewCell
        let currentDevice = self.devices[indexPath.row]
        cell.accessoryImageView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.accessoryNameLabel.text = currentDevice.name
        
        _ = cell.accessoryImageView
            .imageFromServerURL(currentDevice.image, placeHolder: UIImage(named: ""))
            .subscribe { finished in
                if(finished){
                    print("finished loading of the image")
                }
            } onError: { err in
                print("Error occured while fetching image for the cell at position: \(indexPath.row)")
            }
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        print("Selected device: \(self.devices[indexPath.row].name)")
        if(self.device == nil){
            if let documentationUrl = self.devices[indexPath.row].doc_url {
                let deviceConfVC = DevicePhysicalConfigurationVC()
                deviceConfVC.deviceDocumentationUrl = documentationUrl
                self.navigationController?.pushViewController(deviceConfVC, animated: true)
            }else{
                let alertTitle = self.labelLocalization.resetDeviceAlertTitle
                let alertMessage = self.labelLocalization.resetDeviceAlertMessage
                let alertResetActionString = self.labelLocalization.resetDeviceAlertActionTitle
                let alert = UIAlertController(title: alertTitle, message:alertMessage, preferredStyle: .alert)
                let resetAction = UIAlertAction(title: alertResetActionString, style: .cancel) { action in
                    self.deviceVM?.resetDevice()
                    
                    let progressTitle = self.localizeNotifications.undeterminedProgressViewTitle
                    self.progressUtils.displayIndeterminateProgeress(title: progressTitle, view: self.view)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) {
                        self.progressUtils.dismiss()
                        self.navigationController?.pushViewController(HomeViewController(), animated: true)
                    }
                }
                alert.addAction(resetAction)
                self.present(alert, animated: true)
            }
        } else {
            let deviceCreationFormVC = DeviceCreationFormViewController()
            deviceCreationFormVC.device = self.device
            deviceCreationFormVC.accessoryType = self.devices[indexPath.row].type
            if let documentationUrl = self.devices[indexPath.row].doc_url {
                deviceCreationFormVC.isDeviceDocumented = true
                deviceCreationFormVC.accessoryDocUrl = documentationUrl
            }
            deviceCreationFormVC.deviceInfo = self.devices[indexPath.row]
            self.navigationController?.pushViewController(deviceCreationFormVC, animated: true)
        }
    }
    
    
}
