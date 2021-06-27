//
//  DevicesAvailableForSceneViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 12/06/2021.
//

import UIKit

class DevicesAvailableForSceneViewController: UIViewController {

    @IBOutlet weak var devicesAvailableTableView: UITableView!
    
    let progressUtils = ProgressUtils.shared
    
    var devicesAvailable : [HubAccessoryConfigurationDto] = []
    var deviceVM: DeviceViewModel?
    let alertUtils = AlertUtils.shared
    let labelLocalization = ScreensLabelLocalizableUtils.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpTableView()
        
        self.deviceVM = DeviceViewModel(navigationCtrl: self.navigationController!)
        let progressTitle = self.labelLocalization.loadingDeviceForSceneProgressAlertTitle
        self.progressUtils.displayIndeterminateProgeress(title: progressTitle, view: (UIApplication.shared.windows[0].rootViewController?.view)!)
        
        
        _ = self.deviceVM!.deviceConfig.getCurrentAccessoriesConfig().subscribe { finished in
            print("fini")
        } onError: { err in
            print("ko")
        }

        _ = self.deviceVM!
            .deviceConfig
            .configurationStream
            .subscribe { devices in
                self.progressUtils.dismiss()
                self.devicesAvailable = devices
                self.devicesAvailableTableView.reloadData()
        } onError: { err in
            print("error while fetching devices for scene")
        } onCompleted: {
            print("onCompleted() called in setScenesStreamObserver()")
            self.progressUtils.dismiss()
            let alertMessage = self.labelLocalization.localNetworkAuthAlertMessage
            self.alertUtils.goToParamsAlert(message: alertMessage, for: self)
        }
        
        
        self.title = self.labelLocalization.deviceAvailableScreenTitle
    }

    private func setUpTableView(){
        self.devicesAvailableTableView.dataSource = self
        self.devicesAvailableTableView.delegate = self
        
        // CELLS
        self.devicesAvailableTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DEVICE_AVAILABLE")
    }
}

extension DevicesAvailableForSceneViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.devicesAvailable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DEVICE_AVAILABLE")!
        cell.textLabel?.text = self.devicesAvailable[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let actionsVc = ActionsForDeviceAvailableViewController()
        actionsVc.deviceName = self.devicesAvailable[indexPath.row].name!
        actionsVc.actions = self.devicesAvailable[indexPath.row].actions!
        self.navigationController?.pushViewController(actionsVc, animated: true)
    }
    
}

extension DevicesAvailableForSceneViewController: UITableViewDelegate{
    
}
