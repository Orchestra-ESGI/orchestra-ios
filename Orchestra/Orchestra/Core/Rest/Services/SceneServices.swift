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

class SceneServices{
    let rootApiService = RootApiService.shared
    var sceneStream = PublishSubject<[SceneDto]>()
    
    func getAllScenes() -> Observable<Bool>{
        
        return Observable<Bool>.create({observer in
            AF.request("\(RootApiService.BASE_API_URL)/scene/all", method: .get, parameters: nil, headers: self.rootApiService.headers)
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
                            let callResponse = response.response
                            self.rootApiService.handleErrorResponse(stream: self.sceneStream,
                                                                    response: callResponse)
                            observer.onNext(false)
                            print("Error - SceneServices - getAllScenes()")
                    }
                }
            return Disposables.create()
        })
    }
    
    func removeScene(idsScene: [String]) -> Observable<Bool>{

        return Observable<Bool>.create({observer in
            AF.request("\(RootApiService.BASE_API_URL)/scene", method: .delete, parameters: ["ids": idsScene], encoding: JSONEncoding.default, headers: self.rootApiService.headers)
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
    
    private func sendScene(scene: [String: Any], method: HTTPMethod) -> Observable<Bool>{
        return Observable<Bool>.create({observer in
            AF.request("\(RootApiService.BASE_API_URL)/scene", method: method, parameters: scene, encoding: JSONEncoding.default,  headers: self.rootApiService.headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                        case .success( _):
                            observer.onNext(true)
                        case .failure(_):
                            let callReponse = response.response
                            self.rootApiService.handleErrorResponse(observer: observer, response: callReponse)
                            print("Error - SceneServices - createNewScene()")
                    }
                }
            return Disposables.create();
        })
    }
    
    func updateScene(scene: [String: Any]) -> Observable<Bool> {
        self.sendScene(scene: scene, method: .patch)
    }
    
    func createNewScene(scene: [String: Any]) -> Observable<Bool>{
        self.sendScene(scene: scene, method: .post)
    }
    
    func launchScene(id: String){
        _ = AF.request("\(RootApiService.BASE_API_URL)/scene/\(id)", method: .post, parameters: nil, encoding: JSONEncoding.default,  headers: self.rootApiService.headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                    case .success( _):
                        print("Scene correctly launched")
                    case .failure(_):
                        print("Error - SceneServices - launchScene()")
                        
                }
            }
    }
}
