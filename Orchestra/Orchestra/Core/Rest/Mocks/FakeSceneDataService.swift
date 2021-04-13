//
//  FakeSceneDataService.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 10/04/2021.
//

import Foundation
import ObjectMapper
import RxSwift
import RxCocoa

class FakeSceneDataService{
    static var shared = FakeSceneDataService()
    var sceneStream = PublishSubject<[SceneDto]>()
    
    
    func getAllScenes(for userId: String){
        if let path = Bundle.main.path(forResource: "Scenes", ofType: "json") {
            do {
              let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
              let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let scenes = jsonResult["scenes"] as? [Any] {
                    var mappedScenes: [SceneDto] = []
                    for scene in scenes {
                        mappedScenes.append(Mapper<SceneDto>().map(JSON: (scene as? [String: Any])!)!)
                    }
                    sceneStream.onNext(mappedScenes)
                }
          } catch {
            sceneStream.onError(error)
          }
        }
    }
    
    func getObjectData(for objectId: String){
        
    }
    
    func addObject(){
        
    }
    
}
