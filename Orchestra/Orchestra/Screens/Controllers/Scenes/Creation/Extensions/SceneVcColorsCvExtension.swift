//
//  SceneVcColorsTvExtension.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 14/04/2021.
//

import Foundation
import UIKit

extension SceneViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "COLOR_CELL", for: indexPath)

        
        cell.backgroundColor = self.sceneColors[indexPath.row]
        cell.layer.cornerRadius = 25
        cell.layer.masksToBounds = true
        
        
        if(self.selectedColor == indexPath.row){
            let selectedicon = UIView(frame: CGRect(x: cell.frame.height/2 - 10,
                                                    y: cell.frame.width/2 - 10,
                                                    width: 20,
                                                    height: 20))
            selectedicon.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            selectedicon.layer.cornerRadius = 10
            
            cell.addSubview(selectedicon)
        }else{
            cell.subviews.forEach { $0.removeFromSuperview() }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.selectedColor = indexPath.row
        self.backgroudColorsCollectionView.reloadData()
    }
    
}
