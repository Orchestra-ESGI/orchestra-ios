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
    
    static var BASE_API_URL = "http://\(LOCAL_IP):3000"
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
                print("")
                observer?.onError(ServerError.BadRequest)
                stream?.onError(ServerError.BadRequest)
            case 401:
                print("")
                observer?.onError(ServerError.Unauthorized)
                stream?.onError(ServerError.Unauthorized)
            case 403:
                print("")
                observer?.onError(ServerError.Forbidden)
                stream?.onError(ServerError.Forbidden)
            case 404:
                print("")
                observer?.onError(ServerError.UnkownEndpoint)
                stream?.onError(ServerError.UnkownEndpoint)
            case 500:
                print("")
                observer?.onError(ServerError.ServerError)
                stream?.onError(ServerError.ServerError)
            case 503:
                print("")
                observer?.onError(ServerError.ServerError)
                stream?.onError(ServerError.ServerError)
            default:
                print("")
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
    case ServerError //500
}
