//
//  UITextFieldsExtensions.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 17/04/2021.
//

import Foundation
import UIKit

extension UITextField{
    
    func setUpLeftIcon(iconName: String){
        let leftViewContainer = UIView()
        let leftViewImageView = UIImageView(frame: CGRect(x: 15, y: 0, width: 30, height: 30))
        
        leftViewImageView.image = UIImage(systemName: iconName)
        leftViewImageView.contentMode = .center
        leftViewContainer.contentMode = .center
        leftViewContainer.addSubview(leftViewImageView)
        leftViewImageView.tintColor = .lightGray
        leftViewContainer.widthAnchor.constraint(equalToConstant: 40).isActive = true
        leftViewContainer.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.leftView = leftViewContainer
        self.leftViewMode = .always
    }
}
