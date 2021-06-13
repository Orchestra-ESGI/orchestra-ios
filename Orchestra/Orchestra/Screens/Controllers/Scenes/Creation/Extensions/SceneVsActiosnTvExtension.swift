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
                return self.actionsName.count
            }
        }
        // Number of cells in scene vc actions table view
        return ((self.deviceDict[section]["actions"] as? [String])?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(self.isPopUpVisible){
            let cell = tableView.dequeueReusableCell(withIdentifier: "POP_UP_CELL", for: indexPath)
            cell.textLabel?.textAlignment = .center
            if(self.popUpType == 0){
                cell.textLabel?.text = self.devices[indexPath.row].name
            }else{
                cell.textLabel?.text = self.actionsName[indexPath.row]
            }
            return cell
        }else{
            let actionsOfDevice = (self.deviceDict[indexPath.section]["actions"] as? [String])!
            let cell = tableView.dequeueReusableCell(withIdentifier: "ACTION_CELL", for: indexPath)
            if(indexPath.row > actionsOfDevice.count - 1){
                cell.tag = -1
                cell.textLabel?.text = "Ajouter une action"
            }else{
                cell.textLabel?.text = actionsOfDevice[indexPath.row]
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
                if(self.actionsName.count > 0){
                    var actionsOfDevice = self.deviceDict[(self.alertDevice?.deviceSelectedSection)!]["actions"] as? [String]
                    actionsOfDevice?.append(self.actionsName[indexPath.row])
                    self.deviceDict[(self.alertDevice?.deviceSelectedSection)!]["actions"] = actionsOfDevice
                    print("Action: \(self.actionsName[indexPath.row])")
                }
            }
            self.hidePopUp()
            self.isPopUpVisible = false
            self.actionsTableView.reloadData()
        }else{
            print("Selected action from scene actions at row: \(indexPath.section)")
            if(tableView.cellForRow(at: indexPath)?.tag == -1){
                // add action
                let deviceSelected = self.devices.filter { device in
                    return device.name == self.deviceDict[indexPath.section]["name"] as? String
                }
                self.parseDeviceActionToGetName(device: deviceSelected[0])
                if(self.actionsName.count > 0){
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
    
}
