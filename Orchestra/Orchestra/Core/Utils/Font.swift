//
//  Font.swift
//  Orchestra
//
//  Created by Nassim Morouche on 19/06/2021.
//

import Foundation
import UIKit

public class Font : UIFont {
    
    class func Regular(_ fontSize: CGFloat) -> UIFont {
        return UIFont.init(name: "Gilroy-Light", size: fontSize)!
    }
    
    class func Bold(_ fontSize: CGFloat) -> UIFont {
        return UIFont.init(name: "Gilroy-ExtraBold", size: fontSize)!
    }
}
