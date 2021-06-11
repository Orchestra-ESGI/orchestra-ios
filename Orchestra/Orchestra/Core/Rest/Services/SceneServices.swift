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
    
    func getAllScenes(idHouse: String) -> Observable<[SceneDto]>? { // mu
        var body: [String: Any] = [:]
        body["id_house"] = idHouse
        
        return Observable<[SceneDto]>.create({observer in
            AF.request("\(RootApiService.BASE_API_URL)/scenes/get/all", method: .get, parameters: body, headers: self.headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                        case .success( _):
                            guard let responseData =  response.value as? [Any] else {
                                return observer.onCompleted()
                            }
                            var allMappedScenes: [SceneDto] = []
                            for sceneJson in responseData {
                                allMappedScenes.append(Mapper<SceneDto>().map(JSONObject: sceneJson)!)
                            }
                            observer.onNext(allMappedScenes)
                        case .failure(_):
                            guard let errorJson =  response.value  else {
                                return observer.onCompleted()
                            }
                            let errorDto = Mapper<ErrorDto>().map(JSONObject: errorJson)
                            
                            print("Error - SceneServices - getAllScenes()")
                            observer.onError(errorDto!)
                    }
                }

            return Disposables.create();
        })
    }
    
    func removeScene(idScene: [String]) -> Observable<[SceneDto]>{
        var body: [String: Any] = [:]
        body["id_scene"] = idScene
        
        
        return Observable<[SceneDto]>.create({observer in
            AF.request("\(RootApiService.BASE_API_URL)/scenes/remove/group", method: .delete, parameters: body, headers: self.headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                        case .success( _):
                            guard let responseData =  response.value as? [Any] else {
                                return observer.onCompleted()
                            }
                            var removedScenes: [SceneDto] = []
                            for sceneJson in responseData {
                                removedScenes.append(Mapper<SceneDto>().map(JSONObject: sceneJson)!)
                            }
                            observer.onNext(removedScenes)
                    case .failure(_):
                            guard let errorJson =  response.value  else {
                                return observer.onCompleted()
                            }
                            let errorDto = Mapper<ErrorDto>().map(JSONObject: errorJson)
                            
                            print("Error - SceneServices - removeScene()")
                            observer.onError(errorDto!)
                    }
                }
            return Disposables.create();
        })
    }
    
    
}
