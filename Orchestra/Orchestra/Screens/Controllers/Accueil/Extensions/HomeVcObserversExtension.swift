//
//  ScenesListObserversExtension.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/04/2021.
//

import Foundation
import RxSwift
import RxCocoa

extension HomeViewController{
    
    func observeAllDevices(){
        _ = self.homeVM!
            .deviceStream
            .subscribe { devices in
                self.hubDevices = devices
                self.filtereHubDevices = devices
                self.rooms = ["Toutes" ,"Salon", "Bureau", "Chambre", "Cuisine", "Salle de bain", "Ceci est une pièce avec un nom trop long"]
                self.roomsCollectionView.reloadData()
            } onError: { err in
                self.progressUtils.dismiss()
                self.notificationUtils.showFloatingNotificationBanner(title: "Erreur", subtitle: "Un problème est survenu lors du chargement de votre domicile", position: .top, style: .danger)
                print("error while fetching data")
            } onCompleted: {
                print("onCompleted() called in observeAllDevices()")
                self.progressUtils.dismiss()
                let alertMessage = self.labelLocalization.localNetworkAuthAlertMessage
                self.alertUtils.goToParamsAlert(message: alertMessage, for: self)
            }
    }
    
    func setScenesStreamObserver(){
        // Listen to scene stream and show them in TV
        _ = self.homeVM!
            .sceneStream
            .subscribe { (scenes) in
                self.homeScenes = scenes
                self.filteredHomeScenes = scenes
        } onError: { (err) in
            self.notificationUtils
                .showFloatingNotificationBanner(title: self.notificationLocalize.loginCredentialsWrongNotificationTitle, subtitle: self.notificationLocalize.loginCredentialsWrongNotificationSubtitle, position: .top, style: .warning)
            self.progressUtils.dismiss()
        } onCompleted: {
            print("onCompleted() called in setScenesStreamObserver()")
            self.progressUtils.dismiss()
            let alertMessage = self.labelLocalization.localNetworkAuthAlertMessage
            self.alertUtils.goToParamsAlert(message: alertMessage, for: self)
        }
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
