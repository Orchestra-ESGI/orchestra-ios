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
                                      let topics = accessory["topics"] as? [String: Any],
                                      let id = accessory["id"] as? String,
                                      let roomName = accessory["roomName"] as? String,
                                      let backgroundColor = accessory["backgroundColor"] as? String,
                                      let serialNumber = accessory["serialNumber"] as? String ,
                                      let manufacturer = accessory["manufacturer"] as? String,
                                      let isOn = accessory["isOn"] as? Bool,
                                      let isFav = accessory["isFav"] as? Bool,
                                      let isReachable = accessory["isReachable"] as? Bool,
                                      let model = accessory["model"] as? String,
                                      let version = accessory["version"] as? String else{
                                    return
                                }
                                
                                accessoryMap["name"] = name
                                accessoryMap["type"] = type
                                accessoryMap["id"] = id
                                accessoryMap["roomName"] = roomName
                                accessoryMap["backgroundColor"] = backgroundColor
                                accessoryMap["serialNumber"] = serialNumber
                                accessoryMap["manufacturer"] = manufacturer
                                accessoryMap["isOn"] = isOn
                                accessoryMap["isFav"] = isFav
                                accessoryMap["isReachable"] = isReachable
                                accessoryMap["model"] = model
                                accessoryMap["version"] = version
                                
                                switch type {
                                case "lightbulb":
                                    let lighBulbConf = self.getLightBulbConf(topics, &accessoryMap)
                                    hubAccessoriesMapped.append(lighBulbConf)
                                case "statelessProgrammableSwitch":
                                    let programmableSwitch = self.getStatelessProgrammableSwitch(topics, &accessoryMap)
                                    hubAccessoriesMapped.append(programmableSwitch)
                                case "occupancySensor":
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
        let getOnTopic = topics["getOn"] as! String
        let setOnTopic = topics["setOn"] as! String
        let friendlyName = getOnTopic.split(separator: "/")[1].description
        accessoryMap["actions"] = [
            ["title": getOnTopic],
            ["title": setOnTopic]
        ]
        accessoryMap["friendly_name"] = friendlyName
        
        
        
        lightBulbConf = Mapper<HubAccessoryConfigurationDto>().map(JSON: accessoryMap)!
        
        return lightBulbConf!
    }
    
    
    private func getOccupancySensorConf(_ topics: [String: Any], _ accessoryMap: inout [String: Any]) -> HubAccessoryConfigurationDto{
        print("Occupancy Sensor")
        let getOccupancyDetected = topics["getOccupancyDetected"] as! String
        let friendlyName = getOccupancyDetected.split(separator: "/")[1].description
        accessoryMap["actions"] = [
            ["title": getOccupancyDetected]
        ]
        accessoryMap["friendly_name"] = friendlyName
        let occupancySensorConf = Mapper<HubAccessoryConfigurationDto>().map(JSON: accessoryMap)
        
        return occupancySensorConf!
    }
    
    private func getStatelessProgrammableSwitch(_ topics: [String: Any], _ accessoryMap: inout [String: Any]) -> HubAccessoryConfigurationDto{
        print("Stateless programmable switch")
        let getOccupancyDetected = topics["getSwitch"] as! [String: Any]
        let topic = getOccupancyDetected["topic"] as! String
        let friendlyName = topic.split(separator: "/")[1].description
        accessoryMap["actions"] = [
            ["title": topic]
        ]
        accessoryMap["friendly_name"] = friendlyName
        let occupancySensorConf = Mapper<HubAccessoryConfigurationDto>().map(JSON: accessoryMap)
        
        return occupancySensorConf!
    }
}
