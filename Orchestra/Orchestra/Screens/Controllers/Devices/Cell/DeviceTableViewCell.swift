//
//  DeviceTableViewCell.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/05/2021.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var accessoryImageView: UIImageView!    
    @IBOutlet weak var accessoryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
