//
//  UIViewExtension.swift
//  Orchestra
//
//  Created by Nassim Morouche on 27/06/2021.
//

import Foundation
import UIKit

extension UIView {
    public func addBottomSeparator(color: UIColor) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: 0.5)
        self.layer.addSublayer(border)
    }
}
