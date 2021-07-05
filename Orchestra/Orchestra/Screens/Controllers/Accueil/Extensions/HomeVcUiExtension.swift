//
//  ScenesListUiExtension.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/04/2021.
//

import Foundation
import UIKit
import Floaty
import MaterialComponents.MaterialChips

extension HomeViewController{
    
    // - MARK: UI
    func setClickableTitle() {
        let titleView = UIButton()
        titleView.setTitle("Mon domicile", for: .normal)
        titleView.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25.0)
        titleView.tintColor = .systemBackground

        let width = titleView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width
        titleView.frame = CGRect(origin:CGPoint.zero, size:CGSize(width: width, height: 60))
        self.navigationItem.titleView = titleView

        titleView.isUserInteractionEnabled = true
    }
    
    func setUpTopBar(){
        self.navigationItem.hidesBackButton = true
        self.title = NSLocalizedString("home.screen.default.title", comment: "")
        let attributes = [NSAttributedString.Key.font: Font.Bold(20)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        self.view.backgroundColor = ColorUtils.ORCHESTRA_BLUE_COLOR
        
        addSceneAppbarButon = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: nil)
        cancelButton = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"), style: .done, target: self, action: nil)
        trashButton = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .done, target: self, action: nil)
        
        menuButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .done, target: self, action: nil)
        
        cancelButton?.isEnabled = false
        cancelButton?.tintColor = .clear
        trashButton?.isEnabled = false
        trashButton?.tintColor = .clear
        addSceneAppbarButon!.tintColor = #colorLiteral(red: 2.387956192e-05, green: 0.5332912803, blue: 0.8063663244, alpha: 1)
        
        self.navigationItem.rightBarButtonItems = [addSceneAppbarButon!, trashButton!, cancelButton!]
        self.navigationItem.leftBarButtonItem = menuButton 
    }
    
    func setupRoomCollectionView(){
        self.roomsCollectionView.showsHorizontalScrollIndicator = false
        self.roomsCollectionView.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "identifier")
        self.roomsCollectionView.delegate = self
        self.roomsCollectionView.dataSource = self
        self.roomsCollectionView.backgroundColor = .clear
    }
    
    func setUpCollectionView(){
        self.collectionView.alpha = 0
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = .clear
        
        // CELLS
        self.collectionView.register(UINib(nibName: "ObjectCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OBJECT")
        self.collectionView.register(UINib(nibName: "SceneCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SCENE")
        
        // HEADERS AND FOOTERS
        self.collectionView?.register(UINib(nibName: "HeaderCollectionViewCell", bundle: nil), forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SECTION_HEADER")
    }
    
    func generatesBackGroundColor() -> UIColor{
        return UIColor(red: .random(in: 0.2...0.7),
                       green: .random(in: 0.2...0.7),
                       blue: .random(in: 0.2...0.7),
                                alpha: 1.0)

    }
    
    // Catch Dark mode / light mode switch
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.collectionView.reloadData()
    }
    
    private func setUpFloatyItem() -> FloatyItem{
        let floaty = FloatyItem()
        floaty.titleLabel.font = UIFont(name: "Avenir Medium", size: 19)
        floaty.titleLabel.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        floaty.titleLabel.layer.cornerRadius = 5
        floaty.titleLabel.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        floaty.titleLabel.layer.borderWidth = 1
        floaty.titleLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        return floaty
    }
}
