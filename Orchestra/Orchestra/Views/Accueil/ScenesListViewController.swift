//
//  ScenesListViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 04/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ScenesListViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // - MARK: UI
    @IBOutlet weak var collectionView: UICollectionView!
    var addSceneAppbarButon: UIBarButtonItem?
    var userSettingsAppbarButton: UIBarButtonItem?
    
    // - MARK: Utils
    let notificationUtils = NotificationsUtils.shared
    let notificationLocalize = NotificationLocalizableUtils.shared
    let screenLabelLocalize = ScreensLabelLocalizableUtils()
    
    // - MARK: Services
    let fakeObjectsWS = FakeObjectsDataService.shared
    let fakeScenesWS = FakeSceneDataService.shared
    
    
    // - MARK: Data
    var userLoggedInData: UserDto?
    let disposeBag = DisposeBag()
    
    var homeObjects: [ObjectDto] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    var homeScenes: [SceneDto] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
        self.observeClick()
        self.setUpObservers()
        
        // Throw calls needed to refresh UI
        self.fakeObjectsWS.getAllObjects(for: "")
        self.fakeScenesWS.getAllScenes(for: "")
    }
    

    // - MARK: Observers
    private func observeClick(){
        self.addSceneAppbarButon?.rx
            .tap
            .bind { [weak self] in
                self?.navigationController?.pushViewController(SceneViewController(), animated: true)
        }.disposed(by: self.disposeBag)
        
        self.userSettingsAppbarButton?.rx
            .tap
            .bind { [weak self] in
                self?.navigationController?.pushViewController(AppSettingsViewController(), animated: true)
        }.disposed(by: self.disposeBag)
    }
    
    private func setUpObservers(){
        self.fakeObjectsWS
            .objectStream
            .subscribe { (objects) in
                self.homeObjects = objects
                self.homeObjects.sort { (object1, object2) in
                    return object1.isFav! && !object2.isFav!
                }
        } onError: { (err) in
            self.notificationUtils
                .showFloatingNotificationBanner(title: self.notificationLocalize.loginCredentialsWrongNotificationTitle, subtitle: self.notificationLocalize.loginCredentialsWrongNotificationSubtitle, position: .top, style: .warning)
        }.disposed(by: self.disposeBag)
        
        
        self.fakeScenesWS
            .sceneStream
            .subscribe { (scenes) in
                self.homeScenes = scenes
        } onError: { (err) in
            self.notificationUtils
                .showFloatingNotificationBanner(title: self.notificationLocalize.loginCredentialsWrongNotificationTitle, subtitle: self.notificationLocalize.loginCredentialsWrongNotificationSubtitle, position: .top, style: .warning)
        }.disposed(by: self.disposeBag)
    }
    
    
    // - MARK: UI
    private func setUpView(){
        self.navigationItem.hidesBackButton = true
        self.title = "Mon domicile" //userLoggedInData?.houses[0].houseName
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        addSceneAppbarButon = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: nil)
        userSettingsAppbarButton = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .done, target: self, action: nil)

        addSceneAppbarButon!.tintColor = #colorLiteral(red: 2.387956192e-05, green: 0.5332912803, blue: 0.8063663244, alpha: 1)
        userSettingsAppbarButton!.tintColor = #colorLiteral(red: 2.387956192e-05, green: 0.5332912803, blue: 0.8063663244, alpha: 1)
        
        self.navigationItem.rightBarButtonItem = addSceneAppbarButon!
        self.navigationItem.leftBarButtonItem = userSettingsAppbarButton!
        
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
        
        super.traitCollectionDidChange(previousTraitCollection)
        self.collectionView.reloadData()
    }
    
    private func showInfoDetailAboutObject(for indexPath: IndexPath){
        // Object clicked on
        // Show more about the object
        let objectVC =  ObjectInfoViewController()
        objectVC.objectData = self.homeObjects[indexPath.row]
        _ = objectVC.favClicStream
            .subscribe(onNext: { (objId) in
            let objectToUpdate = self.homeObjects.compactMap { (object) in
                return object._id == objId ? object : nil
            }
            objectToUpdate[0].isFav = !objectToUpdate[0].isFav!
            // Sort objects to show fav at the top
            self.homeObjects.sort { (object1, object2) in
                return object1.isFav! && !object2.isFav!
            }
            self.collectionView.reloadData()
        }, onError: { (err) in
            print("err")
        }).disposed(by: self.disposeBag)

        self.navigationController?.present(UINavigationController(rootViewController: objectVC), animated: true, completion: {
            print("Detail about object presented")
        })
    }
    
    private func startSceneActions(for indexPath: IndexPath){
        // Scene clicked on
        // Start actionsn of the scene
        print("Strating actions...")
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
        var sections = 2
        if(self.homeObjects.count == 0){
            sections -= 1
        }
        if(self.homeScenes.count == 0){
            sections -= 1
        }
        
        return sections
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.homeObjects.count
        }else if section == 1{
            return self.homeScenes.count
        }

        return 0
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
            let currentCellPos = indexPath.row
            
            objectCell.objectPlaceNameLabel.text = self.homeObjects[currentCellPos].name
            objectCell.objectNameLabel.text = self.homeObjects[currentCellPos].roomName
            objectCell.objectStatusLabel.text = "Disponible"
            objectCell.favIcon.image = self.homeObjects[currentCellPos].isFav! ? UIImage(systemName: "heart.fill") : UIImage(systemName: "")
            objectCell.favIcon.tintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
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
