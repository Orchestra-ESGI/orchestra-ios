//
//  SceneViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 07/04/2021.
//

import UIKit
import RxCocoa
import RxSwift
import ObjectMapper

class SceneViewController: UIViewController, UITextFieldDelegate, CloseCustomViewProtocol {
    
    // MARK: - UI
    @IBOutlet weak var sceneNameLabel: UILabel!
    @IBOutlet weak var sceneNameTf: UITextField!
    @IBOutlet weak var sceneBackgroundColorLabel: UILabel!
    @IBOutlet weak var shuffleColorsButton: UIButton!
    @IBOutlet weak var backgroudColorsCollectionView: UICollectionView!
    
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var sceneDescriptionLabel: UILabel!
    @IBOutlet weak var sceneDescriptionTf: UITextField!
    @IBOutlet weak var addActionButton: UIButton!
    @IBOutlet weak var actionsTableView: UITableView!
    
    var addSceneAppbarButon: UIBarButtonItem?
    
    // MARK: Utils
    let labelLocalization = ScreensLabelLocalizableUtils.shared
    let notificationUtils = NotificationsUtils.shared
    let progressUtils = ProgressUtils.shared
    let notificationLocalize = NotificationLocalizableUtils.shared
    let alertUtils = AlertUtils.shared
    
    // MARK: Service
    let sceneVM = SceneViewModel()
    var deviceVM: DeviceViewModel?
    
    // MARK: - Local data
    var dataDelegate: SendBackDataProtocol?
    var isUpdating: Bool = false
    var sceneToEdit: SceneDto?
    var sceneColors: [UIColor] = []
    var sceneActions: [[String: Any]] = []
    var selectedColor = 0
    let disposebag = DisposeBag()
    
    var isPopUpVisible = false
    var popUpType = 0 // 0 ---> Device , 1 ---> Actions
    var actionsName: [SceneActionsName] = []
    var filteredActionsName: [SceneActionsName] = []
    var alertDevice: DevicesAlert?
    
    // All available devices
    var devices : [HubAccessoryConfigurationDto] = []
    var deviceDict: [[String:Any]] = []
    
