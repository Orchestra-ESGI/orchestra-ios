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
//        self.loadAllScenes()
//        self.loadAllDevices()
        _ = Observable.combineLatest(self.loadAllScenes(),
                                     self.loadAllDevices())
        { (obs1, obs2) -> Bool in
            return obs1 && obs2
        }.subscribe { (finished) in
            if(finished.element != nil){
                completion(finished.element!)
            }else{
                completion(true)
            }
        }
    }
    
    private func loadAllDevices() -> Observable<Bool>{
        _ = self.deviceVM!.devicesStream.subscribe { devices in
            self.deviceStream.onNext(devices)
        } onError: { err in
            self.deviceStream.onError(err)
        }
        return self.deviceVM!.getAllDevices() //---> Real data
    }
    
    private func loadAllScenes() -> Observable<Bool>{
        _ = self.sceneVm!.scenesStream.subscribe { scenes in
            self.sceneStream.onNext(scenes)
        } onError: { err in
            self.sceneStream.onError(err)
        }
        return self.sceneVm!.getAllScenes()
    }
    
    func removeDevices(friendlyName: String) -> Observable<Bool>{
        return self.deviceVM!.removeDevices(friendlyName: friendlyName)
    }
    
    func removeScenes(id: String) -> Observable<Bool> {
        return self.sceneVm!.removeScenes(id: id)
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
