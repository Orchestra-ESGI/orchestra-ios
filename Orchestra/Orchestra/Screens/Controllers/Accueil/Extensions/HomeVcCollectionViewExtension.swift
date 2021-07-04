//
//  ScenesListVcExtension.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 15/04/2021.
//

import Foundation
import UIKit
import MaterialComponents.MaterialChips

// - MARK: Collection view setup
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == self.roomsCollectionView){
            let defaultCellHeight: CGFloat = 40
            let defaultCellWidth = (self.view.frame.width / 3) - 10
            
            let caracterForDefaultWidth = CGFloat(10) // number of caracters in cell of default width
            let roomNameSize = CGFloat(self.rooms[indexPath.row].name?.count ?? 0)
            
            var cellRatioWidth = roomNameSize / caracterForDefaultWidth
            // Dynamise cell width depending on room name's width
            if(cellRatioWidth < 1){
                cellRatioWidth = 1
            }
            if(cellRatioWidth > 2){
                cellRatioWidth = 2
            }
            let totalWidth: CGFloat = defaultCellWidth * cellRatioWidth

            return CGSize(width: totalWidth, height: defaultCellHeight)
        }else{
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
}

extension HomeViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if(collectionView == self.roomsCollectionView){
            return 1
        }else{
            return 3
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == self.roomsCollectionView){
            return self.rooms.count
        }else{
            if section == 0 {
                return self.filtereHubDevices.count
            }else if section == 1 {
                return self.filteredHomeScenes.count
            }else{
                return self.filteredAutomations.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == self.roomsCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath) as! MDCChipCollectionViewCell
            cell.chipView.titleLabel.text = self.rooms[indexPath.row].name
            cell.chipView.titleLabel.textAlignment = .center
            cell.chipView.titleFont = Font.Bold(18.0)
            cell.chipView.setTitleColor(ColorUtils.ORCHESTRA_WHITE_COLOR, for: .selected)
            let selectedChipColor = ColorUtils.ORCHESTRA_RED_COLOR
            let defaultChipColor = ColorUtils.ORCHESTRA_WHITE_COLOR
            if(indexPath.row == self.selectedRoomIndex){
                cell.chipView.setBackgroundColor(selectedChipColor, for: .normal)
                cell.chipView.setTitleColor(defaultChipColor, for: .normal)
            }else{
                cell.chipView.setBackgroundColor(ColorUtils.ORCHESTRA_WHITE_COLOR, for: .normal)
                cell.chipView.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            }
            cell.chipView.imageView.isHidden = self.isCellsShaking
            return cell
        }else{
            if(indexPath.section == 0){
                // Hub device
                return  self.fillHubDeviceCell(indexPath, collectionView)
            }else{
                return self.setUpSceneCell(indexPath, collectionView)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if(collectionView == self.roomsCollectionView){
            return UICollectionReusableView()
        }else{
            let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SECTION_HEADER", for: indexPath) as! HeaderCollectionViewCell

            if(indexPath.section == 0){
                headerCell.headerTextLabel.text = self.labelLocalization.homeHeaderObjectsText
            }else if(indexPath.section == 1){
                headerCell.headerTextLabel.text = self.labelLocalization.homeHeaderScenesText
            }else if(indexPath.section == 2){
                headerCell.headerTextLabel.text = self.labelLocalization.homeHeaderAutomationText
            }
            
            return headerCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(self.isCellsShaking){
            if(collectionView == self.roomsCollectionView){
                print("Selected \(self.rooms[indexPath.row]) to be removed")
            }else{
                if(indexPath.section == 0){
                    self.setUpDeviceCellSelected(collectionView, indexPath)
                }else if(indexPath.section == 1){
                    self.setUpSceneCellSelected(collectionView, indexPath)
                }else{
                    self.setUpSelectedAutomation(collectionView, indexPath)
                }
            }
        }else{
            if(collectionView == self.roomsCollectionView){
                if(indexPath.row == 0){
                    self.title = NSLocalizedString("home.screen.default.title", comment: "")
                }else{
                    self.title = NSLocalizedString("home.screen.filter.title", comment: "")
                }
                let selectedChip = collectionView.cellForItem(at: indexPath) as! MDCChipCollectionViewCell
                selectedChip.chipView.setBackgroundColor(ColorUtils.ORCHESTRA_RED_COLOR, for: .selected)
                self.selectedRoomIndex = indexPath.row
                
                self.filterDevices(for: indexPath)
                self.filterScenes(for: indexPath)
                //self.filterAutomation(for: indexPath)
                
                self.collectionView.reloadData()
                self.roomsCollectionView.reloadData()
            }else{
                if(indexPath.section == 0){
                    self.showInfoDetailAboutHubAccessory(for: indexPath)
                }else if(indexPath.section == 1){
                    self.startSceneActions(for: indexPath)
                }else{
                    self.startAutomationActions(for: indexPath)
                }
            }
        }
    }
    
    func filterDevices(for indexPath: IndexPath){
        if(indexPath.row == 0){
            self.filtereHubDevices = self.hubDevices
        }else{
            self.filtereHubDevices = self.hubDevices.filter({ device in
                return self.rooms[indexPath.row].name == NSLocalizedString((device.room?.name)!, comment: "")
            })
        }
    }
    
    func filterScenes(for indexPath: IndexPath){
        if(indexPath.row == 0){
            self.filteredHomeScenes = self.homeScenes
        }else{
            let allFriendlyNames = self.filtereHubDevices.map { device in
                return device.friendlyName
            }
            self.filteredHomeScenes = self.homeScenes.filter({ scene in
                for device in scene.devices{
                    if(allFriendlyNames.contains(device.friendlyName)){
                        return true
                    }
                }
                return false
            })
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegate{
    
}

