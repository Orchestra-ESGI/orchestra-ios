//
//  ScenesListObserversExtension.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/04/2021.
//

import Foundation
import RxSwift
import RxCocoa

extension ScenesListViewController{
    
    func setObjectStreamObserver(){
        // Listen to object stream and show them in TV
        self.objectVM.fakeObjectsWS
            .objectStream
            .subscribe { (objects) in
                self.homeObjects = objects
                self.homeObjects.sort { (object1, object2) in
                    return object1.isFav! && !object2.isFav!
                }
        } onError: { (err) in
            self.notificationUtils
                .showFloatingNotificationBanner(title: self.notificationLocalize.loginCredentialsWrongNotificationTitle, subtitle: self.notificationLocalize.loginCredentialsWrongNotificationSubtitle, position: .top, style: .warning)
        }.disposed(by: self.disposeBag)
    }
    
    func setScenesStreamObserver(){
        // Listen to scene stream and show them in TV
        self.objectVM.fakeScenesWS
            .sceneStream
            .subscribe { (scenes) in
                self.homeScenes = scenes
        } onError: { (err) in
            self.notificationUtils
                .showFloatingNotificationBanner(title: self.notificationLocalize.loginCredentialsWrongNotificationTitle, subtitle: self.notificationLocalize.loginCredentialsWrongNotificationSubtitle, position: .top, style: .warning)
        }.disposed(by: self.disposeBag)
    }
    
    func setEditModeObserver(){
        // Listen to stream to know if cells are in edit mode
        self.isSchakingStream.subscribe { (isShaking) in
            if(isShaking.element!){
                self.cancelButton?.isEnabled = true
                self.cancelButton?.tintColor = #colorLiteral(red: 2.387956192e-05, green: 0.5332912803, blue: 0.8063663244, alpha: 1)
                self.trashButton?.isEnabled = true
                self.trashButton?.tintColor = #colorLiteral(red: 2.387956192e-05, green: 0.5332912803, blue: 0.8063663244, alpha: 1)
            }else{
                self.cancelButton?.isEnabled = false
                self.cancelButton?.tintColor = .clear
                self.trashButton?.isEnabled = false
                self.trashButton?.tintColor = .clear
            }
        }.disposed(by: self.disposeBag)
    }
    
    func editingTableViewObserver(){
        // Listen to stream to know if cells are selected to be removed
        self.elementsToRemoveStream
            .subscribe { (elementsExists) in
                if(elementsExists.element!){
                    self.trashButton?.isEnabled = true
                    self.trashButton?.tintColor = #colorLiteral(red: 2.387956192e-05, green: 0.5332912803, blue: 0.8063663244, alpha: 1)
                }else{
                    self.trashButton?.isEnabled = false
                    self.trashButton?.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                }
        }.disposed(by: self.disposeBag)
    }
}
