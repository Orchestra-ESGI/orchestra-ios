//
//  StringExtension.swift
//  Orchestra
//
//  Created by Nassim Morouche on 19/06/2021.
//

import Foundation

extension String {

    func isEmailValid() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }

    func isPasswordValid() -> Bool {
        if self.count < 4 || self.count > 20 || containsNonAlphaNumeric() {
            return false
        }
        return true
    }
    
    func containsNonAlphaNumeric() -> Bool {
        let characterset = CharacterSet.alphanumerics
        if self.rangeOfCharacter(from: characterset.inverted) != nil {
            return true
        }
        return false
    }
}
