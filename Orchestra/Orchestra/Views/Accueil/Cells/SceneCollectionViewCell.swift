//
//  SceneCollectionViewCell.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 05/04/2021.
//

import UIKit

class SceneCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var sceneImageView: UIImageView!
    @IBOutlet weak var sceneDescription: UILabel!
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var sceneDetailButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
