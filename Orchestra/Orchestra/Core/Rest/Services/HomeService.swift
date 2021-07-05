//
//  HomeService.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 06/06/2021.
//

import Foundation
import RxCocoa
import RxSwift
import ObjectMapper
import Alamofire

class HomeService{
    let rootApiService = RootApiService.shared
    
    let deviceService = DeviceServices()
    let configurationService = ConfigurationService()
    
    let deviceStream = PublishSubject<[HubAccessoryConfigurationDto]>()
    let sceneStream = PublishSubject<[SceneDto]>()
    let confStream = PublishSubject<[SupportedAccessoriesDto]>()
    let roomsStream = PublishSubject<[RoomDto]>()
        
    func getAllRooms() -> Observable<[RoomDto]>{
        let manager = Alamofire.Session.default
        
        return Observable<[RoomDto]>.create { observer in
            manager.request("\(RootApiService.BASE_API_URL)/room/all", method: .get, parameters: nil, headers: self.rootApiService.headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                        case .success( _):
                            guard let responseData =  response.value as? [String: Any],
                              let rooms = responseData["rooms"] as? [[String: Any]] else {
                                
                                self.roomsStream.onNext([])
                                return
                            }
                            var allMappedRooms: [RoomDto] = []
                            for roomJson in rooms {
                                allMappedRooms.append(Mapper<RoomDto>().map(JSONObject: roomJson)!)
                            }
                            observer.onNext(allMappedRooms)
                        case .failure(_):
                            print("Error - HomeServices - getAllRooms()")
                            let callResponse = response.response
                            self.rootApiService.handleErrorResponse(observer: observer, response: callResponse)
                    }
                }
            
            return Disposables.create()
        }
    }
}
