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
    
    
    func getAllScenes(for userId: String) -> Observable<Bool>{
        return Observable<Bool>.create { observer in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if let path = Bundle.main.path(forResource: "Scenes", ofType: "json") {
                    do {
                      let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                      let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                        if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let scenes = jsonResult["scenes"] as? [Any] {
                            var mappedScenes: [SceneDto] = []
                            for scene in scenes {
                                mappedScenes.append(Mapper<SceneDto>().map(JSON: (scene as? [String: Any])!)!)
                            }
                            self.sceneStream.onNext(mappedScenes)
                        }
                  } catch {
                    self.sceneStream.onError(error)
                    observer.onNext(false)
                  }
                    observer.onNext(true)
                }
            }
            return Disposables.create()
        }
    }
    
    func createNewScene(name: String, description: String, color: String, actions: [ActionSceneDto]) -> Observable<SceneDto>{
        
        return Observable<SceneDto>.create { (observer) -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                var sceneActions: [[String: Any]] = []
                for action in actions{
                    let item = ["title": action.title]
                    sceneActions.append(item)
                }
                
                let jsonObject: [String: Any] = [
                    "_id": self.generateRanId(),
                    "title": name,
                    "sceneDescription": description,
                    "backgroundColor": color,
                    "manufacturer": "Xiaomi",
                    "idUser": self.generateRanId(),
                    "actions": sceneActions
                ]

                let createdScene = SceneDto(JSON: jsonObject)!
                observer.onNext(createdScene)
            }
            return Disposables.create()
        }
    }
    
    func getObjectData(for objectId: String){
        
    }
    
    func removeScene() -> Observable<SceneDto>{
        return Observable<SceneDto>.create { (oberver) -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                oberver.onNext(SceneDto(JSON: ["": ""])!)
            }
            
            return Disposables.create()
        }
    }
    
    
    func generateRanId() -> String{
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<24).map{ _ in letters.randomElement()! })
    }
}
