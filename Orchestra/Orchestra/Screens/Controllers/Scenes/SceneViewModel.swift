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
    
    init() {
        self.fillsceneActions()
    }
    
    private var scenesActions: [String:[String: String]] = [:]
    
    private func fillsceneActions(){
        self.scenesActions["state"] = [
            "on": self.localizeUtils.deviceActionStateOn,
            "off": self.localizeUtils.deviceActionStateOff,
            "toggle": self.localizeUtils.deviceActionStateToggle
        ]
        self.scenesActions["brightness"] = [
            "25": self.localizeUtils.deviceActionBrightness25,
            "50": self.localizeUtils.deviceActionBrightness50,
            "75": self.localizeUtils.deviceActionBrightness75,
            "100": self.localizeUtils.deviceActionBrightness100
        ]
        self.scenesActions["color"] = [
            "color": self.localizeUtils.deviceActionColor
        ]
        self.scenesActions["color_temp"] = [
            "25": self.localizeUtils.deviceActionTemp25,
            "50": self.localizeUtils.deviceActionTemp50,
            "75": self.localizeUtils.deviceActionTemp75,
            "100": self.localizeUtils.deviceActionTemp100
        ]
    }
    
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
