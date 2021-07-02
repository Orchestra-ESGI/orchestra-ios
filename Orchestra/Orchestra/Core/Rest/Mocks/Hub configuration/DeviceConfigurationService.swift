//
//  DeviceConfigurationService.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 31/05/2021.
//

import Foundation
import ObjectMapper
import RxSwift
import RxCocoa

class DeviceConfigurationService{
    static var shared = DeviceConfigurationService()
    var configurationStream = PublishSubject<[HubAccessoryConfigurationDto]>()
    
    
    func getCurrentAccessoriesConfig() -> Observable<Bool>{
        return Observable<Bool>.create { observer in
            var hubAccessoriesMapped : [HubAccessoryConfigurationDto] = []
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if let path = Bundle.main.path(forResource: "DevicesConfiguration", ofType: "json") {
                    do {
                      let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                      let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                        if let jsonResult = jsonResult as? [String: Any],
                           let accessories = jsonResult["accessories"] as? [[String: Any]] {
                            
                            for accessory in accessories {
                                var accessoryMap : [String: Any] = [:]
                                guard let name = accessory["name"] as? String,
                                      let type = accessory["type"] as? String,
                                      let topics = accessory["actions"] as? [String: Any],
                                      let room = accessory["room"] as? [String: Any],
                                      let backgroundColor = accessory["background_color"] as? String,
                                      let manufacturer = accessory["manufacturer"] as? String,
                                      let isOn = accessory["is_on"] as? Bool,
                                      let isFav = accessory["is_fav"] as? Bool,
                                      let isReachable = accessory["is_reachable"] as? Bool,
                                      let model = accessory["model"] as? String,
                                      let friendlyName = accessory["friendly_name"] as? String else{
                                    return
                                }
                                
                                accessoryMap["name"] = name
                                accessoryMap["type"] = type
                                accessoryMap["room"] = room
                                accessoryMap["background_color"] = backgroundColor
                                accessoryMap["manufacturer"] = manufacturer
                                accessoryMap["is_on"] = isOn
                                accessoryMap["is_fav"] = isFav
                                accessoryMap["is_reachable"] = isReachable
                                accessoryMap["model"] = model
                                accessoryMap["friendly_name"] = friendlyName
                                
                                switch type {
                                case "lightbulb":
                                    let lighBulbConf = self.getLightBulbConf(topics, &accessoryMap)
                                    hubAccessoriesMapped.append(lighBulbConf)
                                case "programmableswitch":
                                    let programmableSwitch = self.getStatelessProgrammableSwitch(topics, &accessoryMap)
                                    hubAccessoriesMapped.append(programmableSwitch)
                                case "occupancysensor":
                                    let occupancySensorConf = self.getOccupancySensorConf(topics, &accessoryMap)
                                    hubAccessoriesMapped.append(occupancySensorConf)
                                default:
                                    print("Unknown device")
                                }
                            }
                            self.configurationStream.onNext(hubAccessoriesMapped)
                        }
                  } catch {
                    self.configurationStream.onError(error)
                    observer.onNext(false)
                  }
                    observer.onNext(true)
                }
            }
            return Disposables.create()
        }
    }
    
    private func getLightBulbConf(_ topics: [String: Any], _ accessoryMap: inout [String: Any]) -> HubAccessoryConfigurationDto{
        var lightBulbConf: HubAccessoryConfigurationDto?
        print("Light")
        accessoryMap["actions"] = topics
        
        lightBulbConf = Mapper<HubAccessoryConfigurationDto>().map(JSON: accessoryMap)!
        
        return lightBulbConf!
    }
    
    
    private func getOccupancySensorConf(_ topics: [String: Any], _ accessoryMap: inout [String: Any]) -> HubAccessoryConfigurationDto{
        print("Occupancy Sensor")
        let getOccupancyDetected = topics["getOccupancyDetected"] as! String
        accessoryMap["actions"] = [
            ["title": getOccupancyDetected]
        ]
        let occupancySensorConf = Mapper<HubAccessoryConfigurationDto>().map(JSON: accessoryMap)
        
        return occupancySensorConf!
    }
    
    private func getStatelessProgrammableSwitch(_ topics: [String: Any], _ accessoryMap: inout [String: Any]) -> HubAccessoryConfigurationDto{
        print("Stateless programmable switch")
        accessoryMap["toggleAction"] = topics["toggleAction"]
        
        let occupancySensorConf = Mapper<HubAccessoryConfigurationDto>().map(JSON: accessoryMap)
        
        return occupancySensorConf!
    }
    
}
