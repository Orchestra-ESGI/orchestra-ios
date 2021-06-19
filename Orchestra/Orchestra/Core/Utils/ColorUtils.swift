//
//  ColorUtils.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 17/04/2021.
//

import Foundation
import UIKit

class ColorUtils{
    static let shared = ColorUtils()
    
    static let ORCHESTRA_BLUE_COLOR: UIColor = shared.hexStringToUIColor(hex: "161E29")
    static let ORCHESTRA_RED_COLOR: UIColor = shared.hexStringToUIColor(hex: "D12B31")
    static let ORCHESTRA_WHITE_COLOR: UIColor = shared.hexStringToUIColor(hex: "E3EEFE")
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func generatesBackGroundColor(colorArray: inout [UIColor], size: Int){
        for _ in 0..<size{
            colorArray.append(UIColor(red: .random(in: 0.2...1),
                                green: .random(in: 0.2...1),
                                blue: .random(in: 0.2...1),
                                alpha: 1.0))
        }
    }
}
