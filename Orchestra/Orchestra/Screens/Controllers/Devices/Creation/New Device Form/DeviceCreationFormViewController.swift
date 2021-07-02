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
    private var selectedRoom = PublishSubject<String>()
    private var selectedRoomIndex: Int?
    private var currentRoom : RoomDto?
    
    var deviceViewModel: DeviceViewModel?
    var homeViewModel: HomeViewModel?
    
    let labelLocalization = ScreensLabelLocalizableUtils.shared
    let notificationLocalization = NotificationLocalizableUtils.shared
    let notificationUtils = NotificationsUtils.shared
    let alertUtils = AlertUtils.shared
    
    var deviceInfo: SupportedDevicesInformationsDto?
    var device: HubAccessoryConfigurationDto?
    var isDeviceUpdate = false
    var rooms: [RoomDto] = []
    
    private lazy var pickerViewPresenter: PickerViewPresenter = {
        let roomsName = self.rooms.map { room -> String in
            return room.name ?? ""
        }
        let pickerViewPresenter = PickerViewPresenter(1, items: roomsName, closePickerCompletion: didClosePickerView)
        return pickerViewPresenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeViewModel = HomeViewModel(navCtrl: self.navigationController!)
        self.deviceViewModel = DeviceViewModel(navigationCtrl: self.navigationController!)
        
        roomNameTextField.rightViewMode = .always
        let rightTextFieldImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let rightChevronImage = UIImage(systemName: "chevron.down")
        rightTextFieldImageView.image = rightChevronImage
        roomNameTextField.rightView = rightTextFieldImageView
        
        self.getHubRooms()
        
        self.setTopBar()
        self.setUpTextFields()
        self.setUpStreamsObserver()
        self.setUpclickObservers()
        self.setColorsCollectionView()
        self.localizeUI()
        self.validateFormAppBarBtn?.isEnabled = false
    }
    
    @objc func doneButtonClick(){
        self.pickerViewPresenter.resignFirstResponder()
    }
    
    func didClosePickerView(data: Any){
        if let index = data as? Int{
            self.selectedRoomIndex = index
            self.selectedRoom.onNext(self.rooms[index].name!)
        }
    }

    private func getHubRooms(){
        _ = self.homeViewModel!.getAllRooms().subscribe { rooms in
            self.rooms = rooms
            self.currentRoom = rooms[0]
            self.roomNameTextField.text = NSLocalizedString(rooms[0].name ?? "", comment: "")
            self.view.addSubview(self.pickerViewPresenter)
        } onError: { err in
            print("err")
        }
    }
    
    @objc func handleBackClick(sender: UIBarButtonItem) {
        let sceneNameLength = self.deviceNameTextField.text?.count ?? 0
        let sceneDescriptionLength = self.roomNameTextField.text?.count ?? 0
        if( sceneNameLength > 0 || sceneDescriptionLength > 0){
            let alertTitle = self.notificationLocalization.sceneCancelAlertTitle
            let alertMessage = self.notificationLocalization.sceneCancelAlertMessage
            let continueActionTitle = self.notificationLocalization.sceneCancelAlertContinueButton
            let cancelActionTitle = self.notificationLocalization.sceneCancelAlertCancelButton
            
            let alertCancelAction = UIAlertAction(title: cancelActionTitle,
                                                  style: .cancel){ action in
            }
            let alertContinuelAction = UIAlertAction(title: continueActionTitle, style: .destructive) { action in
                self.navigationController?.popViewController(animated: true)
            }
            
            self.alertUtils.showAlert(for: self,
                                      title: alertTitle,
                                      message: alertMessage,
                                      actions: [alertCancelAction, alertContinuelAction])
        }else{
            self.navigationController?.popViewController(animated: true)
        }
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
        
        self.navigationItem.hidesBackButton = true
        let backButtonLabel = self.labelLocalization.sceneBackNavBarButton
        let newBackButton = UIBarButtonItem(title: backButtonLabel, style: .plain, target: self, action: #selector(handleBackClick(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        validateFormAppBarBtn = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: nil)
        validateFormAppBarBtn?.isEnabled = true
        self.navigationItem.rightBarButtonItem = validateFormAppBarBtn
        
    }
    
    @objc private func showPickerView() {
        pickerViewPresenter.showPicker()
    }
    
    private func localizeUI(){
        self.deviceNameLabel.text = self.labelLocalization.deviceFormVcDeviceName
        self.roomNameLabel.text = self.labelLocalization.deviceFormVcRoomName
    }
    
    private func setUpclickObservers(){
        _ = self.selectedRoom.subscribe { roomName in
            self.currentRoom = self.rooms[self.selectedRoomIndex ?? 0]
            let roomNameLocalized = NSLocalizedString(roomName.element ?? "", comment: "")
            self.roomNameTextField.text = roomNameLocalized
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
            self.title = self.labelLocalization.deviceFormVcUpdateTitle
        }else{
            self.title = self.labelLocalization.deviceFormVcTitle
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
    private func createDevice() -> [String: Any]{
        let newDeviceMap: [String: Any] = [
            "type": self.accessoryType,
            "name": self.deviceNameTextField.text!,
            "manufacturer": self.device?.manufacturer ?? "",
            "room": [
                "_id": self.currentRoom?.id ?? "",
                "name": self.currentRoom?.name ?? ""
            ],
            "background_color": self.deviceBackgrounds[selectedColor].toHexString(),
            "model": self.device?.model ?? "",
            "friendly_name": self.device?.friendlyName ?? ""
        ]
        
        
        
        return newDeviceMap
    }
}


protocol SendDeviceProtocol {
    func save(device: HubAccessoryConfigurationDto)
}

enum FormValidationError: Error{
    case deviceNameMissing
    case roomNameMissing
}
