//
//  ScenesListViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 04/04/2021.
//

import UIKit
import RxSwift
import RxCocoa
import Floaty

class ScenesListViewController: UIViewController, UIGestureRecognizerDelegate, SendBackDataProtocol {
    
    // - MARK: UI
    @IBOutlet weak var collectionView: UICollectionView!
    var addSceneAppbarButon: UIBarButtonItem?
    var cancelButton: UIBarButtonItem?
    var trashButton: UIBarButtonItem?
    var userSettingsAppbarButton: UIBarButtonItem?
    
    // - MARK: Utils
    let notificationUtils = NotificationsUtils.shared
    let notificationLocalize = NotificationLocalizableUtils.shared
    let screenLabelLocalize = ScreensLabelLocalizableUtils()
    let progressUtils = ProgressUtils.shared
    
    // - MARK: Services
    let fakeObjectsWS = FakeObjectsDataService.shared
    let fakeScenesWS = FakeSceneDataService.shared
    
    
    // - MARK: Data
    var userLoggedInData: UserDto?
    let disposeBag = DisposeBag()
    var isCellsShaking = false
    let isSchakingStream = PublishSubject<Bool>()
    let elementsToRemoveStream = PublishSubject<Bool>()
    
    var objectsToRemove: [ObjectDto] = []
    var scenesToRemove: [SceneDto] = []
    
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
        
