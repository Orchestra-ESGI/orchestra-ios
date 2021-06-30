//
//  ScenesListVcExtension.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 15/04/2021.
//

import Foundation
import UIKit

// - MARK: Collection view setup
extension HomeViewController: UICollectionViewDelegateFlowLayout {
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

extension HomeViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.hubDevices.count
        }else {
            return self.homeScenes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.section == 0){
            // Hub device
            return  self.fillHubDeviceCell(indexPath, collectionView)
        }else{
            return self.setUpSceneCell(indexPath, collectionView)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SECTION_HEADER", for: indexPath) as! HeaderCollectionViewCell

        if(indexPath.section == 0){
            headerCell.headerTextLabel.text = self.labelLocalization.homeHeaderObjectsText
        }else if(indexPath.section == 1){
            headerCell.headerTextLabel.text = self.labelLocalization.homeHeaderScenesText
        }
        
        return headerCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(self.isCellsShaking){
            if(indexPath.section == 0){
                self.setUpDeviceCellSelected(collectionView, indexPath)
            }else{
                self.setUpSceneCellSelected(collectionView, indexPath)
            }
        }else{
            if(indexPath.section == 0){
                self.showInfoDetailAboutHubAccessory(for: indexPath)
            }else{
                self.startSceneActions(for: indexPath)
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegate{
    
}

