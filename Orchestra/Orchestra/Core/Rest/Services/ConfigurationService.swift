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

class ConfigurationService: RootApiService{
    
    func getCurrentAccessoriesConfig(_ confStream: PublishSubject<[SupportedAccessoriesDto]>) {
        AF.request("\(RootApiService.BASE_API_URL)/configuration", method: .get, encoding: JSONEncoding.default, headers: headers)
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
                    confStream.onNext(mappedAccessories)
                case .failure(_):
                    print("ko")
            }
        }
    }
    
}