        self.setUpTopBar()
        self.setUpCollectionView()
        self.setUpFAB()
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
                if((self!.isCellsShaking)){
                    self?.stopCellsShake()
                    self?.isCellsShaking = !self!.isCellsShaking
                }
                let sceneVc = SceneViewController()
                sceneVc.dataDelegate = self
                self?.navigationController?.pushViewController(sceneVc, animated: true)
        }.disposed(by: self.disposeBag)
        
        self.userSettingsAppbarButton?.rx
            .tap
            .bind { [weak self] in
                if((self!.isCellsShaking)){
                    self?.stopCellsShake()
                    self?.isCellsShaking = !self!.isCellsShaking
                }
                self?.navigationController?.pushViewController(AppSettingsViewController(), animated: true)
        }.disposed(by: self.disposeBag)
        
        _ = cancelButton?.rx.tap.bind{
            self.stopCellsShake()
            self.isCellsShaking = !self.isCellsShaking
        }
        
        _ = trashButton?
            .rx
            .tap.bind{
            let alertTitle = self.notificationLocalize.removeDataAlertTitle
            let alertSubtitle = self.notificationLocalize.removeDataAlertSubtitle
            let alertCancelAction = self.notificationLocalize.removeDataAlertCancelButtonText
            let alertRemoveAction = self.notificationLocalize.removeDataAlertDeleteButtonText
            
            let alert = UIAlertController(title: alertTitle, message: alertSubtitle, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: alertRemoveAction, style: .destructive, handler: { _ in
                self.clearCellsSelection()
            }))
            alert.addAction(UIAlertAction(title: alertCancelAction, style: .cancel, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
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
        
        self.isSchakingStream.subscribe { (isShaking) in
            if(isShaking.element!){
                self.cancelButton?.isEnabled = true
                self.cancelButton?.tintColor = #colorLiteral(red: 2.387956192e-05, green: 0.5332912803, blue: 0.8063663244, alpha: 1)
                self.trashButton?.isEnabled = true
                self.trashButton?.tintColor = #colorLiteral(red: 2.387956192e-05, green: 0.5332912803, blue: 0.8063663244, alpha: 1)
            }else{
                self.cancelButton?.isEnabled = false
                self.cancelButton?.tintColor = .clear
                self.trashButton?.isEnabled = false
                self.trashButton?.tintColor = .clear
            }
        }.disposed(by: self.disposeBag)

        self.elementsToRemoveStream
            .subscribe { (elementsExists) in
                if(elementsExists.element!){
                    self.trashButton?.isEnabled = true
                    self.trashButton?.tintColor = #colorLiteral(red: 2.387956192e-05, green: 0.5332912803, blue: 0.8063663244, alpha: 1)
                }else{
                    self.trashButton?.isEnabled = false
                    self.trashButton?.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                }
        }.disposed(by: self.disposeBag)
        

    }

    
    // - MARK: UI
    private func setUpTopBar(){
        self.navigationItem.hidesBackButton = true
        self.title = "Mon domicile" //userLoggedInData?.houses[0].houseName
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        addSceneAppbarButon = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: nil)
        cancelButton = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"), style: .done, target: self, action: nil)
        trashButton = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .done, target: self, action: nil)
        userSettingsAppbarButton = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .done, target: self, action: nil)
        
        cancelButton?.isEnabled = false
        cancelButton?.tintColor = .clear
        trashButton?.isEnabled = false
        trashButton?.tintColor = .clear
        addSceneAppbarButon!.tintColor = #colorLiteral(red: 2.387956192e-05, green: 0.5332912803, blue: 0.8063663244, alpha: 1)
        userSettingsAppbarButton!.tintColor = #colorLiteral(red: 2.387956192e-05, green: 0.5332912803, blue: 0.8063663244, alpha: 1)
        
        self.navigationItem.rightBarButtonItems = [addSceneAppbarButon!, trashButton!, cancelButton!]
        self.navigationItem.leftBarButtonItem = userSettingsAppbarButton!
    }
    
    func setUpCollectionView(){
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
    
    private func setUpFAB(){
        let floatingActionButton = Floaty()
        floatingActionButton.buttonImage = UIImage(systemName: "gearshape.fill")
        floatingActionButton.plusColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        floatingActionButton.buttonColor = #colorLiteral(red: 0.9254902005, green: 0.02265601113, blue: 0, alpha: 1)
        floatingActionButton.openAnimationType = .slideUp
        
        let pairPhoneButton = setUpFloatyItem()
        pairPhoneButton.title = "Appairage au Hub"
        pairPhoneButton.icon =  UIImage(named: "hub")!
        pairPhoneButton.handler = { item in
            self.showPairingVc()
            floatingActionButton.close()
        }
        
        let shareAppButton = setUpFloatyItem()
        shareAppButton.icon =  UIImage(systemName: "square.and.arrow.up")
        shareAppButton.title = "Notez nous"
        shareAppButton.handler = { item in
            self.showRatemarks()
            floatingActionButton.close()
        }
        

        let rateAppButton = setUpFloatyItem()
        rateAppButton.icon =  UIImage(systemName: "star")
        rateAppButton.tintColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        rateAppButton.title = "Partagez Orchestra"
        rateAppButton.handler = { item in
            self.showShareBottomSheet()
            floatingActionButton.close()
        }


        floatingActionButton.addItem(item: pairPhoneButton)
        floatingActionButton.addItem(item: shareAppButton)
        floatingActionButton.addItem(item: rateAppButton)
        
        self.view.addSubview(floatingActionButton)
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
    
    // MARK: Internal functions
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
    
    func shakeCells(){
        self.isSchakingStream.onNext(true)
        self.elementsToRemoveStream.onNext(false)
        for cell in self.collectionView.visibleCells {
            if cell is ObjectCollectionViewCell {
                let customCell: ObjectCollectionViewCell = cell as! ObjectCollectionViewCell
                addWiggleAnimationToCell(cell: customCell)
            }else{
                let customCell: SceneCollectionViewCell = cell as! SceneCollectionViewCell
                addWiggleAnimationToCell(cell: customCell)
            }
        }
    }
    
    func stopCellsShake(){
        self.isSchakingStream.onNext(false)
        for cell in self.collectionView.visibleCells {
            if cell is ObjectCollectionViewCell {
                let customCell: ObjectCollectionViewCell = cell as! ObjectCollectionViewCell
                customCell.layer.removeAllAnimations()
            }else{
                let customCell: SceneCollectionViewCell = cell as! SceneCollectionViewCell
                customCell.layer.removeAllAnimations()
            }
        }
        self.objectsToRemove.removeAll()
        self.scenesToRemove.removeAll()
        self.collectionView.reloadData()
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizer.State.began {
            if(!self.isCellsShaking){
                self.isCellsShaking = !self.isCellsShaking
                self.shakeCells()
            }
        }
    }
    
    @objc func showSceneDetail(sender: UIButton){
        print("Scene detail of \(sender.tag)")
    }
    
    private func clearCellsSelection(){
        // Do call WS here to remove from db
        self.progressUtils.displayIndeterminateProgeress(title: "Supression en cours, veuillez patienter...", view: self.view)
        let removedObjectObservable = self.clearObjectSelected()
        let removedSceneObservable = self.clearScenesSelected()
        
        _ = Observable.combineLatest(removedObjectObservable, removedSceneObservable){ (obs1, obs2) -> Bool in
            return obs1 && obs2
        }.subscribe { (finished) in
            if(finished.element!){
                self.stopCellsShake()
                self.isCellsShaking = !self.isCellsShaking
                self.progressUtils.dismiss()
                self.progressUtils.displayCheckMark(title: "Supression effectuée", view: self.view)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.progressUtils.dismiss()
                }
            }
        }
    }
    
    private func clearObjectSelected() -> Observable<Bool>{
        return Observable<Bool>.create { (observer) -> Disposable in
            if(self.objectsToRemove.count > 0){
                _ = self.fakeObjectsWS
                    .removeObject()
                    .subscribe(onNext: { (objectRemoved) in
                        self.homeObjects = self.homeObjects.filter { (object) -> Bool in
                            return !self.objectsToRemove.contains(object)
                        }
                        self.objectsToRemove.removeAll()
                        observer.onNext(true)
                    }, onError: { (err) in
                        observer.onError(err)
                        print("err")
                    })
                    .disposed(by: self.disposeBag)
            }else{
                observer.onNext(true)
            }
            return Disposables.create()
        }
    }
    
    
    private func clearScenesSelected() -> Observable<Bool>{
        return Observable<Bool>.create { (observer) -> Disposable in
            if(self.scenesToRemove.count > 0){
                _ = self.fakeScenesWS
                    .removeScene()
                    .subscribe { (sceneRemoved) in
                        self.homeScenes = self.homeScenes.filter({ (scene) -> Bool in
                            return !self.scenesToRemove.contains(scene)
                        })
                        self.scenesToRemove.removeAll()
                        observer.onNext(true)
                    } onError: { (err) in
                        observer.onError(err)
                        print("err")
                    }.disposed(by: self.disposeBag)
            }else{
                observer.onNext(true)
            }
            return Disposables.create()
        }
    }
    
    private func showPairingVc(){
        print("Hub pairing...")
    }
    
    private func showRatemarks(){
        print("Rate us")
    }
    
    private func showShareBottomSheet(){
        print("Share")
    }
    
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
}
