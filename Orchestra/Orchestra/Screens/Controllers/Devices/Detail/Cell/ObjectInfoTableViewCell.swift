//
//  ObjectInfoTableViewCell.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 10/04/2021.
//

import UIKit

class ObjectInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var objectInfoName: UILabel!
    @IBOutlet weak var objectInfoValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
