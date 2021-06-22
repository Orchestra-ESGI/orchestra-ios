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
    
    private let scenesActions: [String:[String: String]] = [
        "state": [
            "on": "Allumer l'appareil",
            "off": "Éteindre l'appareil",
            "toggle": "Basculer l'appareil"
        ],
        "brightness": [
            "25": "Mettre la luminosité de l'appareil à 25%",
            "50": "Mettre la luminosité de l'appareil à 50%",
            "75": "Mettre la luminosité de l'appareil à 75%",
            "100": "Mettre la luminosité de l'appareil à 100%"
        ],
        "color": [
            "color": "Changer la couleur de l'appareil"
        ],
        "color_temp": [
            "25": "Mettre la température de l'appareil à 25%",
            "50": "Mettre la température de l'appareil à 50%",
            "75": "Mettre la température de l'appareil à 75%",
            "100": "Mettre la température de l'appareil à 100%"
        ]
    ]
    
    func getSceneActionName(key: String, value: String) -> String? {
        if let actionType = scenesActions[key] {
            if let actionName = actionType[value] {
                return actionName
            }
        }
        return nil
    }
    
    func removeScenes(ids: [String]) -> Observable<Bool>{
        return self.sceneService.removeScene(idsScene: ids)
    }
    
    func newScene(body: [String: Any]) -> Observable<Bool>{
        return self.sceneService.createNewScene(scene: body)
    }
    
    func getAllScenes() -> Observable<Bool> {
        _ = self.sceneService.sceneStream.subscribe { scenes in
            self.scenesStream.onNext(scenes)
        } onError: { err in
            self.scenesStream.onError(err)
        } onCompleted: {
            self.scenesStream.onCompleted()
        }

        return self.sceneService.getAllScenes()
    }
    
    func playScene(id: String){
        self.sceneService.launchScene(id: id)
    }
}
