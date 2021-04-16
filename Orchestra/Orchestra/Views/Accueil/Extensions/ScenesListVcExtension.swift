//
//  ScenesListVcExtension.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 15/04/2021.
//

import Foundation
import UIKit

// - MARK: Collection view setup
extension ScenesListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if(indexPath.section == 0){
            let totalHeight: CGFloat = (self.view.frame.width / 3) - 20
            let totalWidth: CGFloat = (self.view.frame.width / 3) - 20

            return CGSize(width: totalWidth, height: totalHeight)
        }else{
            let totalWidth: CGFloat = (self.view.frame.width / 2) - 20
            return CGSize(width: totalWidth, height: 60.0)
        }
    }
}

extension ScenesListViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var sections = 2
//        if(self.homeObjects.count == 0){
//            sections -= 1
//        }
//        if(self.homeScenes.count == 0){
//            sections -= 1
//        }
        
        return sections
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.homeObjects.count
        }else {
            return self.homeScenes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.section == 0){
            let objectCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OBJECT", for: indexPath) as! ObjectCollectionViewCell
            
            objectCell.objectImageView.image = UIImage(systemName: "homepod.fill")
            let currentObject = self.homeObjects[indexPath.row]
            let reachableStatus = (currentObject.isReachable ?? false) ?
                                    self.screenLabelLocalize.objectCellReachabilityStatusOkLabelText :
                                    self.screenLabelLocalize.objectCellReachabilityStatusKoLabelText
            if self.traitCollection.userInterfaceStyle == .dark {
                objectCell.objectImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }else{
                objectCell.objectImageView.tintColor = .black
            }
            let currentCellPos = indexPath.row
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed))
            longPressRecognizer.minimumPressDuration = 0.5
            longPressRecognizer.delaysTouchesBegan = true
            objectCell.addGestureRecognizer(longPressRecognizer)
            
            objectCell.objectPlaceNameLabel.text = self.homeObjects[currentCellPos].name
            objectCell.objectNameLabel.text = self.homeObjects[currentCellPos].roomName
            objectCell.objectStatusLabel.text = reachableStatus
            objectCell.favIcon.image = self.homeObjects[currentCellPos].isFav! ? UIImage(systemName: "heart.fill") : UIImage(systemName: "")
            objectCell.favIcon.tintColor = #colorLiteral(red: 0.8078431487, green: 0.03080267302, blue: 0.112645736, alpha: 1)
            objectCell.cellContentView.backgroundColor = self.generatesBackGroundColor()

            objectCell.contentView.layer.cornerRadius = 8.0
            objectCell.contentView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            objectCell.contentView.layer.borderWidth = 0.2
            objectCell.contentView.layer.masksToBounds = true;
            
            if(self.isCellsShaking){
                addWiggleAnimationToCell(cell: objectCell)
            }
            
            return objectCell
        }else{
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
            
            sceneCell.sceneDescription .text = self.homeScenes[currentCellPos].title
            sceneCell.cellContentView.backgroundColor = self.generatesBackGroundColor()
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
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SECTION_HEADER", for: indexPath) as! HeaderCollectionViewCell
        
        if(indexPath.section == 0){
            headerCell.headerTextLabel.text = self.screenLabelLocalize.homeHeaderObjectsText
        }else{
            headerCell.headerTextLabel.text = self.screenLabelLocalize.homeHeaderScenesText
        }
        
        return headerCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(self.isCellsShaking){
            let cellBorderColor: CGColor?
            let cellBorderWidth: CGFloat?
            if(indexPath.section == 0){
                // Object cell selected
                let objectCellSelected = collectionView.cellForItem(at: indexPath) as! ObjectCollectionViewCell
                let objectDtoSelected = self.homeObjects[indexPath.row]
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
            }else{
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
        }else{
            if(indexPath.section == 0){
                self.showInfoDetailAboutObject(for: indexPath)
            }else{
                self.startSceneActions(for: indexPath)
            }
        }
    }
}

extension ScenesListViewController: UICollectionViewDelegate{
    
}

