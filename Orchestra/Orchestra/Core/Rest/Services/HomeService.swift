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

class HomeService: RootApiService{
    let devicesStream = PublishSubject<[HubAccessoryConfigurationDto]>()
    
    func getAllDevices() -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            AF.request("http://192.168.1.33:3000/device/all", method: .get, parameters: nil, headers: self.headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                switch response.result {
                    case .success( _):
                        guard let responseData =  response.value as? [String: Any],
                          let devices = responseData["devices"] as? [[String: Any]] else {
                            return
                        }
                        var allMappedDevices: [HubAccessoryConfigurationDto] = []
                        for devicesJson in devices {
                            allMappedDevices.append(Mapper<HubAccessoryConfigurationDto>().map(JSONObject: devicesJson)!)
                        }
                        self.devicesStream.onNext(allMappedDevices)
                        observer.onNext(true)
                    case .failure(_):
                        guard let errorJson =  response.value  else {
                            return
                        }
                        let errorDto = Mapper<ErrorDto>().map(JSONObject: errorJson)
                        
                        print("Error - SceneServices - getAllScenes()")
                        self.devicesStream.onError(errorDto as! Error)
                        observer.onNext(false)
                }
            }
            
            return Disposables.create()
        }
    }
    
    
    func sendDeviceAction(_ body: [String: Any]) {
        AF.request("http://192.168.1.33:3000/device/action", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
            switch response.result {
                case .success( _):
                    print("ok")
                case .failure(_):
                    print("ko")
            }
        }
    }
        
}
