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
            self.sceneActions.remove(at: indexPath.row)
            if(self.sceneActions.count == 0){
                self.actionsTableView.isEditing = false
                //self.editActionListButton.setTitle(NSLocalizedString("new.scene.vc.edit", comment: ""), for: .normal)
                //self.editActionListButton.isHidden = true
            }
            self.actionsTableView.reloadData()
        }
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
                return (self.deviceDict[self.alertDevice!.deviceSelectedSection!]["possible_actions"] as? [SceneActionsName])!.count
            }
        }
        // Number of cells in scene vc actions table view
        let actionForDevice = (self.deviceDict[section]["selected_actions"] as? [SceneActionsName])
        
        return (actionForDevice?.count ?? 0 ) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(self.isPopUpVisible){
            let cell = tableView.dequeueReusableCell(withIdentifier: "POP_UP_CELL", for: indexPath)
            cell.textLabel?.textAlignment = .center
            if(self.popUpType == 0){
                cell.textLabel?.text = self.devices[indexPath.row].name
            }else{
                let devicePossibleActions = self.deviceDict[indexPath.section]["possible_actions"] as? [SceneActionsName]
                cell.textLabel?.text = devicePossibleActions![indexPath.row].key
            }
            return cell
        }else{
            let deviceSelectedActions = self.deviceDict[indexPath.section]["selected_actions"] as? [SceneActionsName]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ACTION_CELL", for: indexPath)
            if (deviceSelectedActions != nil && indexPath.row < deviceSelectedActions!.count) {
                cell.isUserInteractionEnabled = false
                cell.textLabel?.text = deviceSelectedActions![indexPath.row].key
            } else {
                cell.isUserInteractionEnabled = true
                cell.textLabel?.text = "Ajouter une action"
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        if(self.isPopUpVisible){
            if(self.popUpType == 0){
                self.appendDevices(device: self.devices[indexPath.row])
            }else{
                let actionSection = self.alertDevice!.deviceSelectedSection!
                let allActions = self.deviceDict[actionSection]["possible_actions"] as! [SceneActionsName]
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
            print("Selected action from scene actions at row: \(indexPath.section)")
            let allActions = self.deviceDict[indexPath.section]["possible_actions"] as! [SceneActionsName]
                if(allActions.count > 0){
                    self.isPopUpVisible = true
                    self.popUpType = 1
                    
                    self.alertDevice = DevicesAlert()
                    self.alertDevice?.deviceSelectedSection = indexPath.section
                    self.view.addSubview(self.alertDevice!.parentView)
                    self.setUpDevicesTableView(deviceAlert: self.alertDevice!)
                    self.alertDevice!.tableView.reloadData()
                }
        }
    }
    
}
