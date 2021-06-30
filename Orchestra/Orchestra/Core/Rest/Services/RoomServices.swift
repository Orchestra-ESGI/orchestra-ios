//
//  RoomServices.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 30/06/2021.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift

class RoomServices{
    let rootApiService = RootApiService.shared
    
    func create(body: [String: Any]) -> Observable<Bool>{
        return Observable<Bool>.create({observer in
            AF.request("\(RootApiService.BASE_API_URL)/room",
                       method: .post,
                       parameters: body,
                       encoding: JSONEncoding.default,
                       headers: self.rootApiService.headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                        case .success( _):
                            print("Room creation ok")
                            observer.onNext(true)
                        case .failure( _):
                            print("Room creation ko")
                            observer.onNext(false)
                            let callResponse = response.response
                            self.rootApiService.handleErrorResponse(observer: observer, response: callResponse)
                    }
                }
            return Disposables.create();
        })
    }
}
