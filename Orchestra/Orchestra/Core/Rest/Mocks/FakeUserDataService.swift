//
//  FakeUserDataService.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/03/2021.
//

import Foundation
import ObjectMapper
import RxSwift
import RxCocoa

class FakeApi{
    static var shared = FakeApi()
    var userStream = PublishSubject<[UserDto]>()
    var userSignupStream = PublishSubject<UserDto>()
    
    func getAllFakeUsers(){
        if let path = Bundle.main.path(forResource: "Users", ofType: "json") {
            do {
              let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
              let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let person = jsonResult["users"] as? [Any] {
                    var mappedUsers: [UserDto] = []
                    for user in person {
                        mappedUsers.append(Mapper<UserDto>().map(JSON: (user as? [String: Any])!)!)
                    }
                    userStream.onNext(mappedUsers)
                }
          } catch {
            userStream.onError(error)
          }
        }
    }
    
    func signup(){
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { (timer) in
            let dtoTest = UserDto(JSON: ["": ""])
            self.userSignupStream.onNext(dtoTest!)
        }
    }
}
