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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(self.isPopUpVisible){
            let cell = tableView.dequeueReusableCell(withIdentifier: "POP_UP_CELL", for: indexPath)
            cell.textLabel?.textAlignment = .center
            if(self.popUpType == 0){
                cell.textLabel?.text = self.devices[indexPath.row].name
            }else{
                let devicePossibleActions = self.filteredActionsName //self.deviceDict[indexPath.section]["possible_actions"] as? [SceneActionsName]
                cell.textLabel?.text = devicePossibleActions[indexPath.row].key
            }
            return cell
        }else{
            let deviceSelectedActions = self.deviceDict[indexPath.section]["selected_actions"] as? [SceneActionsName]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ACTION_CELL", for: indexPath)
            if (deviceSelectedActions != nil && indexPath.row < deviceSelectedActions!.count) {
                cell.textLabel?.text = deviceSelectedActions![indexPath.row].key
                cell.textLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
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
                    
                    self.alertDevice = DevicesAlert()
                    self.alertDevice?.delegate = self
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
