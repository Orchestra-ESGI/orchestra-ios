//
//  FileUtils.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/03/2021.
//

import Foundation
import ObjectMapper

class FileUtils {
    
    static var shared = FileUtils()
    
    func readFromAssets<T: Mappable>(asFileName name: String, type: T.Type) -> T {
        if let path = Bundle.main.path(forResource: name, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                    // do stuff
                    let value = Mapper<T>().map(JSONObject: jsonResult)
                    return value!
                }
            } catch {
                return {} as! T
            }
        }
        return {} as! T
    }
    
    func readArrayFromAssets<T: Mappable>(asFileName name: String, type: T.Type) -> [T] {
        if let path = Bundle.main.path(forResource: name, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [Dictionary<String, AnyObject>] {
                    // do stuff
                    let value = Mapper<T>().mapArray(JSONArray: jsonResult)
                    return value
                }
            } catch {
                return [] as! [T]
            }
        }
        return [] as! [T]
    }
    
    func readArrayJsonFromAssets(asFileName name: String) -> [[String : Any]] {
        if let path = Bundle.main.path(forResource: name, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [Dictionary<String, AnyObject>] {
                    // do stuff
                    return jsonResult
                }
            } catch {
                return []
            }
        }
        return []
    }
}
