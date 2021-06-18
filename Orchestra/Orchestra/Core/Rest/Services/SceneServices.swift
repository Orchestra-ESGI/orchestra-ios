//
//  SceneServices.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 31/03/2021.
//

import Foundation
import Alamofire
import ObjectMapper
import RxSwift
import RxCocoa

class SceneServices: RootApiService{
    var sceneStream = PublishSubject<[SceneDto]>()
    
    func getAllScenes() -> Observable<Bool>{
        
        return Observable<Bool>.create({observer in
            AF.request("\(RootApiService.BASE_API_URL)/scene/all", method: .get, parameters: nil, headers: self.headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                        case .success( _):
                            guard let response =  response.value as? [String: Any],
                                  let responseData = response["scenes"] as? [[String: Any]]  else {
                                self.sceneStream.onNext([])
                                observer.onNext(false)
                                return
                            }
                            var allMappedScenes: [SceneDto] = []
                            for sceneJson in responseData {
                                allMappedScenes.append(Mapper<SceneDto>().map(JSONObject: sceneJson)!)
                            }
                            
                            self.sceneStream.onNext(allMappedScenes)
                            observer.onNext(true)
                        case .failure(_):
                            guard let errorJson =  response.value  else {
                                return
                            }
                            let errorDto = Mapper<ErrorDto>().map(JSONObject: errorJson)
                            
                            print("Error - SceneServices - getAllScenes()")
                            
                            self.sceneStream.onError(errorDto!)
                            observer.onNext(false)
                    }
                }
            return Disposables.create()
        })
    }
    
    func removeScene(idScene: String) -> Observable<Bool>{
        var body: [String: Any] = [:]
        body["id_scene"] = idScene
        
        
        return Observable<Bool>.create({observer in
            AF.request("\(RootApiService.BASE_API_URL)/scene/remove", method: .delete, parameters: body, headers: self.headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                        case .success( _):
                            observer.onNext(true)
                        case .failure(_):
                            print("Error - SceneServices - removeScene()")
                            observer.onNext(false)
                    }
                }
            return Disposables.create();
        })
    }
    
    func createNewScene(scene: SceneDto) -> Observable<SceneDto>{
        var body: [String: Any] = [:]
        body["name"] = scene.name
        body["color"] = scene.color
        body["description"] = scene.sceneDescription
        
        
        return Observable<SceneDto>.create({observer in
            AF.request("\(RootApiService.BASE_API_URL)/scene", method: .post, parameters: body, encoding: JSONEncoding.default,  headers: self.headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                        case .success( _):
                            guard let jsonRes = response.value as? [String: Any],
                                  let sceneName = jsonRes["name"] as? String,
                                  let sceneDesc = jsonRes["description"] as? String,
                                  let sceneColor = jsonRes["color"] as? String,
                                  let sceneActions = jsonRes["actions"] as? [Actions] else{
                                return
                            }
                            var newSceneMap: [String: Any] = [:]
                            newSceneMap["name"] = sceneName
                            newSceneMap["description"] = sceneDesc
                            newSceneMap["color"] = sceneColor
                            newSceneMap["actions"] = sceneActions
                            
                            let newScene = Mapper<SceneDto>().map(JSONObject: newSceneMap)!
                            observer.onNext(newScene)
                        case .failure(_):
                            guard let errorJson =  response.error,
                                  let error = errorJson.underlyingError else {
                                return
                            }
                            
                            print("Error - SceneServices - createNewScene()")
                            observer.onError(error)
                    }
                }
            return Disposables.create();
        })
    }
    
    func launchScene(id: String){
        _ = AF.request("\(RootApiService.BASE_API_URL)/scene/\(id)", method: .post, parameters: nil, encoding: JSONEncoding.default,  headers: self.headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                    case .success( _):
                        print("Scene correctly launched")
                    case .failure(_):
                        guard let errorJson =  response.error,
                              let error = errorJson.underlyingError else {
                            return
                        }
                        
                        print("Error - SceneServices - launchScene()")
                }
            }
    }
}
