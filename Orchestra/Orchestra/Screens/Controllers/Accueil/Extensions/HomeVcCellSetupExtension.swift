//
//  HomeVcCellSetupExtension.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 01/06/2021.
//

import Foundation
import UIKit
import FontAwesome_swift

extension HomeViewController{
     func fillHubDeviceCell(_ indexPath: IndexPath,
                                     _ collectionView: UICollectionView) -> ObjectCollectionViewCell{
        let objectCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OBJECT", for: indexPath) as! ObjectCollectionViewCell
        
        let currentObject =  self.filtereHubDevices[indexPath.row]
        
        switch currentObject.type {
        case.Switch:
            objectCell.objectImageView.image = UIImage(systemName: "switch.2")
            break
        case .LightBulb:
            objectCell.objectImageView.image = UIImage(systemName: "lightbulb.fill")
            break
        case .StatelessProgrammableSwitch:
            objectCell.objectImageView.image = UIImage(named: "press_button")!
            break
        case .Occupancy:
            objectCell.objectImageView.image = UIImage(systemName: "figure.walk")
            break
        case .TemperatureAndHumidity:
            objectCell.objectImageView.image = UIImage(systemName: "thermometer")
            break
        case .Contact:
            objectCell.objectImageView.image = UIImage.fontAwesomeIcon(name: .doorOpen, style: .solid,
                                                                       textColor: .white, size: CGSize(width: 15, height: 15))
            break
        default:
            objectCell.objectImageView.image = UIImage(systemName: "questionmark")
            break
        }
        
        let reachableStatus = (currentObject.isReachable ?? false) ?
                                self.labelLocalization.objectCellReachabilityStatusOkLabelText :
                                self.labelLocalization.objectCellReachabilityStatusKoLabelText
        objectCell.objectImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let currentCellPos = indexPath.row
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed))
        longPressRecognizer.minimumPressDuration = 0.5
        longPressRecognizer.delaysTouchesBegan = true
        objectCell.addGestureRecognizer(longPressRecognizer)
        
        objectCell.objectPlaceNameLabel.font = Font.Bold(14)
        objectCell.objectPlaceNameLabel.textColor = .white
        
        objectCell.objectNameLabel.font = Font.Regular(14)
        objectCell.objectNameLabel.textColor = .white
        
        objectCell.objectStatusLabel.font = Font.Regular(12)
        objectCell.objectStatusLabel.textColor = .white
        
        objectCell.objectPlaceNameLabel.text = self.filtereHubDevices[currentCellPos].name
        let roomNameLocalize = NSLocalizedString(self.filtereHubDevices[currentCellPos].room?.name ?? "", comment: "")
        objectCell.objectNameLabel.text = roomNameLocalize
        objectCell.objectStatusLabel.text = reachableStatus
        
        objectCell.cellContentView.backgroundColor = self.colorUtils.hexStringToUIColor(hex: currentObject.backgroundColor!)
        objectCell.contentView.layer.cornerRadius = 8.0
        objectCell.contentView.layer.borderColor = UIColor.clear.cgColor
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
        if(indexPath.section == 1){
            sceneCell.sceneImageView.image = UIImage(systemName: "arrowtriangle.right.circle.fill")
        }else{
            sceneCell.sceneImageView.image = UIImage(systemName: "timer")
        }
        
        sceneCell.sceneImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let currentCellPos = indexPath.row
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed))
        longPressRecognizer.minimumPressDuration = 0.5
        longPressRecognizer.delaysTouchesBegan = true
        sceneCell.addGestureRecognizer(longPressRecognizer)
        var cellColor: String = ""
        sceneCell.sceneDescription.font = Font.Regular(14)
        sceneCell.sceneDescription.textColor = .white
        if(indexPath.section == 1){
            sceneCell.sceneDescription.text = self.filteredHomeScenes[currentCellPos].name
            cellColor = self.filteredHomeScenes[currentCellPos].color ?? ""
        }else{
            sceneCell.sceneDescription.text = self.filteredAutomations[currentCellPos].name
            cellColor = self.filteredAutomations[currentCellPos].color ?? ""
        }
        sceneCell.cellContentView.backgroundColor = self.colorUtils.hexStringToUIColor(hex: cellColor)
        sceneCell.contentView.layer.cornerRadius = 8.0
        sceneCell.contentView.layer.borderColor = UIColor.clear.cgColor
        sceneCell.contentView.layer.borderWidth = 0.2
        sceneCell.contentView.layer.masksToBounds = true;
    
        sceneCell.sceneDetailButton.tag = indexPath.row
        if indexPath.section == 1{
            sceneCell.sceneDetailButton.accessibilityLabel = "scene"
        }else{
            sceneCell.sceneDetailButton.accessibilityLabel = "automation"
        }
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
        let sceneCellDtoSelected = self.filteredHomeScenes[indexPath.row]
        if(self.scenesToRemove.contains(sceneCellDtoSelected)){
            // Unselect cell
            if(indexPath.section == 1){
                let index = self.scenesToRemove.firstIndex(of: sceneCellDtoSelected)!
                self.scenesToRemove.remove(at: index)
                if(self.objectsToRemove.count == 0 && self.scenesToRemove.count == 0){
                    self.elementsToRemoveStream.onNext(false)
                }
            }
            cellBorderColor = UIColor.clear.cgColor
            cellBorderWidth = 2.0
        }else{
            // Select cell
            if(indexPath.section == 1){
                if(self.objectsToRemove.count == 0 || self.scenesToRemove.count == 0){
                    self.elementsToRemoveStream.onNext(true)
                }
                self.scenesToRemove.append(sceneCellDtoSelected)
            }
            cellBorderColor = ColorUtils.ORCHESTRA_RED_COLOR.cgColor
            cellBorderWidth = 4.0
        }
        sceneCellSelected.contentView.layer.borderColor = cellBorderColor!
        sceneCellSelected.contentView.layer.borderWidth = cellBorderWidth!
        
    }
    
    func setUpSelectedAutomation(_ collectionView: UICollectionView, _ indexPath: IndexPath){
        let cellBorderColor: CGColor?
        let cellBorderWidth: CGFloat?
        
        // Scene cell selected
        let sceneCellSelected = collectionView.cellForItem(at: indexPath) as! SceneCollectionViewCell

        let automationCellDtoSelected = self.filteredAutomations[indexPath.row]
        if(self.automationToRemove.contains(automationCellDtoSelected)){
            // Unselect cell
            let index = self.automationToRemove.firstIndex(of: automationCellDtoSelected)!
            self.automationToRemove.remove(at: index)
            if(self.objectsToRemove.count == 0 &&
                self.scenesToRemove.count == 0 &&
                self.automationToRemove.count == 0){
                self.elementsToRemoveStream.onNext(false)
            }
            cellBorderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cellBorderWidth = 2.0
        }else{
            // Select cell
            if(self.objectsToRemove.count == 0 ||
                self.scenesToRemove.count == 0 ||
                self.automationToRemove.count == 0){
                self.elementsToRemoveStream.onNext(true)
            }
            self.automationToRemove.append(automationCellDtoSelected)
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
            cellBorderColor = UIColor.clear.cgColor
            cellBorderWidth = 2.0
        }else{
            // Select cell
            if(self.objectsToRemove.count == 0 || self.scenesToRemove.count == 0){
                self.elementsToRemoveStream.onNext(true)
            }
            self.objectsToRemove.append(objectDtoSelected)
            cellBorderColor = ColorUtils.ORCHESTRA_RED_COLOR.cgColor
            cellBorderWidth = 4.0
        }
        objectCellSelected.contentView.layer.borderColor = cellBorderColor!
        objectCellSelected.contentView.layer.borderWidth = cellBorderWidth!
        
    }
}
