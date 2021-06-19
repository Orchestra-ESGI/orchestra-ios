//
//  UITextFieldsExtensions.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 17/04/2021.
//

import Foundation
import UIKit

extension UITextField{
    
    func setUpBlankLeftView(){
        let leftViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        leftViewContainer.contentMode = .center
        leftViewContainer.widthAnchor.constraint(equalToConstant: 10).isActive = true
        leftViewContainer.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        self.leftView = leftViewContainer
        self.leftViewMode = .always
    }
    
    func setUpRightIcon(iconName: String){
        let rightViewContainer = UIView()
        let rightViewImageView = UIImageView(frame: CGRect(x: 15, y: 0, width: 30, height: 30))
        
        rightViewImageView.image = UIImage(systemName: iconName)
        rightViewImageView.contentMode = .center
        rightViewContainer.contentMode = .center
        rightViewContainer.addSubview(rightViewImageView)
        rightViewImageView.tintColor = .lightGray
        rightViewContainer.widthAnchor.constraint(equalToConstant: 40).isActive = true
        rightViewContainer.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.rightView = rightViewContainer
        self.rightViewMode = .always
    }
    
    func isError(numberOfShakes shakes: Float, revert: Bool) {
        let shake: CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.07
        shake.repeatCount = shakes
        if revert { shake.autoreverses = true  } else { shake.autoreverses = false }
        shake.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        shake.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(shake, forKey: "position")
    }
    
    func setBottomLayer(color: UIColor) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
        bottomLine.backgroundColor = color.cgColor
        self.layer.addSublayer(bottomLine)
    }
}
