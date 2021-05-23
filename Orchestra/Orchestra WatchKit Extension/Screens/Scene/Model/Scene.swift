//
//  Scene.swift
//  Orchestra WatchKit Extension
//
//  Created by Ramzy Kermad on 23/05/2021.
//

import Foundation
import UIKit

class Scene {
    var position: Int
    var sceneName: String
    var sceneColor: UIColor
    
    init(position: Int,name: String, color: UIColor ) {
        self.position = position
        self.sceneName = name
        self.sceneColor = color
    }
}
