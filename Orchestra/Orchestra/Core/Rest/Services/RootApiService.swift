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
    
    static var BASE_API_URL = "http://192.168.1.33:3000" //"http://nassimpi.local:3000"
    var stringUtils = StringUtils.shared
    var fileUtils = FileUtils.shared

    let disposeBag = DisposeBag()
    
    var headers: HTTPHeaders = [
        "Content-Type":"application/json",
        "Accept": "application/json",
        "App-Key": "orchestra"
    ]

    func setHeaderToken(for token: String){
        self.headers["Authorization"] = token
    }
    
    init() {
        
    }
    
    func handleErrorResponse<T: Any>(observer: AnyObserver<T>, status: Int){
        switch status {
        case 400:
            print("")
            observer.onError(ServerError.BadRequest)
        case 401:
            print("")
            observer.onError(ServerError.Unauthorized)
        case 403:
            print("")
            observer.onError(ServerError.Forbidden)
        case 404:
            print("")
            observer.onError(ServerError.UnkownEndpoint)
        case 500:
            print("")
            observer.onError(ServerError.ServerError)
        case 503:
            print("")
            observer.onError(ServerError.ServerError)
        default:
            print("")
            observer.onError(ServerError.ServerError)
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
