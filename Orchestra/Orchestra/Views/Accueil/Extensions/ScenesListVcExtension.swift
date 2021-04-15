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
            
            objectCell.objectPlaceNameLabel.text = self.homeObjects[currentCellPos].name
            objectCell.objectNameLabel.text = self.homeObjects[currentCellPos].roomName
            objectCell.objectStatusLabel.text = reachableStatus
            objectCell.favIcon.image = self.homeObjects[currentCellPos].isFav! ? UIImage(systemName: "heart.fill") : UIImage(systemName: "")
            objectCell.favIcon.tintColor = #colorLiteral(red: 0.8078431487, green: 0.03080267302, blue: 0.112645736, alpha: 1)
            objectCell.cellContentView.backgroundColor = self.generatesBackGroundColor()

            objectCell.contentView.layer.cornerRadius = 8.0
            objectCell.contentView.layer.borderWidth = 0.2
            objectCell.contentView.layer.masksToBounds = true;
            
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
            
            sceneCell.sceneDescription .text = self.homeScenes[currentCellPos].title
            sceneCell.cellContentView.backgroundColor = self.generatesBackGroundColor()
            sceneCell.contentView.layer.cornerRadius = 8.0
            sceneCell.contentView.layer.borderWidth = 0.2
            sceneCell.contentView.layer.masksToBounds = true;
            
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
        if(indexPath.section == 0){
            self.showInfoDetailAboutObject(for: indexPath)
        }else{
            self.startSceneActions(for: indexPath)
        }
    }
}

extension ScenesListViewController: UICollectionViewDelegate{
    
}

