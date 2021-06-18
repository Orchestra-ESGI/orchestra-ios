//
//  SceneViewModel.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 01/05/2021.
//

import Foundation
import RxSwift
import RxCocoa

class SceneViewModel{
    let sceneService = SceneServices()
    let scenesStream = PublishSubject<[SceneDto]>()
    
    // MARK: Utils
    let localizeUtils = ScreensLabelLocalizableUtils.shared
    let notificationUtils = NotificationsUtils.shared
    let notificationLocalize = NotificationLocalizableUtils.shared
    
    let disposeBag = DisposeBag()
    
    func removeScenes(id: String) -> Observable<Bool>{
        return self.sceneService.removeScene(idScene: id)
    }
    
    func newScene(body: [String: Any]) -> Observable<Bool>{
        return self.sceneService.createNewScene(scene: body)
    }
    
    func getAllScenes() -> Observable<Bool> {
        _ = self.sceneService.sceneStream.subscribe { scenes in
            self.scenesStream.onNext(scenes)
        } onError: { err in
            self.scenesStream.onError(err)
        }

        return self.sceneService.getAllScenes()
    }
    
    func playScene(id: String){
        self.sceneService.launchScene(id: id)
    }
}
