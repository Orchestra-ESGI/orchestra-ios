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
    func setAddSceneOrDeviceButtonBinding(){
        self.addSceneAppbarButon?.rx
            .tap
            .bind { [weak self] in
                if((self!.isCellsShaking)){
                    self?.stopCellsShake()
                    self?.isCellsShaking = !self!.isCellsShaking
                }
                
                let addSceneLabelText = self?.screenLabelLocalize.homePlusButtonAlertNewScene
                let addScene = PopMenuDefaultAction(title: addSceneLabelText, image: UIImage(systemName: "timer"), didSelect: { action in
                    let sceneVc = SceneViewController()
                    sceneVc.devices = self!.hubDevices
                    sceneVc.dataDelegate = self
                    self?.navigationController?.pushViewController(sceneVc, animated: true)
                })
                
                let addDeviceLabelText = self?.screenLabelLocalize.homePlusButtonAlertNewDevice
                let addDevice = PopMenuDefaultAction(title: addDeviceLabelText,image: UIImage(systemName: "lightbulb.fill"), didSelect: { action in
                    let newDeviceVc = NewDevicePairingViewController()
                    self?.navigationController?.pushViewController(newDeviceVc, animated: true)
                })
                
                let addHouseLabelText = self?.screenLabelLocalize.homePlusButtonAlertNewHouse
                let addHouse = PopMenuDefaultAction(title: addHouseLabelText,image: UIImage(systemName: "house.fill"), didSelect: { action in
                    self!.showHousesnBottomSheet()
                })
                
                let menuViewController = PopMenuViewController(actions: [addScene, addDevice, addHouse])
                menuViewController.appearance.popMenuBackgroundStyle = .blurred(.regular)
                self!.present(menuViewController, animated: true, completion: nil)
        }.disposed(by: self.disposeBag)
    }
    
    func setUserSettingButtonBinding(){
        self.userSettingsAppbarButton?.rx
            .tap
            .bind { [weak self] in
                if((self!.isCellsShaking)){
                    self?.stopCellsShake()
                    self?.isCellsShaking = !self!.isCellsShaking
                }
                self?.navigationController?.pushViewController(AppSettingsViewController(), animated: true)
        }.disposed(by: self.disposeBag)
        
        _ = cancelButton?.rx.tap.bind{
            self.stopCellsShake()
            self.isCellsShaking = !self.isCellsShaking
        }
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
    
    func refreshButtonBinging(){
        _ = refreshHome?
            .rx
            .tap.bind{
                self.loadData()
        }
    }
}
