//
//  ScenesListUiBindingExtension.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/04/2021.
//

import Foundation
import RxSwift
import RxCocoa
import PopMenu

extension HomeViewController{
    func setAddButtonBinding(){
        self.addSceneAppbarButon?.rx
            .tap
            .bind { [weak self] in
                if((self!.isCellsShaking)){
                    self?.stopCellsShake()
                    self?.isCellsShaking = !self!.isCellsShaking
                }
                
                let addSceneLabel = self?.labelLocalization.homePlusButtonAlertNewScene
                let addScene = PopMenuDefaultAction(title: addSceneLabel, image: UIImage(systemName: "timer"), didSelect: { action in
                    let sceneVc = SceneViewController()
                    sceneVc.devices = self!.hubDevices
                    sceneVc.dataDelegate = self
                    self?.navigationController?.pushViewController(sceneVc, animated: true)
                })
                
                let addDeviceLabel = self?.labelLocalization.homePlusButtonAlertNewDevice
                let addDevice = PopMenuDefaultAction(title: addDeviceLabel,image: UIImage(systemName: "lightbulb.fill"), didSelect: { action in
                    let newDeviceVc = NewDevicePairingViewController()
                    self?.navigationController?.pushViewController(newDeviceVc, animated: true)
                })
                
                let addRoomLabel = self?.labelLocalization.homePlusButtonAlertNewRoom
                let addHouse = PopMenuDefaultAction(title: addRoomLabel,image: UIImage(systemName: "house.fill"), didSelect: { action in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        let alertTitle = self!.notificationLocalize.roomCreationAlertTitle
                        let alertMessage = self!.notificationLocalize.roomCreationAlertMessage
                        let alertAction = self!.notificationLocalize.roomCreationAlertTitle
                        self?.alertUtils.showAlertWithTf(for: self!,
                                                         title: alertTitle,
                                                         message: alertMessage,
                                                         actionName: alertAction,
                                                         completion: self!.addNewRoom(roomName:))
                    })
                })
                
                
                let menuViewController = PopMenuViewController(actions: [addScene, addDevice, addHouse])
                menuViewController.appearance.popMenuBackgroundStyle = .blurred(.regular)
                self!.present(menuViewController, animated: true, completion: nil)
        }.disposed(by: self.disposeBag)
    }
    
    func setTrashButtonBinding(){
        _ = trashButton?
            .rx
            .tap.bind{
            let alertTitle = self.notificationLocalize.removeDataAlertTitle
            let alertSubtitle = self.notificationLocalize.removeDataAlertSubtitle
            let alertCancelAction = self.notificationLocalize.removeDataAlertCancelButtonText
            let alertRemoveAction = self.notificationLocalize.removeDataAlertDeleteButtonText
            
            let alert = UIAlertController(title: alertTitle, message: alertSubtitle, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: alertRemoveAction, style: .destructive, handler: { _ in
                self.clearCellsSelection()
            }))
            alert.addAction(UIAlertAction(title: alertCancelAction, style: .cancel, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func menuButtonBinding(){
        _ = menuButton?
            .rx
            .tap.bind{
                self.goToMenu()
        }
    }
}
