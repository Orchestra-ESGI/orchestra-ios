//
//  ScenesListUiBindingExtension.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/04/2021.
//

import Foundation
import RxSwift
import RxCocoa

extension ScenesListViewController{
    func setAddSceneButtonBinding(){
        self.addSceneAppbarButon?.rx
            .tap
            .bind { [weak self] in
                if((self!.isCellsShaking)){
                    self?.stopCellsShake()
                    self?.isCellsShaking = !self!.isCellsShaking
                }
                let sceneVc = SceneViewController()
                sceneVc.dataDelegate = self
                self?.navigationController?.pushViewController(sceneVc, animated: true)
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
}
