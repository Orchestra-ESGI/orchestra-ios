//
//  UserHousesBottomSheetTableViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 07/05/2021.
//

import UIKit

class UserHousesBottomSheetTableViewController: UITableViewController {

    let houses = ["Mon domicile", "Domicile secondaire", "Maison de vacances","Mon domicile", "Domicile secondaire", "Maison de vacances","Mon domicile", "Domicile secondaire", "Maison de vacances","Mon domicile", "Domicile secondaire", "Maison de vacances","Mon domicile", "Domicile secondaire", "Maison de vacances"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.register(BottomSheetHeader.self, forHeaderFooterViewReuseIdentifier: "BOTTOM_SHEET_HEADER")
        self.tableView.register(UINib(nibName: "AddHouseTableViewCell", bundle: nil), forCellReuseIdentifier: "BOTTOM_SHEET_ADD_HOUSE")
        self.tableView.register(UINib(nibName: "CurrentHouseTableViewCell", bundle: nil), forCellReuseIdentifier: "BOTTOM_SHEET_HOUSE_NAME")
        
        self.tableView.isScrollEnabled = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.houses.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row > self.houses.count - 1){
            let newHouseCell = tableView.dequeueReusableCell(withIdentifier: "BOTTOM_SHEET_ADD_HOUSE") as! AddHouseTableViewCell
            return  newHouseCell
        }else{
            let houseCell = tableView.dequeueReusableCell(withIdentifier: "BOTTOM_SHEET_HOUSE_NAME") as! CurrentHouseTableViewCell
            let currentHousePosition = indexPath.row
            if(currentHousePosition == 0){
                houseCell.houseicon.isHidden = false
            }else{
                houseCell.houseicon.isHidden = true
            }
            houseCell.name.text = self.houses[currentHousePosition]
            return  houseCell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }

    override func tableView(_ tableView: UITableView,
            viewForHeaderInSection section: Int) -> UIView? {
       let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BOTTOM_SHEET_HEADER") as! BottomSheetHeader
        header.title.text = "Vos domiciles"
        
       return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