    var onDoneBlock : (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.deviceVM = DeviceViewModel(navigationCtrl: self.navigationController!)
        self.sceneVM.fillsceneActions(devices: self.devices)
        self.setUpStreamsObserver()
        self.localizeLabels()
        self.setUpUI()
        self.setUpTextFields()
        self.setColorsCollectionView()
        self.setActionsTableView()
        self.generatesBackGroundColor()
        self.clickObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
        }
    }
    
    // MARK: Controller Setup
    private func localizeLabels(){
        self.sceneNameLabel.text = self.labelLocalization.sceneFormNameLabel
        self.sceneBackgroundColorLabel.text = self.labelLocalization.sceneFormBackgroundColorLabel
        self.sceneDescriptionLabel.text = self.labelLocalization.sceneFormDescriptionLabel
        self.addActionButton.setTitle(self.labelLocalization.addActionButtonnText, for: .normal)
        self.sceneDescriptionTf.placeholder = self.labelLocalization.sceneFormDescriptionTf
        self.sceneNameTf.placeholder = self.labelLocalization.sceneFormNameTf
        
    }
    
    private func setUpTextFields(){
        self.sceneNameTf.delegate = self
        self.sceneDescriptionTf.delegate = self
    }
    
    private func setUpStreamsObserver(){
        _ = self.sceneVM
            .sceneValidStream
            .subscribe { isValid in
                self.addSceneAppbarButon?.isEnabled = isValid
            } onError: { err in
                let notificationTitle = self.notificationLocalize.deviceFormInvalidFormNotificationTitle
                let notificationSubtitle = self.notificationLocalize.deviceFormInvalidFormNotificationSubtitle
                self.notificationUtils.showFloatingNotificationBanner(title: notificationTitle,
                                                                      subtitle: notificationSubtitle,
                                                                      position: .top,
                                                                      style: .warning)
            }
        
        _ = self.sceneNameTf
            .rx
            .controlEvent([.editingChanged])
            .asObservable().subscribe({ [unowned self] _ in
                if(!(sceneNameTf.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
                    let deviceNameLength = self.sceneNameTf.text?.count ?? 0
                    let roomNameLength = self.sceneDescriptionTf.text?.count ?? 0
                    if(roomNameLength > 0 && deviceNameLength > 0){
                        self.sceneVM.sceneValidStream.onNext(true)
                    }else{
                        self.sceneVM.sceneValidStream.onNext(false)
                    }
                }
            })
        
        _ = self.sceneDescriptionTf
            .rx
            .controlEvent([.editingChanged])
            .asObservable().subscribe({ [unowned self] _ in
                if(!(sceneDescriptionTf.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
                    let deviceNameLength = self.sceneNameTf.text?.count ?? 0
                    let roomNameLength = self.sceneDescriptionTf.text?.count ?? 0
                    if(roomNameLength > 0 && deviceNameLength > 0){
                        self.sceneVM.sceneValidStream.onNext(true)
                    }else{
                        self.sceneVM.sceneValidStream.onNext(false)
                    }
                }
            })
    }
    
    private func setUpUI(){
        let newSceneTitle = self.labelLocalization.newSceneVcTitle
        let updateSceneTitle = self.labelLocalization.updateSceneVcTitle
        self.title = self.isUpdating ? updateSceneTitle : newSceneTitle
        
        self.navigationItem.hidesBackButton = true
        let backButtonLabel = self.labelLocalization.sceneBackNavBarButton
        let newBackButton = UIBarButtonItem(title: backButtonLabel, style: .plain, target: self, action: #selector(handleBackClick(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        addSceneAppbarButon = UIBarButtonItem(image: UIImage(systemName: "paperplane.fill"), style: .done, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = addSceneAppbarButon
        
        if(!self.isUpdating){
            self.addSceneAppbarButon?.isEnabled = false
        }
        
        self.viewContainer.frame.size.height = self.view.frame.height + 40
    }
    
    @objc func handleBackClick(sender: UIBarButtonItem) {
        if(self.isUpdating){
            self.navigationController?.popViewController(animated: true)
        }else{
            let sceneNameLength = self.sceneNameTf.text?.count ?? 0
            let sceneDescriptionLength = self.sceneDescriptionTf.text?.count ?? 0
            if( sceneNameLength > 0 || sceneDescriptionLength > 0 || self.deviceDict.count > 0){
                let alertTitle = self.notificationLocalize.sceneCancelAlertTitle
                let alertMessage = self.notificationLocalize.sceneCancelAlertMessage
                let continueActionTitle = self.notificationLocalize.sceneCancelAlertContinueButton
                let cancelActionTitle = self.notificationLocalize.sceneCancelAlertCancelButton
                
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
    }
    
    private func setColorsCollectionView(){
        self.backgroudColorsCollectionView.delegate = self
        self.backgroudColorsCollectionView.dataSource = self
        self.backgroudColorsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "COLOR_CELL")
    }
    
    private func setActionsTableView(){
        self.actionsTableView.delegate = self
        self.actionsTableView.dataSource = self
        self.actionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ACTION_CELL")
        
        self.actionsTableView.tableFooterView = UIView()
        
        if(self.isUpdating){
            var actionJson: [String: Any] = [:]
            self.sceneNameTf.text = self.sceneToEdit?.name ?? ""
            self.sceneDescriptionTf.text = self.sceneToEdit?.sceneDescription ?? ""
            var deviceDictIndex = 0
            for sceneDevice in (self.sceneToEdit?.devices ?? []){
                self.devices.filter { hubDevice in
                    return sceneDevice.friendlyName == hubDevice.friendlyName
                }.forEach { device in
                    self.parseDeviceActionToGetName(device: device)
                    let deviceFeriendlyName = device.friendlyName
                    let deviceName = device.name
                    var deviceMap: [String: Any] = [:]
                    
                    deviceMap["possible_actions"] = self.actionsName
                    deviceMap["name"] = deviceName
                    deviceMap["friendly_name"] = deviceFeriendlyName
                    var actionArray: [SceneActionsName] = []
                    for action in sceneDevice.actions{
                        var actionName = ""
                        let actionValue = action.value
                        let actionType = action.key
                        if(action.key == "brightness" || action.key == "color_temp"){
                            actionName = self.sceneVM.getSceneActionName(key: action.key, value: ((actionValue as? Int) ?? 0).description) ?? 0.description
                        }else{
                            actionName = self.sceneVM.getSceneActionName(key: action.key, value: (actionValue as? String) ?? "") ?? ""
                        }
                        let sceneActionName = SceneActionsName(key: actionName,
                                                               val: actionValue,
                                                               type: actionType)
                        if(actionType == "color"){
                            actionJson[actionType] = ["hex": actionValue]
                        }else{
                            actionJson[actionType] = actionValue
                        }
                        deviceDictIndex += 1
                        actionArray.append(sceneActionName)
                    }
                    deviceMap["actions"] = actionJson
                    deviceMap["selected_actions"] = actionArray
                    self.deviceDict.append(deviceMap)
                }
            }
            print("device dictionnary: \(self.deviceDict)")
        }
    }
    
    func setUpDevicesTableView(deviceAlert: DevicesAlert){
        deviceAlert.tableView.delegate = self
        deviceAlert.tableView.dataSource = self
        deviceAlert.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "POP_UP_CELL")
        
        deviceAlert.tableView.tableFooterView = UIView()
    }
    
    @IBAction func shuffleColors(_ sender: Any) {
        self.sceneColors.removeAll()
        self.generatesBackGroundColor()
        self.backgroudColorsCollectionView.reloadData()
    }
    
    
    @IBAction func addActionToScene(_ sender: Any) {
        self.isPopUpVisible = true
        self.popUpType = 0
        if(devices.count == 0){
            self.isPopUpVisible = false
        }else{
            let devicenameInScene = self.deviceDict.map { dict -> String in
                return dict["name"] as! String
            }
            
            self.devices = devices.filter { !devicenameInScene.contains($0.name!) }
            self.progressUtils.dismiss()
            if(self.view.subviews.count == 1){
                self.alertDevice = DevicesAlert()
                self.alertDevice?.delegate = self
                self.alertDevice?.titleLabel.text = self.labelLocalization.newSceneDeviceCustomViewTitle
                self.view.addSubview(self.alertDevice!.parentView)
                self.setUpDevicesTableView(deviceAlert: self.alertDevice!)
                self.alertDevice!.tableView.reloadData()
            }
        }
    }
    
    func hidePopUp(){
        let alertView = self.view.subviews[1].subviews[0].subviews
        for view in alertView{
            view.removeFromSuperview()
        }
        self.view.subviews[1].subviews[0].removeFromSuperview()
        
        let alertViewParent = self.view.subviews[1].subviews
        for view in alertViewParent{
            view.removeFromSuperview()
        }
        self.view.subviews[1].removeFromSuperview()
        
        if(self.actionsName.count > 0){
            self.actionsName.removeAll()
        }
    }
    
    func popOffView() {
        self.hidePopUp()
        self.isPopUpVisible = false
    }
    
    func parseDeviceActionToGetName(device: HubAccessoryConfigurationDto) {
        var actions: [String] = []
        var values: [Any] = []
        if device.actions?.state != nil {
            let onAction = self.labelLocalization.deviceActionStateOn
            let offAction = self.labelLocalization.deviceActionStateOff
            let toggleAction = self.labelLocalization.deviceActionStateToggle
            actions = [onAction, offAction, toggleAction]
            values = ["on", "off", "toggle"]
            for index in 0..<actions.count{
                let action = SceneActionsName(key: actions[index], val: values[index], type: "state")
                self.actionsName.append(action)
            }
        }
        
        if(device.actions?.brightness != nil){
            let brightnessAction100 = self.labelLocalization.deviceActionBrightness100
            let brightnessAction50 = self.labelLocalization.deviceActionBrightness50
            let brightnessAction25 = self.labelLocalization.deviceActionBrightness25
            let deviceBrightness = device.actions!.brightness!.maxVal
            actions = [brightnessAction25, brightnessAction50, brightnessAction100]
            values = [deviceBrightness/4, deviceBrightness/2, deviceBrightness]
            for index in 0..<actions.count{
                let action = SceneActionsName(key: actions[index], val: values[index], type: "brightness")
                self.actionsName.append(action)
            }
        }
        
        if(device.actions?.color != nil){
            let colorAction = self.labelLocalization.deviceActionColor
            actions = [colorAction]
            values = ["#FF0000"]
            for index in 0..<actions.count{
                let action = SceneActionsName(key: actions[index], val: values[index], type: "color")
                self.actionsName.append(action)
            }
        }
        
        if(device.actions?.colorTemp != nil){
            let temperatureAction100 = self.labelLocalization.deviceActionTemp100
            let temperatureAction50 = self.labelLocalization.deviceActionTemp50
            let temperaturection25 = self.labelLocalization.deviceActionTemp25
            let deviceMaxValue = device.actions!.colorTemp!.maxVal
            actions = [temperatureAction100, temperatureAction50, temperaturection25]
            values = [deviceMaxValue, deviceMaxValue/2, deviceMaxValue/4]
            for index in 0..<actions.count{
                let action = SceneActionsName(key: actions[index], val: values[index], type: "color_temp")
                self.actionsName.append(action)
            }
        }
    }
    
    func appendDevices(device: HubAccessoryConfigurationDto){
        let deviceFeriendlyName = device.friendlyName
        let deviceName = device.name
        //let deviceActions = self.parseDeviceActionToGetName(device: device)
        self.parseDeviceActionToGetName(device: device)
        var deviceMap: [String: Any] = [:]
        
        deviceMap["name"] = deviceName
        deviceMap["friendly_name"] = deviceFeriendlyName
        deviceMap["possible_actions"] = self.actionsName
        self.deviceDict.append(deviceMap)
        print(deviceDict)
    }
    
    // MARK: Observers Setup
    private func clickObservers(){
        _ = self.addSceneAppbarButon?
            .rx
            .tap
            .bind{
                self.addSceneAppbarButon?.isEnabled = false
                if(self.deviceDict.count == 0){
                    let alertTitle = self.notificationLocalize.sceneNoActionAlertTitle
                    let alertMessage = self.notificationLocalize.sceneNoActionAlertMessage
                    let cancelActionTitle = self.notificationLocalize.sceneNoActionAlertCancelButton
                    
                    let alertCancelAction = UIAlertAction(title: cancelActionTitle,
                                                          style: .cancel){ action in
                    }
                    
                    self.alertUtils.showAlert(for: self,
                                              title: alertTitle,
                                              message: alertMessage,
                                              actions: [alertCancelAction])
                }else{
                    let sceneToSend = self.buildSceneToSend()
                    self.sendScene(scene: sceneToSend)
                }
            }
    }
    
    private func buildSceneToSend() -> [String: Any]{
        self.progressUtils.displayV2(view: self.view, title: self.notificationLocalize.undeterminedProgressViewTitle, modeView: .MRActivityIndicatorView)
        
        var scene: [String: Any] = [:]
        scene["name"] = self.sceneNameTf.text!
        scene["color"] = self.sceneColors[self.selectedColor].toHexString()
        scene["description"] = self.sceneDescriptionTf.text!
        scene["devices"] = self.deviceDict.map({ device -> [String: Any] in
            
            let friendlyName = device["friendly_name"]!
            let actions = device["actions"]!
            return [
                "friendly_name": friendlyName,
                "actions": actions
            ]
        })
        if(self.isUpdating){
            scene["_id"] = self.sceneToEdit?.id ?? ""
        }
        
        return scene
    }
    
    private func sendScene(scene: [String: Any]){
        let uiscreenWindow = (UIApplication.shared.windows[0].rootViewController?.view)!
        
        _ = self.sceneVM
            .sendScene(body: scene, httpMethode: self.isUpdating ? .Patch : .Post)
            .subscribe(onNext: { succeeded in
                self.progressUtils.dismiss()
                let successAlertTitle = self.labelLocalization.newSceneSuccessCreationAlertTitle
                self.progressUtils.displayCheckMark(title: successAlertTitle, view: uiscreenWindow)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.progressUtils.dismiss()
                    if(self.isUpdating){
                        self.dismiss(animated: true, completion: nil)
                        self.onDoneBlock!()
                    }else{
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }, onError: { err in
                self.progressUtils.dismiss()
                let alertTitle = self.notificationLocalize.saveSceneErrorNotificationTitle
                let alertMessage = self.notificationLocalize.saveSceneErrorNotificationSubtitle
                self.notificationUtils.showFloatingNotificationBanner(title: alertTitle,
                                                                      subtitle:alertMessage,
                                                                      position: .top, style: .danger)
            })
    }
    
    // MARK: Local functions
    private func generatesBackGroundColor(){
        ColorUtils.shared.generatesBackGroundColor(colorArray: &self.sceneColors, size: 6)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

protocol SendBackDataProtocol {
    func saveScene(scene: SceneDto)
    func updateScene(scene: SceneDto)
}

class SceneActionsName {
    var key: String = ""
    var value: Any?
    var type: String = ""
    
    
    init(key: String, val: Any, type: String) {
        self.key = key
        self.value = val
        self.type = type
    }
}

protocol CloseCustomViewProtocol {
    func popOffView()
}
