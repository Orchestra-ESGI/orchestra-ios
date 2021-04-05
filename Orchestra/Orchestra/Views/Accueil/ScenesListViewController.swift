//
//  ScenesListViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 04/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ScenesListViewController: UIViewController {
    
    // - MARK: UI
    @IBOutlet weak var collectionView: UICollectionView!
    var addSceneAppbarButon: UIBarButtonItem?
    
    // - MARK: Utils
    let notificationUtils = NotificationsUtils.shared
    let notificationLocalize = NotificationLocalizableUtils.shared
    let screenLabelLocalize = ScreensLabelLocalizableUtils()
    
    // - MARK: Services
    
    
    
    // - MARK: Data
    var userLoggedInData: UserDto?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
        self.observeClick()
    }

    // - MARK: Observers
    private func observeClick(){
        self.addSceneAppbarButon?.rx
            .tap
            .bind { [weak self] in
                self?.notificationUtils.showBasicBanner(title: "WIP", subtitle: "Screenn not available yet", position: .bottom, style: .info)
        }.disposed(by: self.disposeBag)
    }
    
    
    // - MARK: UI
    private func setUpView(){
        self.navigationItem.hidesBackButton = true
        self.title = "Mon domicile" //userLoggedInData?.houses[0].houseName
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        addSceneAppbarButon = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: nil)

        addSceneAppbarButon!.tintColor = #colorLiteral(red: 2.387956192e-05, green: 0.5332912803, blue: 0.8063663244, alpha: 1)
        self.navigationItem.rightBarButtonItems = [addSceneAppbarButon!]
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        // CELLS
        self.collectionView.register(UINib(nibName: "ObjectCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OBJECT")
        self.collectionView.register(UINib(nibName: "SceneCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SCENE")
        
        // HEADERS AND FOOTERS
        self.collectionView?.register(UINib(nibName: "HeaderCollectionViewCell", bundle: nil), forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SECTION_HEADER")

    }
    
    private func generatesBackGroundColor() -> UIColor{
        return UIColor(red: .random(in: 0.2...0.7),
                       green: .random(in: 0.2...0.7),
                       blue: .random(in: 0.2...0.7),
                                alpha: 1.0)

    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        // Catch change between Dark & Light mode
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.collectionView.reloadData()
    }
}



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
        return 2
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 6
        }else{
            return 20
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.section == 0){
            let objectCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OBJECT", for: indexPath) as! ObjectCollectionViewCell
            
            objectCell.objectImageView.image = UIImage(systemName: "message.fill")
            if self.traitCollection.userInterfaceStyle == .dark {
                objectCell.objectImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }else{
                objectCell.objectImageView.tintColor = .black
            }
            objectCell.objectPlaceNameLabel.text = "Chambre"
            objectCell.objectNameLabel.text = "Lampe Hue"
            objectCell.objectStatusLabel.text = "Disponible"
            objectCell.cellContentView.backgroundColor = self.generatesBackGroundColor()
            objectCell.contentView.layer.cornerRadius = 8.0
            objectCell.contentView.layer.borderWidth = 0.2
            objectCell.contentView.layer.masksToBounds = true;
            
            return objectCell
        }else{
            let sceneCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SCENE", for: indexPath) as! SceneCollectionViewCell
            
            sceneCell.sceneImageView.image = UIImage(systemName: "sunset.fill")
            if self.traitCollection.userInterfaceStyle == .dark {
                sceneCell.sceneImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }else{
                sceneCell.sceneImageView.tintColor = .black
            }
            sceneCell.sceneDescription .text = "Description exemple"
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
    
}

extension ScenesListViewController: UICollectionViewDelegate{
    
}
