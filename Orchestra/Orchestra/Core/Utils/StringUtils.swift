//
//  StringUtils.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/03/2021.
//

import Foundation
class StringUtils {
    
    static var shared = StringUtils()

    func generateFakeId(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
          return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
