//
//  HouseServices.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 31/03/2021.
//

import Foundation
import Alamofire
import ObjectMapper
import RxSwift
import RxCocoa

class HouseServices: RootApiService{
    let rootApiService = RootApiService.shared
    
    func getAllHouses(idUser: String) -> Observable<[HouseDto]>? {
        var body: [String: Any] = [:]
        body["id_user"] = idUser
        
        return Observable<[HouseDto]>.create({observer in
            AF.request("\(RootApiService.BASE_API_URL)/houses/get/all", method: .get, parameters: body, headers: self.headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                        case .success( _):
                            guard let responseData =  response.value as? [Any] else {
                                return observer.onCompleted()
                            }
                            var allMappedHouses: [HouseDto] = []
                            for houseJson in responseData {
                                allMappedHouses.append(Mapper<HouseDto>().map(JSONObject: houseJson)!)
                            }
                            observer.onNext(allMappedHouses)
                        case .failure(_):
                            guard let errorJson =  response.value  else {
                                return observer.onCompleted()
                            }
                            let errorDto = Mapper<ErrorDto>().map(JSONObject: errorJson)
                            
                            print("Error - HouseServices - getAllHouses()")
                            observer.onError(errorDto!)
                    }
                }

            return Disposables.create();
        })
    }
    
    func removeScene(idHouse: [String]) -> Observable<[HouseDto]>{
        var body: [String: Any] = [:]
        body["id_house"] = removeScene
        
        
        return Observable<[HouseDto]>.create({observer in
            AF.request("\(RootApiService.BASE_API_URL)/houses/remove/group", method: .delete, parameters: body, headers: self.headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                        case .success( _):
                            guard let responseData =  response.value as? [Any] else {
                                return observer.onCompleted()
                            }
                            var removedHouses: [HouseDto] = []
                            for houseJson in responseData {
                                removedHouses.append(Mapper<HouseDto>().map(JSONObject: houseJson)!)
                            }
                            observer.onNext(removedHouses)
                        case .failure(_):
                            let callResponse = response.response
                            self.rootApiService.handleErrorResponse(observer: observer, response: callResponse)
                            print("Error - HouseServices - removeScene()")
                    }
                }
            return Disposables.create();
        })
    }
}
