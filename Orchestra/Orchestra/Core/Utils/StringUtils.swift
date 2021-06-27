//
//  StringUtils.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/03/2021.
//

import Foundation
import UIKit
import FontAwesome_swift

class StringUtils {
    
    static var shared = StringUtils()

    func generateFakeId(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
          return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func setFontAwesomeIcon(text: String, icon: FontAwesome, style: FontAwesomeStyle, spaceNumber: Int, font: UIFont) -> NSMutableAttributedString {
        var spaces = ""
        for _ in 0..<spaceNumber {
            spaces += " "
        }
        let concatenedString = "\(text)\(spaces)<font>\(String.fontAwesomeIcon(name: icon))<font>"
        let listItems = concatenedString.components(separatedBy: "<font>")
        let policyString = NSMutableAttributedString()
        var tempString = NSMutableAttributedString()
        for (i, str) in listItems.enumerated() {
            tempString = NSMutableAttributedString(string: str)
            let range = NSMakeRange(0, tempString.length)
            if (i == 1) {
                tempString.addAttribute(.font, value: UIFont.fontAwesome(ofSize: font.pointSize, style: style), range: range)
            } else {
                tempString.addAttribute(.font, value: font, range: range)
            }
            
            policyString.append(tempString)
        }
        return policyString
    }
    
    func colorText(text: String, color: UIColor, alpha: CGFloat = 1) -> NSMutableAttributedString {
        let policyString = NSMutableAttributedString(string: text)
        policyString.addAttribute(.foregroundColor, value: color.withAlphaComponent(alpha), range: NSMakeRange(0, policyString.length))
        
        return policyString
    }
    
    func colorTextWithOptions(text: String, color: UIColor, linkColor: UIColor, shouldBold: Bool = false, shouldUnderline: Bool = false, fontSize: CGFloat) -> NSMutableAttributedString {
        
        let listItems = text.components(separatedBy: "<a>")
        let policyString = NSMutableAttributedString()
        var tempString = NSMutableAttributedString()
        for (i, str) in listItems.enumerated() {
            tempString = NSMutableAttributedString(string: str)
            let range = NSMakeRange(0, tempString.length)
            tempString.addAttribute(.foregroundColor, value: (i==0) ? color : linkColor, range: range)
            if (i == 1) {
                if shouldUnderline {
                    tempString.addAttribute(.underlineStyle, value: 1, range: range)
                }
                
                if shouldBold {
                    tempString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: fontSize), range: range)
                }
            }
            
            policyString.append(tempString)
        }
        return policyString;
    }
}
