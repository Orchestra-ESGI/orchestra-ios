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

    // - MARK: Data
    let disposeBag = DisposeBag()
    let navigationController: UINavigationController?
    
    let homeService: HomeService = HomeService()
    
    let deviceVM: DeviceViewModel?
    let deviceStream = PublishSubject<[DeviceDto]>()
    
    let sceneVm: SceneViewModel?
    let sceneStream = PublishSubject<[SceneDto]>()
    let automationStream = PublishSubject<[AutomationDto]>()
    
    let roomVm = RoomServices()
    
    init(navCtrl: UINavigationController){
        self.navigationController = navCtrl
        self.deviceVM = DeviceViewModel(navigationCtrl: navCtrl)
        self.sceneVm = SceneViewModel()
    }
    
    func loadHomData(completion: @escaping (Bool) -> Void){
        _ = Observable.combineLatest(self.loadAllScenes(),
                                     self.loadAllDevices(),
                                     self.loadAllAutomations())
        { (obs1, obs2, obs3) -> Bool in
            return obs1 && obs2 && obs3
        }.subscribe { (finished) in
            if(finished.element != nil){
                completion(finished.element!)
            }else{
                completion(false)
            }
        }
    }
    
    func getAllRooms() -> Observable<[RoomDto]> {
        return homeService.getAllRooms()
    }
    
    private func loadAllDevices() -> Observable<Bool>{
        _ = self.deviceVM!.devicesStream.subscribe { devices in
            self.deviceStream.onNext(devices)
        } onError: { err in
            self.deviceStream.onError(err)
        } onCompleted: {
            self.deviceStream.onCompleted()
        }.disposed(by: self.disposeBag)
        
        return self.deviceVM!.getAllDevices() //---> Real data
    }
    
    private func loadAllScenes() -> Observable<Bool>{
        _ = self.sceneVm!.scenesStream.subscribe { scenes in
            self.sceneStream.onNext(scenes)
        } onError: { err in
            self.sceneStream.onError(err)
        } onCompleted: {
            self.sceneStream.onCompleted()
        }.disposed(by: self.disposeBag)
        
        return self.sceneVm!.getAllScenes()
    }
    
    private func loadAllAutomations() -> Observable<Bool>{
        _ = self.sceneVm!.automationStream.subscribe { scenes in
            self.automationStream.onNext(scenes)
        } onError: { err in
            self.automationStream.onError(err)
        } onCompleted: {
            self.automationStream.onCompleted()
        }.disposed(by: self.disposeBag)
        
        return self.sceneVm!.getAllAutomations()
    }
    
    func sendActionOnDevice(action: [String: Any]){
        self.deviceVM?.sendDeviceAction(body: action)
    }
    
    func removeDevices(friendlyNames: [String]) -> Observable<Bool>{
        return self.deviceVM!.removeDevices(friendlyNames: friendlyNames)
    }
    
    func removeScenes(ids: [String]) -> Observable<Bool> {
        return self.sceneVm!.removeScenes(ids: ids)
    }
    
    func removeAutomations(ids: [String]) -> Observable<Bool> {
        return self.sceneVm!.removeAutomations(ids: ids)
    }
    
    func creatRoom(body: [String: Any]) -> Observable<Bool> {
        return self.roomVm.create(body: body)
    }
    
    func clearObjectSelected(completion: @escaping (AnyObserver<Bool>)->()) -> Observable<Bool>{
        return Observable<Bool>.create { (observer) -> Disposable in
                completion(observer)
            return Disposables.create()
        }
    }
    
    func clearScenesSelected(completion: @escaping (AnyObserver<Bool>)->()) -> Observable<Bool>{
        return Observable<Bool>.create { (observer) -> Disposable in
                completion(observer)
            return Disposables.create()
        }
    }
    
    func handleUnauthorizedEvent(authErr: ServerError){
        self.homeService.rootApiService.handleUnauthEvent(err: authErr)
    }
    
}
