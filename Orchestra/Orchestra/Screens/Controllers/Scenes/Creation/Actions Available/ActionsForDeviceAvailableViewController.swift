//
//  ActionsForDeviceAvailableViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 12/06/2021.
//

import UIKit

class ActionsForDeviceAvailableViewController: UIViewController {

    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var actionsTableView: UITableView!
    
    var actions: Actions?
    var deviceName: String = ""
    var actionsName: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hintLabel.text = self.hintLabel.text! + " \(deviceName)"
        self.setUpTableView()
        self.parseDeviceActionToGetName()
        
    }

    private func setUpTableView(){
        self.actionsTableView.dataSource = self
        self.actionsTableView.delegate = self
        
        // CELLS
        self.actionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ACTION_AVAILABLE")
    }
    
    private func parseDeviceActionToGetName(){
        if self.actions?.state != nil {
            self.actionsName.append("Allumer l'appareil")
            self.actionsName.append("Éteindre l'appareil")
            self.actionsName.append("Basculer")
        }
        
        if(self.actions?.brightness != nil){
            self.actionsName.append("Régler la luminosité à 25%")
            self.actionsName.append("Régler la luminosité à 50%")
            self.actionsName.append("Régler la luminosité à 100%")
        }
        
        if(self.actions?.color != nil){
            self.actionsName.append("Choisir une couleur")
        }
        
        if(self.actions?.colorTemp != nil){
            self.actionsName.append("Choisir la température")
        }
        self.actionsTableView.reloadData()
    }
}


extension ActionsForDeviceAvailableViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.actionsName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ACTION_AVAILABLE")!
        cell.textLabel?.text = self.actionsName[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension ActionsForDeviceAvailableViewController: UITableViewDelegate{
    
}
