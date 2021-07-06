//
//  UserServices.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 31/03/2021.
//

import Foundation
import Alamofire
import ObjectMapper
import RxSwift
import RxCocoa

class UserServices{
    let rootApiService = RootApiService.shared
    
    func getAllUsers() -> Observable<[UserDto]>? {
        return Observable<[UserDto]>.create({observer in
            AF.request("\(RootApiService.BASE_API_URL)/users/get/all", method: .get, parameters: nil, headers: self.rootApiService.headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                        case .success( _):
                            guard let responseData =  response.value as? [Any] else {
                                return observer.onCompleted()
                            }
                            var allMappedUsers: [UserDto] = []
                            for userJson in responseData {
                                allMappedUsers.append(Mapper<UserDto>().map(JSONObject: userJson)!)
                            }
                            observer.onNext(allMappedUsers)
                        case .failure(_):
                            let callResponse = response.response
                            self.rootApiService.handleErrorResponse(observer: observer, response: callResponse)
                    }
                }

            return Disposables.create();
        })
    }
    
    func removeUser(_ email: String) -> Observable<Bool>{
        var body: [String: Any] = [:]
        body["email"] = email
        
        return Observable<Bool>.create({ observer in
            AF.request("\(RootApiService.BASE_API_URL)/user", method: .delete, parameters: body, encoding: JSONEncoding.default, headers: self.rootApiService.headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                        case .success( _):
                            guard let responseData =  response.value as? [String: Any] else {
                                return observer.onCompleted()
                            }
                            if let _ = responseData["error"] as? String {
                                observer.onNext(false)
                            } else {
                                observer.onNext(true)
                            }
                        case .failure( _):
                            let callResponse = response.response
                            self.rootApiService.handleErrorResponse(observer: observer, response: callResponse)
                    }
                }
            return Disposables.create();
        })
    }
    
    /// Updates on of the following credentials of a user:
    /// - Name
    /// - Password
    /// - Email
    
    /// Parameters:
    /// `credentialName` : credential to update
    /// `userId`: id of the user we want to update
    /// `credentialValue`: the new value of the credential updated
    
    func updateUser(_  credentialName: String, _ userId: String, _ credentialValue: String) -> Observable<UserDto>{
        var body: [String: Any] = [:]
        body["user_id"] = userId
        switch credentialName {
            case "name":
                body["update_name"] = credentialValue
            case "password":
                body["update_password"] = credentialValue
            case "email":
                body["update_email"] = credentialValue
            default:
                body["update_name"] = credentialValue
        }
        
        
        return Observable<UserDto>.create({observer in
            AF.request("\(RootApiService.BASE_API_URL)/users/update/\(credentialName)", method: .put, parameters: body, encoding: JSONEncoding.default, headers: self.rootApiService.headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                        case .success( _):
                            guard let responseData =  response.value else {
                                return observer.onCompleted()
                            }
                            let updatedUser = Mapper<UserDto>().map(JSONObject: responseData)!
                            observer.onNext(updatedUser)
                        case .failure( _):
                            let callResponse = response.response
                            self.rootApiService.handleErrorResponse(observer: observer, response: callResponse)
                    }
                }
            return Disposables.create();
        })
    }
    
    func login(email: String, password: String) -> Observable<UserDto>{
        var body: [String: Any] = [:]
        body["email"] = email
        body["password"] = password
        
        return Observable<UserDto>.create({observer in
            AF.request("\(RootApiService.BASE_API_URL)/user/login", method: .post, parameters: body, encoding: JSONEncoding.default, headers: self.rootApiService.headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                        case .success( _):
                            guard let responseData =  response.value as? [String: Any] else {
                                return observer.onCompleted()
                            }
                            let user = Mapper<UserDto>().map(JSONObject: responseData)!
                            self.saveUserCredentials(response: responseData)
                            
                            observer.onNext(user)
                        case .failure( _):
                            let callResponse = response.response
                            self.rootApiService.handleErrorResponse(observer: observer, response: callResponse)
                    }
                }
            return Disposables.create();
        })
    }
    
    func signup(email: String, password: String) -> Observable<UserDto>{
        var body: [String: Any] = [:]
        body["email"] = email
        body["password"] = password
        
        return Observable<UserDto>.create({observer in
            AF.request("\(RootApiService.BASE_API_URL)/user/signup", method: .post, parameters: body, encoding: JSONEncoding.default, headers: self.rootApiService.headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                        case .success( _):
                            guard let responseData =  response.value else {
                                return observer.onCompleted()
                            }
                            let signedUser = Mapper<UserDto>().map(JSONObject: responseData)!
                            observer.onNext(signedUser)
                        case .failure( _):
                            let callResponse = response.response
                            self.rootApiService.handleErrorResponse(observer: observer, response: callResponse)
                        }
                }
            return Disposables.create();
        })
    }
    
    func saveUserCredentials(response: [String: Any]){
        // Save user credentials in shared pref or local storage
        guard let token = response["token"] as? String,
              let email = response["email"] as? String else {
            return
        }
        let preferences = UserDefaults.standard
        preferences.set(token, forKey: "bearer-token")
        preferences.set(email, forKey: "email")
        self.rootApiService.setHeaderToken(for: token)
        let didSave = preferences.synchronize()
        if !didSave {
            NSLog("Error while saving user data in shared preferences")
        }
    }
    
    func updateUserCredentials(){
        // Update saved user credentials in shared pref or local storage
    }
    
    func factoryRestHub(){
        AF.request("\(RootApiService.BASE_API_URL)/factory-reset", method: .post, parameters: nil, encoding: JSONEncoding.default, headers: self.rootApiService.headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                    case .success( _):
                        print("success")
                    case .failure( _):
                        print("failure")
                }
            }
    }
    
    func shutDownHub(){
        AF.request("\(RootApiService.BASE_API_URL)/shutdown", method: .post, parameters: nil, encoding: JSONEncoding.default, headers: self.rootApiService.headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                    case .success( _):
                        print("success")
                    case .failure( _):
                        print("failure")
                }
            }
    }
    
    func rebootHub(){
        AF.request("\(RootApiService.BASE_API_URL)/reboot", method: .post, parameters: nil, encoding: JSONEncoding.default, headers: self.rootApiService.headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                    case .success( _):
                        print("success")
                    case .failure( _):
                        print("failure")
                }
            }
    }
}
