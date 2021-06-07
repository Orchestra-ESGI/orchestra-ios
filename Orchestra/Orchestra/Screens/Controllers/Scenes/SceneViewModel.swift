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
    let sceneWS = FakeSceneDataService.shared
    
    // MARK: Utils
    let localizeUtils = ScreensLabelLocalizableUtils.shared
    let notificationUtils = NotificationsUtils.shared
    let notificationLocalize = NotificationLocalizableUtils.shared
    
    let disposeBag = DisposeBag()
    
    func createNewScene(name: String, description: String, color: String, actions: [ActionSceneDto]) -> Observable<SceneDto>{
        return Observable<SceneDto>.create { observer in
            self.sceneWS
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
}
