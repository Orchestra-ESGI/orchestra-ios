//
//  SceneDetailViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 17/04/2021.
//

import UIKit
import RxCocoa
import RxSwift
import Floaty

class SceneDetailViewController: UIViewController {

    // MARK: UI
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var actionsLabel: UILabel!
    @IBOutlet weak var actionsTableView: UITableView!
    
    var editSceneButton: UIBarButtonItem?
    
    // MARK: Utils
    let colorUtils = ColorUtils.shared
    let progressUtils = ProgressUtils.shared
    let labelLocalization = ScreensLabelLocalizableUtils.shared
    
    // MARK: Local data
    var sceneData: SceneDto?
    var automationData: AutomationDto?
    var isAutomation = false
    let sceneVM = SceneViewModel()
    var sceneDevices: [HubAccessoryConfigurationDto] = []
    var sceneActionsName: [String: [String]] = [:]
    var devices: [[String: String]] = []
    
    var onDoneBlock : (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneVM.fillsceneActions(devices: sceneDevices)
        self.localizeUI()
        self.setUpUI()
        self.setUpClickObserver()
        self.setUpTableView()
        if(!self.isAutomation){
            self.getActionsNameFromScene()
        }else{
            self.getActionsFromAutomation()
        }
    }
    
    // MARK: UI setup
    private func setUpUI(){
        self.setUpTopBar()
        self.setUpLabels()
        
        self.descriptionTextView.layer.borderWidth = 0.5
        self.descriptionTextView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.descriptionTextView.layer.cornerRadius = 8.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func localizeUI(){
        self.descriptionLabel.text = self.labelLocalization.sceneInfoDesciptionLabel
        self.actionsLabel.text = self.labelLocalization.sceneInfoActionListTitleLabel
    }
    
    private func setUpTopBar(){
        var titleColor = UIColor()
        if(!self.isAutomation){
            titleColor = self.colorUtils.hexStringToUIColor(hex: self.sceneData?.color ?? "")
            self.title = self.sceneData?.name
        }else{
            titleColor = self.colorUtils.hexStringToUIColor(hex: self.automationData?.color ?? "")
            self.title = self.automationData?.name
        }
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : titleColor]

        self.navigationController?.navigationBar.barTintColor = titleColor
        
        //editSceneButton = UIBarButtonItem(title: "Éditer", style: .done, target: self, action: nil)
        if #available(iOS 14.0, *) {
            editSceneButton = UIBarButtonItem(systemItem: .edit)
        } else {
            // Fallback on earlier versions
            editSceneButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: nil)
        }
        editSceneButton?.tintColor = #colorLiteral(red: 2.387956192e-05, green: 0.5332912803, blue: 0.8063663244, alpha: 1)
        self.navigationItem.rightBarButtonItems = [editSceneButton!]
    }
    
    // MARK: Setup Observers
    
    private func setUpClickObserver(){
        // Here set up click handling on UIButton
        _ = self.editSceneButton?
                .rx
                .tap.bind{
                    let updateVc = SceneViewController()
                    updateVc.onDoneBlock = self.onDoneBlock
                    if(!self.isAutomation){
                        updateVc.sceneToEdit = self.sceneData
                    }else{
                        updateVc.automationToEdit = self.automationData
                        updateVc.isAutomation = true
                    }
                    updateVc.devices = self.sceneDevices
                    updateVc.isUpdating = true
                    self.navigationController?.pushViewController(updateVc, animated: true)
            }
    }
    
    private func setUpLabels(){
        if(!self.isAutomation){
            self.descriptionTextView.text = self.sceneData?.sceneDescription
        }else{
            self.descriptionTextView.text = self.automationData?.automationDescription
        }
    }
    
    private func setUpTableView(){
        self.actionsTableView.delegate = self
        self.actionsTableView.dataSource = self
        self.actionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ACTION_CELL")
        self.actionsTableView.tableFooterView = UIView()
    }
    
    private func getActionsNameFromScene(){
        guard let sceneActions = self.sceneData?.devices else{
            return
        }
        
        for device in sceneActions {
            let deviceFriendlyName = device.friendlyName
            let deviceName = self.devices.map { device -> String in
                if(Array(device.keys)[0] == deviceFriendlyName){
                    return device[deviceFriendlyName]!
                }
                return ""
            }.filter{ $0 != ""}[0]
            
            var actions: [String] = []
            for action in device.actions{
                let actionType = action.key
                var actionValue = ""
                if action.value is [String: Any]{
                    actionValue = "color"
                }else{
                    switch actionType {
                    case "state":
                        actionValue = action.value as! String
                    default:
                        actionValue = (action.value as! Int).description
                    }
                }
                
                
                if let action = self.sceneVM.getSceneActionName(key: actionType, value: actionValue){
                    actions.append(action)
                }
            }

            self.sceneActionsName[deviceName] = actions
        }
    }
    
    private func getActionsFromAutomation(){
        guard let automationDevices = self.automationData?.targets else{
            return
        }
        
        for device in automationDevices {
            let deviceFriendlyName = device.friendlyName
            let deviceName = self.devices.map { device -> String in
                if(Array(device.keys)[0] == deviceFriendlyName){
                    return device[deviceFriendlyName]!
                }
                return ""
            }.filter{ $0 != ""}[0]
            
            var actions: [String] = []
            for action in device.actions{
                let actionType = action.key
                var actionValue = ""
                if action.value is [String: Any]{
                    actionValue = "color"
                }else{
                    switch actionType {
                    case "state":
                        actionValue = action.value as! String
                    default:
                        actionValue = (action.value as! Int).description
                    }
                }
                
                
                if let action = self.sceneVM.getSceneActionName(key: actionType, value: actionValue){
                    actions.append(action)
                }
            }

            self.sceneActionsName[deviceName] = actions
        }
    }
    
    func getNumberOfRowsInSection(header: String) -> Int{
        
        return self.sceneActionsName[header]!.count
    }
    
}

extension SceneDetailViewController: UITableViewDataSource{
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return Array(self.sceneActionsName.keys)[section]
     }
     
     func numberOfSections(in tableView: UITableView) -> Int {
         return self.sceneActionsName.count
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getNumberOfRowsInSection(header: Array(self.sceneActionsName.keys)[section])
     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ACTION_CELL")!
        let sectionHeader = Array(self.sceneActionsName.keys)[indexPath.section]
        let actions = self.sceneActionsName[sectionHeader]!
        cell.textLabel?.text = actions[indexPath.row]
        return cell
    }
    
    
}

extension SceneDetailViewController: UITableViewDelegate{
    
}
