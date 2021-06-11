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
    let sceneService = FakeSceneDataService.shared
    let scenesStream = PublishSubject<[SceneDto]>()
    
    // MARK: Utils
    let localizeUtils = ScreensLabelLocalizableUtils.shared
    let notificationUtils = NotificationsUtils.shared
    let notificationLocalize = NotificationLocalizableUtils.shared
    
    let disposeBag = DisposeBag()
    
    func createNewScene(name: String, description: String, color: String, actions: [ActionSceneDto]) -> Observable<SceneDto>{
        return Observable<SceneDto>.create { observer in
            self.sceneService
            .createNewScene(name: name,description: description, color: color, actions: actions)
            .subscribe { (createdScene) in
                observer.onNext(createdScene)
            } onError: { (err) in
                self.notificationUtils
                    .showFloatingNotificationBanner(
                        title: self.notificationLocalize.loginCredentialsWrongNotificationTitle,
                        subtitle: self.notificationLocalize.loginCredentialsWrongNotificationSubtitle,
                        position: .top, style: .warning)
            }.disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getAllScenes() -> Observable<Bool>{
        _ = self.sceneService.sceneStream.subscribe { scenes in
            self.scenesStream.onNext(scenes)
        } onError: { err in
            self.scenesStream.onError(err)
        }

        return self.sceneService.getAllScenes()
    }
}
