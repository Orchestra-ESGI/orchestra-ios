//
//  DeviceCreationFormViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 02/06/2021.
//

import UIKit
import RxCocoa
import RxSwift
import ObjectMapper

class DeviceCreationFormViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - UI
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var deviceNameTextField: UITextField!
    
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var roomNameTextField: UITextField!
    
    @IBOutlet weak var deviceBackgroundColorsCollectionView: UICollectionView!
    
    @IBOutlet weak var addDeviceToFavLabel: UILabel!
    @IBOutlet weak var favDeviceSwitch: UISwitch!
    
    var validateFormAppBarBtn: UIBarButtonItem?
    
    // MARK: - Local data
    var deviceFavState = false
    var accessoryType: String = ""
    var accessoryDocUrl: String = ""
    var brand: String = ""
    var deviceBackgrounds: [UIColor] = []
    var selectedColor = 0
    let disposebag = DisposeBag()
    var isDeviceDocumented = false // Depending on the field 'documentation' in the conf
    var deviceViewModel: DeviceViewModel?
    var deviceInfo: SupportedDevicesInformationsDto?
    var device: HubAccessoryConfigurationDto?
    let labelLocalize = ScreensLabelLocalizableUtils.shared
    let notificationLocalization = NotificationLocalizableUtils.shared
    let notificationUtils = NotificationsUtils.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.deviceViewModel = DeviceViewModel(navigationCtrl: self.navigationController!)
        self.setTopBar()
        self.setUpTextFields()
        self.setUpStreamsObserver()
        self.setUpclickObservers()
        self.setColorsCollectionView()
        self.localizeUI()
    }
    
    private func setTopBar(){
        self.setTitle()
        
        validateFormAppBarBtn = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: nil)
        validateFormAppBarBtn?.isEnabled = true
        self.navigationItem.rightBarButtonItem = validateFormAppBarBtn
        
    }
    
    private func localizeUI(){
        self.deviceNameLabel.text = self.labelLocalize.deviceFormVcDeviceName
        self.roomNameLabel.text = self.labelLocalize.deviceFormVcRoomName
    }
    
    private func setUpclickObservers(){
        _ = self.validateFormAppBarBtn!.rx.tap.bind{
            let deviceData = self.createDevice()
            if(self.isDeviceDocumented){
                let deviceConfVC = DevicePhysicalConfigurationVC()
                deviceConfVC.deviceDocumentationUrl = self.accessoryDocUrl
                self.navigationController?.pushViewController(deviceConfVC, animated: true)
            }else{
                self.deviceViewModel?.saveDevice(deviceData: deviceData)
                let searchVC = SearchDeviceViewController()
                searchVC.deviceData = deviceData
                searchVC.isSuccessfulyAdded = true
                self.navigationController?.pushViewController(searchVC, animated: true)
            }
        }.disposed(by: self.disposebag)
    }
    
    private func setUpStreamsObserver(){
        _ = self.deviceViewModel!
            .deviceFormCompleted
            .subscribe { isValid in
                if isValid {
                    self.validateFormAppBarBtn?.isEnabled = true
                }else{
                    self.validateFormAppBarBtn?.isEnabled = false
                }
            } onError: { err in
                let notificationTitle = self.notificationLocalization.deviceFormInvalidFormNotificationTitle
                let notificationSubtitle = self.notificationLocalization.deviceFormInvalidFormNotificationSubtitle
                self.notificationUtils.showFloatingNotificationBanner(title: notificationTitle,
                                                                      subtitle: notificationSubtitle,
                                                                      position: .top,
                                                                      style: .warning)
            }
    }
    
    private func setColorsCollectionView(){
        self.deviceBackgroundColorsCollectionView.delegate = self
        self.deviceBackgroundColorsCollectionView.dataSource = self
        self.deviceBackgroundColorsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "COLOR_CELL")
        self.generatesBackGroundColor()
        self.deviceBackgroundColorsCollectionView.reloadData()
    }
    
    private func setTitle(){
        self.title = self.labelLocalize.deviceFormVcTitle
    }
    
    private func setUpTextFields(){
        self.deviceNameTextField.delegate = self
        self.roomNameTextField.delegate = self
    }

    @IBAction func shuffleColors(_ sender: Any) {
        self.deviceBackgrounds.removeAll()
        self.generatesBackGroundColor()
        self.deviceBackgroundColorsCollectionView.reloadData()
    }
    
    @IBAction func switchFavState(_ sender: Any) {
        self.deviceFavState = ((sender as? UISwitch)?.isOn)!
    }
    
    private func generatesBackGroundColor(){
        ColorUtils.shared.generatesBackGroundColor(colorArray: &self.deviceBackgrounds, size: 6)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField === self.deviceNameTextField){
            textField.resignFirstResponder()
            self.roomNameTextField.becomeFirstResponder()
        } else{
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    // Never call this func before checking all the form
    private func createDevice() -> HubAccessoryConfigurationDto{
        let newDeviceMap: [String: Any] = [
            "type": self.accessoryType,
            "name": self.deviceNameTextField.text!,
            "manufacturer": self.device?.manufacturer,
            "room_name": self.roomNameTextField.text!,
            "background_color": self.deviceBackgrounds[selectedColor].toHexString(),
            "model": self.device?.model,
            "friendly_name": self.device?.friendlyName
        ]
        
        
        
        return Mapper<HubAccessoryConfigurationDto>().map(JSON: newDeviceMap)!
    }
}


protocol SendDeviceProtocol {
    func save(device: HubAccessoryConfigurationDto)
}
