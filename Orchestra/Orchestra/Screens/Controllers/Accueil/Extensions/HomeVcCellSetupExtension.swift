//
//  HomeVcCellSetupExtension.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 01/06/2021.
//

import Foundation
import UIKit

extension HomeViewController{
     func fillHubDeviceCell(_ indexPath: IndexPath,
                                     _ collectionView: UICollectionView) -> ObjectCollectionViewCell{
        let objectCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OBJECT", for: indexPath) as! ObjectCollectionViewCell
        
        let currentObject =  self.hubDevices[indexPath.row]
        
        switch currentObject.type {
        case.Switch:
            objectCell.objectImageView.image = UIImage(systemName: "switch.2")
        case .LightBulb:
            objectCell.objectImageView.image = UIImage(systemName: "lightbulb.fill")
        case .StatelessProgrammableSwitch:
            objectCell.objectImageView.image = UIImage(systemName: "switch.2")
        case .Sensor:
            objectCell.objectImageView.image = UIImage(systemName: "figure.walk")
        default:
            objectCell.objectImageView.image = UIImage(systemName: "questionmark")
        }
        
        let reachableStatus = (currentObject.isReachable ?? false) ?
                                self.screenLabelLocalize.objectCellReachabilityStatusOkLabelText :
                                self.screenLabelLocalize.objectCellReachabilityStatusKoLabelText
        if self.traitCollection.userInterfaceStyle == .dark {
            objectCell.objectImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else{
            objectCell.objectImageView.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        let currentCellPos = indexPath.row
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed))
        longPressRecognizer.minimumPressDuration = 0.5
        longPressRecognizer.delaysTouchesBegan = true
        objectCell.addGestureRecognizer(longPressRecognizer)
        
        objectCell.objectPlaceNameLabel.text = self.hubDevices[currentCellPos].name
        objectCell.objectNameLabel.text = self.hubDevices[currentCellPos].roomName
        objectCell.objectStatusLabel.text = reachableStatus
        
        objectCell.cellContentView.backgroundColor = self.colorUtils.hexStringToUIColor(hex: currentObject.backgroundColor!) //self.generatesBackGroundColor()
        objectCell.contentView.layer.cornerRadius = 8.0
        objectCell.contentView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        objectCell.contentView.layer.borderWidth = 0.2
        objectCell.contentView.layer.masksToBounds = true;
        
        if(self.isCellsShaking){
            addWiggleAnimationToCell(cell: objectCell)
        }
        
        return objectCell
    }
    
    
    func setUpSceneCell(_ indexPath: IndexPath,
                                    _ collectionView: UICollectionView) -> SceneCollectionViewCell {
        let sceneCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SCENE", for: indexPath) as! SceneCollectionViewCell
        
        sceneCell.sceneImageView.image = UIImage(systemName: "timer")
        if self.traitCollection.userInterfaceStyle == .dark {
            sceneCell.sceneImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else{
            sceneCell.sceneImageView.tintColor = .black
        }
        let currentCellPos = indexPath.row
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed))
        longPressRecognizer.minimumPressDuration = 0.5
        longPressRecognizer.delaysTouchesBegan = true
        sceneCell.addGestureRecognizer(longPressRecognizer)
        
        sceneCell.sceneDescription .text = self.homeScenes[currentCellPos].name
        let cellColor = self.homeScenes[currentCellPos].color
        sceneCell.cellContentView.backgroundColor = self.colorUtils.hexStringToUIColor(hex: cellColor!)
        sceneCell.contentView.layer.cornerRadius = 8.0
        sceneCell.contentView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        sceneCell.contentView.layer.borderWidth = 0.2
        sceneCell.contentView.layer.masksToBounds = true;
    
        sceneCell.sceneDetailButton.tag = indexPath.row
        sceneCell.sceneDetailButton.addTarget(self, action: #selector(showSceneDetail), for: .touchUpInside)
        
        if(self.isCellsShaking){
            addWiggleAnimationToCell(cell: sceneCell)
        }
        
        return sceneCell
    }
    
    
    func setUpSceneCellSelected(_ collectionView: UICollectionView, _ indexPath: IndexPath){
        let cellBorderColor: CGColor?
        let cellBorderWidth: CGFloat?
        
        // Scene cell selected
        let sceneCellSelected = collectionView.cellForItem(at: indexPath) as! SceneCollectionViewCell
        let sceneCellDtoSelected = self.homeScenes[indexPath.row]
        if(self.scenesToRemove.contains(sceneCellDtoSelected)){
            // Unselect cell
            let index = self.scenesToRemove.firstIndex(of: sceneCellDtoSelected)!
            self.scenesToRemove.remove(at: index)
            if(self.objectsToRemove.count == 0 && self.scenesToRemove.count == 0){
                self.elementsToRemoveStream.onNext(false)
            }
            cellBorderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cellBorderWidth = 2.0
        }else{
            // Select cell
            if(self.objectsToRemove.count == 0 || self.scenesToRemove.count == 0){
                self.elementsToRemoveStream.onNext(true)
            }
            self.scenesToRemove.append(sceneCellDtoSelected)
            cellBorderColor = #colorLiteral(red: 1, green: 0.01224201724, blue: 0, alpha: 1)
            cellBorderWidth = 4.0
        }
        sceneCellSelected.contentView.layer.borderColor = cellBorderColor!
        sceneCellSelected.contentView.layer.borderWidth = cellBorderWidth!
        
    }
    
    
    func setUpDeviceCellSelected(_ collectionView: UICollectionView, _ indexPath: IndexPath){
        let cellBorderColor: CGColor?
        let cellBorderWidth: CGFloat?
        // Object cell selected
        let objectCellSelected = collectionView.cellForItem(at: indexPath) as! ObjectCollectionViewCell
        let objectDtoSelected = self.hubDevices[indexPath.row]
        if(self.objectsToRemove.contains(objectDtoSelected)){
            // Unselect cell
            let index = self.objectsToRemove.firstIndex(of: objectDtoSelected)!
            self.objectsToRemove.remove(at: index)
            if(self.objectsToRemove.count == 0 && self.scenesToRemove.count == 0){
                self.elementsToRemoveStream.onNext(false)
            }
            cellBorderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cellBorderWidth = 2.0
        }else{
            // Select cell
            if(self.objectsToRemove.count == 0 || self.scenesToRemove.count == 0){
                self.elementsToRemoveStream.onNext(true)
            }
            self.objectsToRemove.append(objectDtoSelected)
            cellBorderColor = #colorLiteral(red: 1, green: 0.01224201724, blue: 0, alpha: 1)
            cellBorderWidth = 4.0
        }
        objectCellSelected.contentView.layer.borderColor = cellBorderColor!
        objectCellSelected.contentView.layer.borderWidth = cellBorderWidth!
        
    }
}
