//
//  ScenesListViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 04/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ScenesListViewController: UIViewController, UIGestureRecognizerDelegate, SendBackDataProtocol {
    
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
                let sceneVc = SceneViewController()
                sceneVc.dataDelegate = self
                self?.navigationController?.pushViewController(sceneVc, animated: true)
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
    
    
    
    // MARK: Internal functions
    func saveScene(scene: SceneDto) {
        self.notificationUtils.showFloatingNotificationBanner(title: self.notificationLocalize.successfullyAddedNotificationTitle, subtitle: self.notificationLocalize.successfullyAddedNotificationSubtitle, position: .top, style: .success)
        self.homeScenes.append(scene)
    }
    
    func updateScene(scene: SceneDto) {
        guard let index = self.homeScenes.firstIndex(of: scene) else{
            return
        }
        self.homeScenes.insert(scene, at: index)
        self.homeScenes.remove(at: index + 1)
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
    
    func generatesBackGroundColor() -> UIColor{
        return UIColor(red: .random(in: 0.2...0.7),
                       green: .random(in: 0.2...0.7),
                       blue: .random(in: 0.2...0.7),
                                alpha: 1.0)

    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        super.traitCollectionDidChange(previousTraitCollection)
        self.collectionView.reloadData()
    }
    
    func showInfoDetailAboutObject(for indexPath: IndexPath){
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
    
    func startSceneActions(for indexPath: IndexPath){
        // Scene clicked on
        // Start actionsn of the scene
        print("Strating actions...")
    }
}
