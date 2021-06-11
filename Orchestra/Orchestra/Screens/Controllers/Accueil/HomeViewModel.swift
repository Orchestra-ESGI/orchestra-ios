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
    
    // - MARK: Data
    let disposeBag = DisposeBag()
    let navigationController: UINavigationController?
    
    let homeService: HomeService = HomeService()
    let hubConfigWs = DeviceConfigurationService.shared
    
    let deviceVM: DeviceViewModel?
    let deviceStream = PublishSubject<[HubAccessoryConfigurationDto]>()
    
    let sceneVm: SceneViewModel?
    let sceneStream = PublishSubject<[SceneDto]>()
    
    init(navCtrl: UINavigationController){
        self.navigationController = navCtrl
        self.deviceVM = DeviceViewModel(navigationCtrl: navCtrl)
        self.sceneVm = SceneViewModel()
    }
    
    func loadAllDevicesAndScenes(completion: @escaping (Bool) -> Void){
        _ = Observable.combineLatest(self.loadAllScenes(),
                                     self.loadAllDevices())
        { (obs1, obs2) -> Bool in
            return obs1 && obs2
        }.subscribe { (finished) in
            completion(finished.element!)
        }
    }
    
    private func loadAllDevices() -> Observable<Bool>{
        _ = self.deviceVM!
            .deviceConfig
            .configurationStream
            .subscribe { devices in
                self.deviceStream.onNext(devices)
        } onError: { err in
            self.deviceStream.onError(err)
        }
        return self.deviceVM!.deviceConfig.getCurrentAccessoriesConfig() //---> Fake data
//        _ = self.deviceVM?.devicesStream.subscribe { devices in
//            self.deviceStream.onNext(devices)
//        } onError: { err in
//            self.deviceStream.onError(err)
//        }
        //return self.deviceVM!.getAllDevices() //---> Real data
    }
    
    private func loadAllScenes() -> Observable<Bool>{
        _ = self.sceneVm?.scenesStream.subscribe { scenes in
            self.sceneStream.onNext(scenes)
        } onError: { err in
            self.sceneStream.onError(err)
        }
        return self.sceneVm!.getAllScenes()
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
}
