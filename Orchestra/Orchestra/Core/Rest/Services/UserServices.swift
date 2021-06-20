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

class UserServices: RootApiService{
    
    func getAllUsers() -> Observable<[UserDto]>? {
        return Observable<[UserDto]>.create({observer in
            AF.request("\(RootApiService.BASE_API_URL)/users/get/all", method: .get, parameters: nil, headers: self.headers)
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
                            guard let errorJson =  response.value  else {
                                return observer.onCompleted()
                            }
                            let errorDto = Mapper<ErrorDto>().map(JSONObject: errorJson)
                            
                            print("Error - UserServices - getAllUsers()")
                            observer.onError(errorDto!)
                    }
                }

            return Disposables.create();
        })
    }
    
    /// Removes 1 or many users
    func removeUser(usersId: [String]) -> Observable<[String]>{
        var body: [String: Any] = [:]
        body["id_user"] = usersId
        
        
        return Observable<[String]>.create({observer in
            AF.request("\(RootApiService.BASE_API_URL)/users/get/all", method: .delete, parameters: body, encoding: JSONEncoding.default, headers: self.headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                        case .success( _):
                            guard let responseData =  response.value as? [String: Any],
                                  let usersIds = responseData["users_id"] as? [String] else {
                                observer.onNext([])
                                return
                            }
                            observer.onNext(usersIds)
                        case .failure(_):
                                guard let errorJson =  response.value  else {
                                    return observer.onCompleted()
                                }
                                let errorDto = Mapper<ErrorDto>().map(JSONObject: errorJson)
                                
                                print("Error - UserServices - removeUser()")
                                observer.onError(errorDto!)
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
            AF.request("\(RootApiService.BASE_API_URL)/users/update/\(credentialName)", method: .put, parameters: body, encoding: JSONEncoding.default, headers: self.headers)
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
                                guard let errorJson =  response.value  else {
                                    return observer.onCompleted()
                                }
                                let errorDto = Mapper<ErrorDto>().map(JSONObject: errorJson)
                                
                                print("Error - UserServices - updateUser()")
                                observer.onError(errorDto!)
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
            AF.request("\(RootApiService.BASE_API_URL)/user/login", method: .post, parameters: body, encoding: JSONEncoding.default, headers: self.headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                        case .success( _):
                            guard let responseData =  response.value as? [String: Any] else {
                                return observer.onCompleted()
                            }
                            let user = Mapper<UserDto>().map(JSONObject: responseData)!
                            self.saveUsreCredentials(response: responseData)
                            
                            observer.onNext(user)
                        case .failure( _):
                            guard let errorJson =  response.value  else {
                                return observer.onCompleted()
                            }
                            let errorDto = Mapper<ErrorDto>().map(JSONObject: errorJson)
                            
                            print("Error - UserServices - login()")
                            observer.onError(errorDto!)
                    }
                }
            return Disposables.create();
        })
    }
    
    func signup(name: String, email: String, password: String) -> Observable<UserDto>{
        var body: [String: Any] = [:]
        body["name"] = email
        body["email"] = email
        body["password"] = password
        
        return Observable<UserDto>.create({observer in
            AF.request("\(RootApiService.BASE_API_URL)/user/signup", method: .post, parameters: body, encoding: JSONEncoding.default, headers: self.headers)
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
                                guard let errorJson =  response.value  else {
                                    return observer.onCompleted()
                                }
                                let errorDto = Mapper<ErrorDto>().map(JSONObject: errorJson)
                                
                                print("Error - UserServices - singin()")
                                observer.onError(errorDto!)
                        }
                }
            return Disposables.create();
        })
    }
    
    func saveUsreCredentials(response: [String: Any]){
        // Save user credentials in shared pref or local storage
        guard let token = response["token"] as? String else {
            return
        }
        let preferences = UserDefaults.standard
        if preferences.object(forKey: "bearer-token") == nil {
            preferences.set(token, forKey: "bearer-token")
            self.setHeaderToken(for: token)
            let didSave = preferences.synchronize()
            if !didSave {
                NSLog("Error while saving user data in shared preferences")
            }
        }
    }
    
    func updateUserCredentials(){
        // Update saved user credentials in shared pref or local storage
    }
    
}
