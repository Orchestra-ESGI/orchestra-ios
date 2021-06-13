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
    let progressUtils = ProgressUtils.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.deviceVM = DeviceViewModel(navigationCtrl: self.navigationController!)
        self.setupUI()
        self.setUpTableView()
    }
    
    private func setupUI(){
        self.title = self.brand
    }
    
    private func setUpTableView(){
        self.devicesTableView.register(UINib(nibName: "DeviceTableViewCell", bundle: nil), forCellReuseIdentifier: "DEVICE_ROW")
        self.devicesTableView.tableFooterView = UIView()
        self.devicesTableView.delegate = self
        self.devicesTableView.dataSource = self
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

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        print("Selected device: \(self.devices[indexPath.row].name)")
        let deviceCreationFormVC = DeviceCreationFormViewController()
        deviceCreationFormVC.accessoryType = self.devices[indexPath.row].type
        deviceCreationFormVC.brand = self.brand
        if let documentationUrl = self.devices[indexPath.row].doc_url {
            deviceCreationFormVC.isDeviceDocumented = true
            deviceCreationFormVC.accessoryDocUrl = documentationUrl
        }
        deviceCreationFormVC.deviceInfo = self.devices[indexPath.row]
        self.navigationController?.pushViewController(deviceCreationFormVC, animated: true)
    }
    
    
}
