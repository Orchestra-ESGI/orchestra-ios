//
//  FakeObjectsDataService.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 10/04/2021.
//

import Foundation
import ObjectMapper
import RxSwift
import RxCocoa

class FakeObjectsDataService{
    static var shared = FakeObjectsDataService()
    var objectStream = PublishSubject<[ObjectDto]>()
    
    
    func getAllObjects(for userId: String){
        if let path = Bundle.main.path(forResource: "Objects", ofType: "json") {
            do {
              let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
              let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let objects = jsonResult["objects"] as? [Any] {
                    var mappedObjects: [ObjectDto] = []
                    for object in objects {
                        mappedObjects.append(Mapper<ObjectDto>().map(JSON: (object as? [String: Any])!)!)
                    }
                    objectStream.onNext(mappedObjects)
                }
          } catch {
            objectStream.onError(error)
          }
        }
    }
    
    func getObjectData(for objectId: String){
        
    }
    
    func addObject(){
        
    }
    
}
