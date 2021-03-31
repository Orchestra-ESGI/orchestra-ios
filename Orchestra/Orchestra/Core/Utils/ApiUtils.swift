//
//  ApiUtils.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/03/2021.
//

import Foundation
import Alamofire

class ApiUtils {
    
    static var shared = ApiUtils()
    
    struct Preferences: Codable {
        var API_URL: String?
        var API_SECRET: String?
        var CFBundleShortVersionString: String?
    }
    
    func getPrefs() -> Preferences {
        if  let path        = Bundle.main.path(forResource: "Info", ofType: "plist"),
            let xml         = FileManager.default.contents(atPath: path),
            let preferences = try? PropertyListDecoder().decode(Preferences.self, from: xml)
        {
            return preferences
        } else {
            return Preferences()
        }
    }
    
    func getVersion() -> String {
        return getPrefs().CFBundleShortVersionString ?? ""
    }
    
    func getDomain() -> String {
        return getPrefs().API_URL ?? ""
    }
    
    func getClientSecret() -> String {
        return getPrefs().API_SECRET ?? ""
    }
}
