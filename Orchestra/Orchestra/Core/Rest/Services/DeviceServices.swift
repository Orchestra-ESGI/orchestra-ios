//
//  DeviceServices.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 06/06/2021.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift

class DeviceServices: RootApiService{
    
    func saveDevice(_ body: [String: Any]) {
        AF.request("http://192.168.1.33:3000/device/add", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
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
