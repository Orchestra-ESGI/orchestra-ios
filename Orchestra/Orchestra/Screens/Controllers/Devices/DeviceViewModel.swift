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
    let hubAccessoriesConfig = SupportedDevicesService.shared
    let supportedAccessoriesStrem = PublishSubject<[SupportedAccessoriesDto]>()
    
    
    func getSupportedAccessories(){
        _ = self.hubAccessoriesConfig.accessoriesStream.subscribe { accesories in
            self.supportedAccessoriesStrem.onNext(accesories)
        } onError: { err in
            self.supportedAccessoriesStrem.onError(err)
        }
        self.hubAccessoriesConfig.getCurrentAccessoriesConfig()
    }
}
