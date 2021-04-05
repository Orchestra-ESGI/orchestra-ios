//
//  ObjectCollectionViewCell.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 05/04/2021.
//

import UIKit

class ObjectCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var objectImageView: UIImageView!
    @IBOutlet weak var objectPlaceNameLabel: UILabel!
    @IBOutlet weak var objectNameLabel: UILabel!
    @IBOutlet weak var objectStatusLabel: UILabel!
    @IBOutlet weak var cellContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
