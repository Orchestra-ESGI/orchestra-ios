//
//  SupportedDevicesService.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/05/2021.
//

import Foundation
import ObjectMapper
import RxSwift
import RxCocoa

class SupportedDevicesService{
    static var shared = SupportedDevicesService()
    var accessoriesStream = PublishSubject<[SupportedAccessoriesDto]>()
    
    func getCurrentAccessoriesConfig(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let path = Bundle.main.path(forResource: "SupportedDevices", ofType: "json") {
                do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    if let jsonResult = jsonResult as? [[String: Any]] {
                        var mappedAccessories: [SupportedAccessoriesDto] = []
                        for accessory in jsonResult {
                            mappedAccessories.append(Mapper<SupportedAccessoriesDto>().map(JSON: accessory)!)
                        }
                        self.accessoriesStream.onNext(mappedAccessories)
                    }
              } catch {
//                guard let errorJson =  response.error,
//                      let error = errorJson.underlyingError else {
//                    return
//                }
//                
//                print("Error - SupportedDevicesService - getCurrentAccessoriesConfig()")
                self.accessoriesStream.onError(error)
              }
            }
        }
    }
}
