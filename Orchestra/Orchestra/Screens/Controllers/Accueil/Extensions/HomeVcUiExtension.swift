//
//  ScenesListUiExtension.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/04/2021.
//

import Foundation
import UIKit
import Floaty

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
        self.title = "Mon domicile" //userLoggedInData?.houses[0].houseName
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        addSceneAppbarButon = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: nil)
        cancelButton = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"), style: .done, target: self, action: nil)
        trashButton = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .done, target: self, action: nil)
        //userSettingsAppbarButton = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .done, target: self, action: nil)
        
        menuButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .done, target: self, action: nil)
        
        cancelButton?.isEnabled = false
        cancelButton?.tintColor = .clear
        trashButton?.isEnabled = false
        trashButton?.tintColor = .clear
        addSceneAppbarButon!.tintColor = #colorLiteral(red: 2.387956192e-05, green: 0.5332912803, blue: 0.8063663244, alpha: 1)
        //userSettingsAppbarButton!.tintColor = #colorLiteral(red: 2.387956192e-05, green: 0.5332912803, blue: 0.8063663244, alpha: 1)
        
        self.navigationItem.rightBarButtonItems = [addSceneAppbarButon!, trashButton!, cancelButton!]
        self.navigationItem.leftBarButtonItem = menuButton //userSettingsAppbarButton!
    }
    
    func setUpCollectionView(){
        self.collectionView.alpha = 0
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
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
    
//    func setUpFAB(){
//        let floatingActionButton = Floaty()
//        floatingActionButton.buttonImage = UIImage(systemName: "gearshape.fill")
//        floatingActionButton.size = CGFloat(60.0)
//        floatingActionButton.plusColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        floatingActionButton.buttonColor = #colorLiteral(red: 2.387956192e-05, green: 0.5332912803, blue: 0.8063663244, alpha: 1)
//        floatingActionButton.openAnimationType = .slideUp
//        
//        let pairPhoneButton = setUpFloatyItem()
//        pairPhoneButton.title = self.screenLabelLocalize.floatyButtonPairingButtonTitle
//        pairPhoneButton.icon =  UIImage(named: "hub")!
//        pairPhoneButton.handler = { item in
//            self.showPairingVc()
//            floatingActionButton.close()
//        }
//        
//        let shareAppButton = setUpFloatyItem()
//        shareAppButton.icon =  UIImage(systemName: "square.and.arrow.up")
//        shareAppButton.title = self.screenLabelLocalize.floatyButtonShareButtonTitle
//        shareAppButton.handler = { item in
//            self.showRatemarks()
//            floatingActionButton.close()
//        }
//        
//
//        let rateAppButton = setUpFloatyItem()
//        rateAppButton.icon =  UIImage(systemName: "star")
//        rateAppButton.tintColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
//        rateAppButton.title = self.screenLabelLocalize.floatyButtonRateButtonTitle
//        rateAppButton.handler = { item in
//            self.showShareBottomSheet()
//            floatingActionButton.close()
//        }
//
//
//        floatingActionButton.addItem(item: pairPhoneButton)
//        floatingActionButton.addItem(item: shareAppButton)
//        floatingActionButton.addItem(item: rateAppButton)
//        
//        self.view.addSubview(floatingActionButton)
//    }
    
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
