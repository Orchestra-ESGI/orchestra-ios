//
//  RootApiService.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/03/2021.
//

import Foundation
import Alamofire
import ObjectMapper
import RxSwift
import RxCocoa

public class RootApiService{
    /// Les fonctions globale de gestion du routing de l'app se fait ici
    
    static var shared = RootApiService()
    static let RAMZYPI_IP = "192.168.1.118"
    static let NASSIMPI_IP = "192.168.1.33"
    static let LOCAL_IP = "192.168.1.105"
    static let ORCHESTRA_HUB_IP = "orchestra.local"
    
    static var BASE_API_URL = "http://\(ORCHESTRA_HUB_IP):3000"
    var stringUtils = StringUtils.shared
    var fileUtils = FileUtils.shared

    let disposeBag = DisposeBag()
    
    var headers: HTTPHeaders = [
        "Content-Type":"application/json",
        "Accept": "application/json",
        "App-Key": "orchestra"
    ]

    func setHeaderToken(for token: String){
        self.headers["Authorization"] = "Bearer \(token)"
        print(self.headers)
    }
    
    func replaceHeaderToken(for token: String){
        if(headers["Authorization"] != nil){
            setHeaderToken(for: token)
        }
    }
    
    private init() {
        let preferences = UserDefaults.standard
        let token = preferences.string(forKey: "bearer-token")
        if token != nil {
            setHeaderToken(for: token!)
        }
        
    }
    
    func handleErrorResponse<T: Any>(observer: AnyObserver<T>? = nil, stream: PublishSubject<T>? = nil, response: HTTPURLResponse?){
        if(response == nil){
            print("no fckn response")
            observer?.onCompleted()
            stream?.onCompleted()
        }else{
            let status = response!.statusCode
            switch status {
            case 400:
                observer?.onError(ServerError.BadRequest)
                stream?.onError(ServerError.BadRequest)
            case 401:
                observer?.onError(ServerError.Unauthorized)
                stream?.onError(ServerError.Unauthorized)
            case 403:
                observer?.onError(ServerError.Forbidden)
                stream?.onError(ServerError.Forbidden)
            case 404:
                observer?.onError(ServerError.UnkownEndpoint)
                stream?.onError(ServerError.UnkownEndpoint)
            case 409:
                observer?.onError(ServerError.Conflict)
                stream?.onError(ServerError.Conflict)
            case 500:
                observer?.onError(ServerError.ServerError)
                stream?.onError(ServerError.ServerError)
            case 503:
                observer?.onError(ServerError.ServerError)
                stream?.onError(ServerError.ServerError)
            default:
                observer?.onError(ServerError.ServerError)
                stream?.onError(ServerError.ServerError)
            }
        }
    }
}

enum ServerError: Error {
    case BadRequest //400
    case Unauthorized //401
    case Forbidden //403
    case UnkownEndpoint //404
    case Conflict // 409 --> email déja existant
    case ServerError //500
}
