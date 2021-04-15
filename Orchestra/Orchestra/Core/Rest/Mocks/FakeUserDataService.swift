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

class FakeUserServices{
    static var shared = FakeUserServices()
    var userStream = PublishSubject<[UserDto]>()
    var userSignupStream = PublishSubject<UserDto>()
    
    func getAllFakeUsers(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let path = Bundle.main.path(forResource: "Users", ofType: "json") {
                do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let person = jsonResult["users"] as? [Any] {
                        var mappedUsers: [UserDto] = []
                        for user in person {
                            mappedUsers.append(Mapper<UserDto>().map(JSON: (user as? [String: Any])!)!)
                        }
                        self.userStream.onNext(mappedUsers)
                    }
              } catch {
                self.userStream.onError(error)
              }
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
