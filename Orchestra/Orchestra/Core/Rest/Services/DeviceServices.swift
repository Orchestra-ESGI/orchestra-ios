//
//  DeviceServices.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 06/06/2021.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift
import ObjectMapper

class DeviceServices: RootApiService{
    let devicesStream = PublishSubject<[HubAccessoryConfigurationDto]>()
    
    func getAllDevices(_ devicesStream: PublishSubject<[HubAccessoryConfigurationDto]>) -> Observable<Bool>{
        return Observable<Bool>.create { observer in
            var hubAccessoriesMapped : [HubAccessoryConfigurationDto] = []
            
            AF.request("\(RootApiService.BASE_API_URL)/device/all", method: .get, encoding: JSONEncoding.default, headers: self.headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                switch response.result {
                    case .success( _):
                        print("ok")
                        
                        guard let dataResponse = response.value as? [String: Any],
                              let accessories = dataResponse["accessories"] as? [[String: Any]] else{
                            return
                        }
                        for accessory in accessories {
                            var accessoryMap : [String: Any] = [:]
                            
                            guard let name = accessory["name"] as? String,
                                  let type = accessory["type"] as? String,
                                  let topics = accessory["actions"] as? [String: Any],
                                  let roomName = accessory["room_name"] as? String,
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
                            accessoryMap["room_name"] = roomName
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
                        devicesStream.onNext(hubAccessoriesMapped)
                    case .failure(_):
                        print("ko")
                        let error = response.response!.statusCode
                        self.handleErrorResponse(observer: observer, status: error)
                }
            }
            return Disposables.create()
        }
    }
    
    func removeDevices(friendlyNames: [String]) -> Observable<Bool>{
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 3
        return Observable<Bool>.create { observer in
            
            manager.request("\(RootApiService.BASE_API_URL)/device", method: .delete, parameters: ["friendly_names": friendlyNames], encoding: JSONEncoding.default, headers: self.headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                switch response.result {
                    case .success( _):
                        observer.onNext(true)
                    case .failure(_):
                        print("Error - DeviceServices - removeDevices()")
                        observer.onNext(false)
                }
            }
            
            return Disposables.create()
        }
    }
    
    
    func getAllDeviceList() -> Observable<Bool> { // Works
        //let manager = Alamofire.SessionManager.default
        let manager = Alamofire.Session.default
        //manager.session.configuration.timeoutIntervalForRequest = 3
        
        return Observable<Bool>.create { observer in
            
            //AF.request
            manager.request("\(RootApiService.BASE_API_URL)/device/all", method: .get, parameters: nil, headers: self.headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                switch response.result {
                    case .success( _):
                        guard let responseData =  response.value as? [String: Any],
                          let devices = responseData["devices"] as? [[String: Any]] else {
                            
                            self.devicesStream.onNext([])
                            observer.onNext(false)
                            return
                        }
                        var allMappedDevices: [HubAccessoryConfigurationDto] = []
                        for devicesJson in devices {
                            allMappedDevices.append(Mapper<HubAccessoryConfigurationDto>().map(JSONObject: devicesJson)!)
                        }
                        self.devicesStream.onNext(allMappedDevices)
                        observer.onNext(true)
                    case .failure(_):
                        //((response.error as! AFError).underlyingError as! Error)
                        guard let errorJson =  response.error,
                              let error = errorJson.underlyingError else {
                            return
                        }
                        
                        print("Error - SceneServices - getAllScenes()")
                        self.devicesStream.onError(error)
                        observer.onNext(false)
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
    
    func saveDevice(_ body: [String: Any]) {
        AF.request("\(RootApiService.BASE_API_URL)/device/add", method: .post, parameters: body, encoding: JSONEncoding.default, headers: self.headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
            switch response.result {
                case .success( _):
                    print("OK - Saved device")
                case .failure(_):
                    print("KO - Saved device")
            }
        }
    }
    
    func resetDevice() {
        AF.request("\(RootApiService.BASE_API_URL)/device/reset", method: .post, parameters: nil, encoding: JSONEncoding.default, headers: self.headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
            switch response.result {
                case .success( _):
                    print("OK - Reset device")
                case .failure(_):
                    print("KO - Reset device")
            }
        }
    }
    
    func sendDeviceAction(_ body: [String: Any]) {
        AF.request("\(RootApiService.BASE_API_URL)/device/action", method: .post, parameters: body, encoding: JSONEncoding.default, headers: self.headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
            switch response.result {
                case .success( _):
                    print("OK - Send device action")
                case .failure(_):
                    print("KO - Send device action")
            }
        }
    }
}
