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
    let localizeUtils = ScreensLabelLocalizableUtils.shared
    let notificationUtils = NotificationsUtils.shared
    let progressUtils = ProgressUtils.shared
    let notificationLocalize = NotificationLocalizableUtils.shared
    
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
    var alertDevice: DevicesAlert?
    
    // All available devices
    var devices : [HubAccessoryConfigurationDto] = []
    //
    var deviceDict: [[String:Any]] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.deviceVM = DeviceViewModel(navigationCtrl: self.navigationController!)
        
        self.localizeLabels()
        self.setUpUI()
        self.setUpTextFields()
        self.setColorsCollectionView()
        self.setActionsTableView()
        self.generatesBackGroundColor()
        self.clickObservers()
    }
    
    
    // MARK: Controller Setup
    private func localizeLabels(){
        self.sceneNameLabel.text = self.localizeUtils.sceneFormNameLabel
        self.sceneBackgroundColorLabel.text = self.localizeUtils.sceneFormBackgroundColorLabel
        self.sceneDescriptionLabel.text = self.localizeUtils.sceneFormDescriptionLabel
        self.addActionButton.setTitle(self.localizeUtils.addActionButtonnText, for: .normal)
        self.sceneDescriptionTf.placeholder = self.localizeUtils.sceneFormDescriptionTf
        self.sceneNameTf.placeholder = self.localizeUtils.sceneFormNameTf
        
    }
    
    private func setUpTextFields(){
        self.sceneNameTf.delegate = self
        self.sceneDescriptionTf.delegate = self
    }
    
    private func setUpUI(){
        let newSceneTitle = self.localizeUtils.newSceneVcTitle
        let updateSceneTitle = self.localizeUtils.updateSceneVcTitle
        self.title = self.isUpdating ? updateSceneTitle : newSceneTitle
        
        addSceneAppbarButon = UIBarButtonItem(image: UIImage(systemName: "paperplane.fill"), style: .done, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = addSceneAppbarButon
        
        self.viewContainer.frame.size.height = self.view.frame.height + 40
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
                self.alertDevice?.titleLabel.text = self.localizeUtils.newSceneDeviceCustomViewTitle
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
        //alert.removeFromSuperview()
    }
    
    func popOffView() {
        self.hidePopUp()
        self.isPopUpVisible = false
    }
    
    func parseDeviceActionToGetName(device: HubAccessoryConfigurationDto) {
        var actions: [String] = []
        var values: [Any] = []
        if device.actions?.state != nil {
            let onAction = self.localizeUtils.deviceActionStateOn
            let offAction = self.localizeUtils.deviceActionStateOff
            let toggleAction = self.localizeUtils.deviceActionStateToggle
            actions = [onAction, offAction, toggleAction]
            values = ["on", "off", "toggle"]
            for index in 0..<actions.count{
                let action = SceneActionsName(key: actions[index], val: values[index], type: "state")
                self.actionsName.append(action)
            }
        }
        
        if(device.actions?.brightness != nil){
            let brightnessAction100 = self.localizeUtils.deviceActionBrightness100
            let brightnessAction50 = self.localizeUtils.deviceActionBrightness50
            let brightnessAction25 = self.localizeUtils.deviceActionBrightness25
            let deviceBrightness = device.actions!.brightness!.maxVal
            actions = [brightnessAction25, brightnessAction50, brightnessAction100]
            values = [deviceBrightness/4, deviceBrightness/2, deviceBrightness]
            for index in 0..<actions.count{
                let action = SceneActionsName(key: actions[index], val: values[index], type: "brightness")
                self.actionsName.append(action)
            }
        }
        
        if(device.actions?.color != nil){
            let colorAction = self.localizeUtils.deviceActionColor
            actions = [colorAction]
            values = ["#FF0000"]
            for index in 0..<actions.count{
                let action = SceneActionsName(key: actions[index], val: values[index], type: "color")
                self.actionsName.append(action)
            }
        }
        
        if(device.actions?.colorTemp != nil){
            let temperatureAction100 = self.localizeUtils.deviceActionTemp100
            let temperatureAction50 = self.localizeUtils.deviceActionTemp50
            let temperaturection25 = self.localizeUtils.deviceActionTemp25
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
                self.progressUtils.displayV2(view: self.view, title: self.notificationLocalize.undeterminedProgressViewTitle, modeView: .MRActivityIndicatorView)
                
                var newSceneMap: [String: Any] = [:]
                newSceneMap["name"] = self.sceneNameTf.text!
                newSceneMap["color"] = self.sceneColors[self.selectedColor].toHexString()
                newSceneMap["description"] = self.sceneDescriptionTf.text!
                newSceneMap["devices"] = self.deviceDict.map({ device -> [String: Any] in
                    
                    let friendlyName = device["friendly_name"]!
                    let actions = device["actions"]!
                    return [
                        "friendly_name": friendlyName,
                        "actions": actions
                    ]
                })
                let uiscreenWindow = (UIApplication.shared.windows[0].rootViewController?.view)!

                _ = self.sceneVM.newScene(body: newSceneMap).subscribe(onNext: { succeeded in
                    self.progressUtils.dismiss()
                    let successAlertTitle = self.localizeUtils.newSceneSuccessCreationAlertTitle
                    self.progressUtils.displayCheckMark(title: successAlertTitle, view: uiscreenWindow)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.progressUtils.dismiss()
                        self.navigationController?.popViewController(animated: true)
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
    }
    
    
    // MARK: Local functions
    private func generatesBackGroundColor(){
        var colorsSize = 5
        if(self.sceneToEdit != nil){
            //self.sceneColors.append((sceneToEdit?.backgroundColor)!)
        }else{
            colorsSize = 6
        }
        ColorUtils.shared.generatesBackGroundColor(colorArray: &self.sceneColors, size: colorsSize)
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
