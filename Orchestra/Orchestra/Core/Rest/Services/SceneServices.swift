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
    
    func removeScene(idsScene: [String]) -> Observable<Bool>{

        return Observable<Bool>.create({observer in
            AF.request("\(RootApiService.BASE_API_URL)/scene", method: .delete, parameters: ["ids": idsScene], encoding: JSONEncoding.default, headers: self.headers)
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
    
    func createNewScene(scene: [String: Any]) -> Observable<Bool>{
        return Observable<Bool>.create({observer in
            AF.request("\(RootApiService.BASE_API_URL)/scene", method: .post, parameters: scene, encoding: JSONEncoding.default,  headers: self.headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                        case .success( _):
                            observer.onNext(true)
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
