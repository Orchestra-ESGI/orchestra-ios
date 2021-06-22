//
//  HomeService.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 06/06/2021.
//

import Foundation
import RxCocoa
import RxSwift
import ObjectMapper
import Alamofire

class HomeService{
    let rootApiService = RootApiService.shared
    
    let deviceService = DeviceServices()
    let sceneService = FakeSceneDataService() //SceneServices()
    let configurationService = ConfigurationService()
    
    let deviceStream = PublishSubject<[HubAccessoryConfigurationDto]>()
    let sceneStream = PublishSubject<[SceneDto]>()
    let confStream = PublishSubject<[SupportedAccessoriesDto]>()
        
}
