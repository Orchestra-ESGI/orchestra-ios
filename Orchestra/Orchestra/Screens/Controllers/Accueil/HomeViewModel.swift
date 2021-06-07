//
//  HomeViewModel.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/04/2021.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel{
    
    // - MARK: Services
    let fakeObjectsWS = FakeObjectsDataService.shared
    let fakeScenesWS = FakeSceneDataService.shared
    
    let homeService: HomeService = HomeService()
    let hubConfigWs = DeviceConfigurationService.shared
    
    // - MARK: Data
    let disposeBag = DisposeBag()
    
    init(){
        
    }
    
    func clearObjectSelected(completion: @escaping ()->()) -> Observable<Bool>{
        return Observable<Bool>.create { (observer) -> Disposable in
                _ = self.fakeObjectsWS
                    .removeObject()
                    .subscribe(onNext: { (objectRemoved) in
                        completion()
                        observer.onNext(true)
                    }, onError: { (err) in
                        observer.onError(err)
                        print("err")
                    })
                    .disposed(by: self.disposeBag)
                return Disposables.create()
        }
    }
    
    func clearScenesSelected(completion: @escaping ()->()) -> Observable<Bool>{
        return Observable<Bool>.create { (observer) -> Disposable in
                _ = self.fakeScenesWS
                    .removeScene()
                    .subscribe { (sceneRemoved) in
                        completion()
                        observer.onNext(true)
                    } onError: { (err) in
                        observer.onError(err)
                        print("err")
                    }.disposed(by: self.disposeBag)
                return Disposables.create()
        }
    }
    
    
    func getAllDevices(){
        _ = self.homeService.getAllDevices()
    }
}
