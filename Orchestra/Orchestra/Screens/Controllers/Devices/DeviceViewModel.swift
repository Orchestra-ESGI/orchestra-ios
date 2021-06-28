//
//  DeviceViewModel.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/05/2021.
//

import Foundation
import RxSwift
import RxCocoa


class DeviceViewModel{
    let deviceConfig = DeviceConfigurationService.shared
    let hubAccessoriesConfig = ConfigurationService()
    
    // Device layer conv data
    let deviceService = DeviceServices()
    let devicesStream = PublishSubject<[HubAccessoryConfigurationDto]>()
    
    let supportedAccessoriesStrem = PublishSubject<[SupportedAccessoriesDto]>()
    let deviceFormCompleted = PublishSubject<Bool>()
    
    private var saveDeviceDelegate: SendDeviceProtocol?
    private var navCtrl: UINavigationController?
    private let homeService = HomeService()
    
    init(navigationCtrl: UINavigationController) {
        self.navCtrl = navigationCtrl
        let homeViewController = self.navCtrl!.viewControllers[0] as? HomeViewController
        self.saveDeviceDelegate = homeViewController
    }
    
    func getAllDevices() -> Observable<Bool>{
        _ = self.deviceService.devicesStream.subscribe{ devices in
            self.devicesStream.onNext(devices)
        } onError: { err in
            self.devicesStream.onError(err)
        }
        return self.deviceService.getAllDeviceList()
    }
    
    func removeDevices(friendlyNames: [String]) -> Observable<Bool>{
        return self.deviceService.removeDevices(friendlyNames: friendlyNames)
    }
    
    func getSupportedAccessories(){
        _ = self.hubAccessoriesConfig.confStream.subscribe { accesories in
            self.supportedAccessoriesStrem.onNext(accesories)
        } onError: { err in
            self.supportedAccessoriesStrem.onError(err)
        }onCompleted: {
            self.supportedAccessoriesStrem.onCompleted()
        }
        self.hubAccessoriesConfig.getCurrentAccessoriesConfig()
    }
    
    func sendDeviceAction(body: [String: Any]){
        self.deviceService.sendDeviceAction(body)
    }
    
    
    func updateDevice(deviceData: HubAccessoryConfigurationDto){
        self.deviceService.updateDevice(deviceData.toMap())
    }
    
    func resetDevice(){
        self.deviceService.resetDevice()
    }
}
