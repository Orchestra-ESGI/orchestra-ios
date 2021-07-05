//
//  SceneVsActiosnTvExtension.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 14/04/2021.
//

import Foundation
import UIKit

extension SceneViewController: UITableViewDelegate, UITableViewDataSource{
    // Editing list
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if(editingStyle == UITableViewCell.EditingStyle.delete){
            let section = indexPath.section
            var selectedActions = (self.deviceDict[section]["selected_actions"] as! [SceneActionsName])
            selectedActions.remove(at: indexPath.row)
            var newSeneActions: [String: Any] = [:]
            let oldSceneActions: [String: Any] = self.deviceDict[section]["actions"] as! [String: Any]
            for selectedAction in selectedActions{
                newSeneActions[selectedAction.type] = oldSceneActions[selectedAction.type]
            }
            print(newSeneActions)
            self.deviceDict[section]["selected_actions"] = selectedActions
            self.deviceDict[section]["actions"] = newSeneActions
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.actionsTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let selectedActions = self.deviceDict[indexPath.section]["selected_actions"] as? [SceneActionsName]
        if(indexPath.row == (selectedActions ?? []).count){
            return .none
        }
        return .delete
    }
    
    // Recycle items
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(!self.isPopUpVisible){
            // header name in scene tv
            return self.deviceDict[section]["name"] as? String
        }
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(self.isPopUpVisible){
            // number of sections in pop-up's
            return 1
        }
        
