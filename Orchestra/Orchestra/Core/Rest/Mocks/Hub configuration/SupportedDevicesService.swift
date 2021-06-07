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
                    if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let accessories = jsonResult["accessories"] as? [Any] {
                        var mappedAccessories: [SupportedAccessoriesDto] = []
                        for accessory in accessories {
                            mappedAccessories.append(Mapper<SupportedAccessoriesDto>().map(JSON: (accessory as? [String: Any])!)!)
                        }
                        self.accessoriesStream.onNext(mappedAccessories)
                    }
              } catch {
                self.accessoriesStream.onError(error)
              }
            }
        }
    }
}
