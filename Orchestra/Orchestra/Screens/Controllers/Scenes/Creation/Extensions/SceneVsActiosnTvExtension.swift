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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sceneActions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ACTION_CELL", for: indexPath)
        cell.textLabel?.text = self.sceneActions[indexPath.row].actionTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
}