        // number of section in scene vc tv
        return self.deviceDict.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.isPopUpVisible){
            if(popUpType == 0){
                // Number of cells in Device table view pop up
                return self.devices.count
            }else {
                // Number of cells in Action table view pop up
                return self.filteredActionsName.count
            }
        }
        // Number of cells in scene vc actions table view
        let actionForDevice = (self.deviceDict[section]["selected_actions"] as? [SceneActionsName])
        
        return (actionForDevice?.count ?? 0 ) + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.isPopUpVisible && self.popUpType == 0 {
            return 60.0
        }
        
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(self.isPopUpVisible){
            if(self.popUpType == 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: "POP_UP_CELL_DEVICE", for: indexPath) as! DeviceAlertTableViewCell
                if cell.deviceName != nil {
                    cell.deviceName.removeFromSuperview()
                }
                
                if cell.roomLabel != nil {
                    cell.roomLabel.removeFromSuperview()
                }
                
                
                cell.backgroundColor = .clear
                cell.deviceName = UILabel()
                cell.deviceName.translatesAutoresizingMaskIntoConstraints = false
                cell.deviceName.font = Font.Regular(14)
                cell.deviceName.textAlignment = .center
                cell.deviceName.textColor = .white
                
                cell.roomLabel = UILabel()
                cell.roomLabel.translatesAutoresizingMaskIntoConstraints = false
                cell.roomLabel.font = Font.Regular(12)
                cell.roomLabel.textAlignment = .center
                cell.roomLabel.textColor = .white
                
                cell.addSubview(cell.deviceName)
                cell.addSubview(cell.roomLabel)
                
                cell.deviceName.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 45.0).isActive = true
                cell.deviceName.topAnchor.constraint(equalTo: cell.topAnchor, constant: 10).isActive = true
                cell.deviceName.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -45.0).isActive = true
                cell.deviceName.bottomAnchor.constraint(equalTo: cell.roomLabel.topAnchor).isActive = true
                
                cell.roomLabel.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
                cell.roomLabel.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
                cell.roomLabel.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -10).isActive = true
                
                cell.deviceName.text = self.devices[indexPath.row].name
                cell.roomLabel.text = self.devices[indexPath.row].room?.name
                switch self.devices[indexPath.row].type {
                case.Switch:
                    cell.imageView?.image = UIImage(systemName: "switch.2")
                    break
                case .LightBulb:
                    cell.imageView?.image = UIImage(systemName: "lightbulb.fill")
                    break
                case .StatelessProgrammableSwitch:
                    cell.imageView?.image = UIImage(systemName: "switch.2")
                    break
                case .Occupancy:
                    cell.imageView?.image = UIImage(systemName: "figure.walk")
                    break
                case .TemperatureAndHumidity:
                    cell.imageView?.image = UIImage(systemName: "thermometer")
                case .Contact:
                    cell.imageView?.image = UIImage.fontAwesomeIcon(name: .doorOpen, style: .solid, textColor: .white, size: CGSize(width: 15, height: 15))
                    break
                default:
                    cell.imageView?.image = UIImage(systemName: "questionmark")
                }
                
                cell.imageView?.tintColor = .white
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "POP_UP_CELL", for: indexPath)
                cell.backgroundColor = .clear
                cell.textLabel?.font = Font.Regular(17)
                cell.textLabel?.textColor = .white
                cell.textLabel?.textAlignment = .center
                let devicePossibleActions = self.filteredActionsName //self.deviceDict[indexPath.section]["possible_actions"] as? [SceneActionsName]
                cell.textLabel?.text = devicePossibleActions[indexPath.row].key
                return cell
            }
        }else{
            let deviceSelectedActions = self.deviceDict[indexPath.section]["selected_actions"] as? [SceneActionsName]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ACTION_CELL", for: indexPath)
            cell.backgroundColor = .clear
            cell.textLabel?.font = Font.Regular(17)
            cell.textLabel?.textColor = .white
            if (deviceSelectedActions != nil && indexPath.row < deviceSelectedActions!.count) {
                cell.textLabel?.text = deviceSelectedActions![indexPath.row].key
            } else {
                cell.textLabel?.text = self.labelLocalization.addActionOnDeviceNewSceneButtonTitle
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        // If the last cell of the section is selected
        if(self.isPopUpVisible){
            if(self.popUpType == 0){
                self.appendDevices(device: self.devices[indexPath.row])
            }else{
                let actionSection = self.alertDevice!.deviceSelectedSection!
                let allActions = self.filteredActionsName
                //self.deviceDict[actionSection]["possible_actions"] as! [SceneActionsName]
                if(allActions.count > 0){
                    let selectedAction = allActions[indexPath.row]
                    var currentSelectedActions = self.deviceDict[actionSection]["selected_actions"] as? [SceneActionsName]
                    
                    
                    var actionJson = self.deviceDict[actionSection]["actions"] as? [String: Any]
                    
                    if(actionJson == nil){
                        actionJson = [:]
                    }
                    if(selectedAction.type == "color"){
                        actionJson![selectedAction.type] = ["hex": selectedAction.value]
                    }else{
                        actionJson![selectedAction.type] = selectedAction.value
                    }
                    self.deviceDict[actionSection]["actions"] = actionJson
                    
                    
                    if( currentSelectedActions == nil){
                        let selectedActions = [selectedAction]
                        self.deviceDict[actionSection]["selected_actions"] = selectedActions
                    }else{
                        currentSelectedActions!.append(selectedAction)
                        self.deviceDict[actionSection]["selected_actions"] = currentSelectedActions
                    }
                    
                    print("Action: \(self.deviceDict[actionSection]["actions"])")
                }
            }
            self.hidePopUp()
            self.isPopUpVisible = false
            self.actionsTableView.reloadData()
        }else{
            if(indexPath.row == (self.deviceDict[indexPath.section]["selected_actions"] as? [SceneActionsName] ?? []).count){
                print("Selected action from scene actions at row: \(indexPath.section)")
                let allActions = self.deviceDict[indexPath.section]["possible_actions"] as! [SceneActionsName]
                if(allActions.count > 0){
                    self.isPopUpVisible = true
                    self.popUpType = 1
                    
                    if let selectedActions = self.deviceDict[indexPath.section]["selected_actions"] as? [SceneActionsName] {
                        let deviceActionInScene = (selectedActions).map { dict -> String in
                            return dict.type
                        }
                        self.filteredActionsName = allActions.filter { !deviceActionInScene.contains($0.type)}
                    }else{
                        self.filteredActionsName = allActions
                    }
                    
                    self.alertDevice = CustomSceneActionTbvAlert()
                    self.alertDevice?.delegate = self
                    self.alertDevice?.tableView.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.2745098039, blue: 0.3019607843, alpha: 1)
                    self.alertDevice?.alertView.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.2745098039, blue: 0.3019607843, alpha: 1)
                    self.alertDevice?.deviceSelectedSection = indexPath.section
                    self.alertDevice?.titleLabel.text = self.labelLocalization.newSceneActionCustomViewTitle
                    self.view.addSubview(self.alertDevice!.parentView)
                    self.setUpDevicesTableView(deviceAlert: self.alertDevice!)
                    self.alertDevice!.tableView.reloadData()
                }
            }
        }
    }
    
}
