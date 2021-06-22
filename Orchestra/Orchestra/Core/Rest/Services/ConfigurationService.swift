//
//  DeviceConfigurationService.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 07/06/2021.
//

import Foundation

import Foundation
import Alamofire
import RxCocoa
import RxSwift
import ObjectMapper

class ConfigurationService{
    let rootApiService = RootApiService.shared
    var confStream = PublishSubject<[SupportedAccessoriesDto]>()
    
    func getCurrentAccessoriesConfig() {
        AF.request("\(RootApiService.BASE_API_URL)/device/supported", method: .get, encoding: JSONEncoding.default, headers: self.rootApiService.headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
            switch response.result {
                case .success( _):
                    print("ok")
                    guard let dataResponse = response.value as? [[String: Any]] else{
                        return
                    }
                    var mappedAccessories: [SupportedAccessoriesDto] = []
                    for accessory in dataResponse {
                        mappedAccessories.append(Mapper<SupportedAccessoriesDto>().map(JSON: accessory)!)
                    }
                    self.confStream.onNext(mappedAccessories)
                case .failure(_):
                    print("ko")
                    guard let errorJson =  response.error,
                          let error = errorJson.underlyingError else {
                        self.confStream.onCompleted()
                        return
                    }
                    
                    print("Error - ConfigurationService - getCurrentAccessoriesConfig()")
                    self.confStream.onError(error)
            }
        }
    }
    
}
