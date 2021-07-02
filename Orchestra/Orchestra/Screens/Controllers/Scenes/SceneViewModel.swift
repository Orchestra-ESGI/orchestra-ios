//
//  SceneViewModel.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 01/05/2021.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class SceneViewModel{
    let sceneService = SceneServices()
    let scenesStream = PublishSubject<[SceneDto]>()
    let sceneValidStream = PublishSubject<Bool>()
    
    // MARK: Utils
    let labelLocalization = ScreensLabelLocalizableUtils.shared
    let notificationUtils = NotificationsUtils.shared
    let notificationLocalize = NotificationLocalizableUtils.shared
    
    let disposeBag = DisposeBag()
    
    init() {
    }
    
    private var scenesActions: [String:[String: String]] = [:]
    
    func fillsceneActions(devices: [HubAccessoryConfigurationDto]){
        self.scenesActions["state"] = [
            "on": self.labelLocalization.deviceActionStateOn,
            "off": self.labelLocalization.deviceActionStateOff,
            "toggle": self.labelLocalization.deviceActionStateToggle
        ]
        
        self.scenesActions["color"] = [
            "color": self.labelLocalization.deviceActionColor
        ]
        
        for device in devices{
            if let brightness = device.actions?.brightness {
                let brightnessMaxVal = brightness.maxVal
                self.scenesActions["brightness"] = [:]
                self.scenesActions["brightness"]?[(brightnessMaxVal).description] = self.labelLocalization.deviceActionBrightness100
                self.scenesActions["brightness"]?[(3 * (brightnessMaxVal/4)).description] = self.labelLocalization.deviceActionBrightness75
                self.scenesActions["brightness"]?[(brightnessMaxVal/2).description] = self.labelLocalization.deviceActionBrightness50
                self.scenesActions["brightness"]?[(brightnessMaxVal/4).description] = self.labelLocalization.deviceActionBrightness25
            }
            if let colorTemp = device.actions?.colorTemp {
                let colorTempMaxVal = colorTemp.maxVal
                self.scenesActions["color_temp"] = [:]
                self.scenesActions["color_temp"]?[(colorTempMaxVal).description] = self.labelLocalization.deviceActionTemp100
                self.scenesActions["color_temp"]?[(3 * (colorTempMaxVal/4)).description] = self.labelLocalization.deviceActionTemp75
                self.scenesActions["color_temp"]?[(colorTempMaxVal/2).description] = self.labelLocalization.deviceActionTemp50
                self.scenesActions["color_temp"]?[(colorTempMaxVal/4).description] = self.labelLocalization.deviceActionTemp25
            }
        }
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
    
    func sendScene(body: [String: Any], httpMethode: CallMethod) -> Observable<Bool>{
        switch httpMethode {
        case .Patch:
            return self.sceneService.updateScene(scene: body)
        case .Post:
            return self.sceneService.createNewScene(scene: body)
        }
    }
    
    func sendAutomation(body: [String: Any], httpMethode: CallMethod) -> Observable<Bool>{
        switch httpMethode {
        case .Patch:
            return self.sceneService.updateAutomation(automation: body)
        case .Post:
            return self.sceneService.createAutomation(automation: body)
        }
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
