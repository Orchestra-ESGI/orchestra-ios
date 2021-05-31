//
//  DevicesViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/05/2021.
//

import UIKit

class DevicesViewController: UIViewController {
    @IBOutlet weak var devicesTableView: UITableView!
    
    // MARK: - Local data
    let deviceVM = DeviceViewModel()
    var devices: [SupportedDevicesDto] = []
    var accessoryType = ""
    
    // MARK: - Utils
    let notificationsUtils = NotificationsUtils.shared
    let localizeNotifications = NotificationLocalizableUtils.shared
    let progressUtils = ProgressUtils.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setUpTableView()
    }
    
    private func setupUI(){
        self.title = self.accessoryType
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
        do {
            let url = URL(string: currentDevice.image)!
            let data = try Data(contentsOf: url)
            cell.accessoryImageView.image = UIImage(data: data)
        }
        catch{
            print(error)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        print("Selected device: \(self.devices[indexPath.row].name)")
    }
    
}

