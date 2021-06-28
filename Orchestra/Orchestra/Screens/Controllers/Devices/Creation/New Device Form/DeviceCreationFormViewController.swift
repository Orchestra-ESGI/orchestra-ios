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
    var onDoneBlock : (() -> Void)?
    
    var validateFormAppBarBtn: UIBarButtonItem?
    
    // MARK: - Local data
    let disposebag = DisposeBag()
    
    var accessoryType: String = ""
    var accessoryDocUrl: String = ""
    var deviceBackgrounds: [UIColor] = []
    var selectedColor = 0
    var isDeviceDocumented = false // Depending on the field 'documentation' in the conf
    private var slectedRoom = PublishSubject<String>()
    
    var deviceViewModel: DeviceViewModel?
    
    let labelLocalize = ScreensLabelLocalizableUtils.shared
    let notificationLocalization = NotificationLocalizableUtils.shared
    let notificationUtils = NotificationsUtils.shared
    
    var deviceInfo: SupportedDevicesInformationsDto?
    var device: HubAccessoryConfigurationDto?
    var isDeviceUpdate = false
    var rooms: [String] = []
    
    private lazy var pickerViewPresenter: PickerViewPresenter = {
        let pickerViewPresenter = PickerViewPresenter()
        pickerViewPresenter.items = self.rooms
        pickerViewPresenter.didSelectItem = { [weak self] item in
            self?.slectedRoom.onNext(item)
        }
        return pickerViewPresenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fillLocalizedRooms()
        self.roomNameTextField.text = self.rooms[0]
        self.view.addSubview(pickerViewPresenter)
        
        roomNameTextField.rightViewMode = .always
        let rightTextFieldImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let rightChevronImage = UIImage(systemName: "chevron.down")
        rightTextFieldImageView.image = rightChevronImage
        roomNameTextField.rightView = rightTextFieldImageView
        
        self.deviceViewModel = DeviceViewModel(navigationCtrl: self.navigationController!)
        self.setTopBar()
        self.setUpTextFields()
        self.setUpStreamsObserver()
        self.setUpclickObservers()
        self.setColorsCollectionView()
        self.localizeUI()
        self.validateFormAppBarBtn?.isEnabled = false
    }
    
    private func fillLocalizedRooms(){
        self.rooms.append(self.labelLocalize.deviceUpdatePickerViewLivingRoom)
        self.rooms.append(self.labelLocalize.deviceUpdatePickerViewLobby)
        self.rooms.append(self.labelLocalize.deviceUpdatePickerViewBedroom)
        self.rooms.append(self.labelLocalize.deviceUpdatePickerViewKitchen)
        self.rooms.append(self.labelLocalize.deviceUpdatePickerViewBathroom)
        self.rooms.append(self.labelLocalize.deviceUpdatePickerViewGarage)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == self.deviceNameTextField){
            return true
        }else if(textField == self.roomNameTextField){
            pickerViewPresenter.showPicker()
            return false
        }
        return true
    }
    
    private func setTopBar(){
        self.setTitle()
        
        validateFormAppBarBtn = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: nil)
        validateFormAppBarBtn?.isEnabled = true
        self.navigationItem.rightBarButtonItem = validateFormAppBarBtn
        
    }
    
    @objc private func showPickerView() {
        pickerViewPresenter.showPicker()
    }
    
    private func localizeUI(){
        self.deviceNameLabel.text = self.labelLocalize.deviceFormVcDeviceName
        self.roomNameLabel.text = self.labelLocalize.deviceFormVcRoomName
    }
    
    private func setUpclickObservers(){
        _ = self.slectedRoom.subscribe { roomName in
            self.roomNameTextField.text = roomName
        }
        
        _ = self.validateFormAppBarBtn!
            .rx
            .tap.bind{
                let deviceData = self.createDevice()
                if(self.isDeviceDocumented){
                    let deviceConfVC = DevicePhysicalConfigurationVC()
                    deviceConfVC.deviceDocumentationUrl = self.accessoryDocUrl
                    self.navigationController?.pushViewController(deviceConfVC, animated: true)
                }else{
                    if(self.isDeviceUpdate){
                        // Update device
                        self.deviceViewModel?.updateDevice(deviceData: deviceData)
                        let searchVC = SearchDeviceViewController()
                        searchVC.onDoneBlock = self.onDoneBlock
                        searchVC.deviceData = deviceData
                        searchVC.isSuccessfulyAdded = true
                        self.navigationController?.pushViewController(searchVC, animated: true)
                    }
                }
        }.disposed(by: self.disposebag)
    }
    
    private func setUpStreamsObserver(){
        _ = self.deviceViewModel!
            .deviceFormCompleted
            .subscribe { isValid in
                self.validateFormAppBarBtn?.isEnabled = isValid
            } onError: { err in
                let notificationTitle = self.notificationLocalization.deviceFormInvalidFormNotificationTitle
                let notificationSubtitle = self.notificationLocalization.deviceFormInvalidFormNotificationSubtitle
                self.notificationUtils.showFloatingNotificationBanner(title: notificationTitle,
                                                                      subtitle: notificationSubtitle,
                                                                      position: .top,
                                                                      style: .warning)
            }
        
        _ = self.deviceNameTextField
            .rx
            .controlEvent([.editingChanged])
            .asObservable().subscribe({ [unowned self] _ in
                if(!(roomNameTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
                    let deviceNameLength = self.deviceNameTextField.text?.count ?? 0
                    let roomNameLength = self.roomNameTextField.text?.count ?? 0
                    if(roomNameLength > 0 && deviceNameLength > 0){
                        self.deviceViewModel?.deviceFormCompleted.onNext(true)
                    }else{
                        self.deviceViewModel?.deviceFormCompleted.onNext(false)
                    }
                }
            })
        
//        _ = self.roomNameTextField
//            .rx
//            .controlEvent([.valueChanged])
//            .asObservable().subscribe({ [unowned self] _ in
//                if(!(roomNameTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
//                    let deviceNameLength = self.deviceNameTextField.text?.count ?? 0
//                    let roomNameLength = self.roomNameTextField.text?.count ?? 0
//                    if(roomNameLength > 0 && deviceNameLength > 0){
//                        self.deviceViewModel?.deviceFormCompleted.onNext(true)
//                    }else{
//                        self.deviceViewModel?.deviceFormCompleted.onNext(false)
//                    }
//                }else{
//                    self.deviceViewModel?.deviceFormCompleted.onError(FormValidationError.roomNameMissing)
//                }
//            })
    }
    
    
    private func setColorsCollectionView(){
        self.deviceBackgroundColorsCollectionView.delegate = self
        self.deviceBackgroundColorsCollectionView.dataSource = self
        self.deviceBackgroundColorsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "COLOR_CELL")
        self.generatesBackGroundColor()
        self.deviceBackgroundColorsCollectionView.reloadData()
    }
    
    private func setTitle(){
        if(self.isDeviceUpdate){
            self.title = self.labelLocalize.deviceFormVcUpdateTitle
        }else{
            self.title = self.labelLocalize.deviceFormVcTitle
        }
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
            "room": self.device?.room,
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

enum FormValidationError: Error{
    case deviceNameMissing
    case roomNameMissing
}
