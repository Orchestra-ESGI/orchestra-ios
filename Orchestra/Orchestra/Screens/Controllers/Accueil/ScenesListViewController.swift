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
    let colorUtils = ColorUtils.shared
    
    
    // - MARK: Data
    var userLoggedInData: UserDto?
    var isCellsShaking = false
    var objectVM = HomeViewModel()
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
    let disposeBag = DisposeBag()
    let isSchakingStream = PublishSubject<Bool>()
    let elementsToRemoveStream = PublishSubject<Bool>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup UI
        self.setUpTopBar()
        self.setUpCollectionView()
        self.setUpFAB()
        // Binding click with buttons
        self.bindClickToButtons()
        self.setUpObservers()
        // Fetch data
        self.objectVM.fakeObjectsWS.getAllObjects(for: "")
        self.objectVM.fakeScenesWS.getAllScenes(for: "")
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
        let sceneSelected = sender.tag
        let sceneDetailVc = SceneDetailViewController()
        let navigationCtr = UINavigationController(rootViewController: sceneDetailVc)
        let sceneData = self.homeScenes[sceneSelected]
        sceneDetailVc.sceneData = sceneData
        self.navigationController?.present(navigationCtr, animated: true, completion: nil)
    }
    
    
    func showPairingVc(){
        print("Hub pairing...")
        let paringVc = HubPairingViewController()
        let paringNavVc = UINavigationController(rootViewController: paringVc)
        self.navigationController?.present(paringNavVc, animated: true)
    }
    
    func showRatemarks(){
        print("Rate us")
    }
    
    func showShareBottomSheet(){
        print("Share")
    }
    
    func clearCellsSelection(){
        // Do call WS here to remove from db
        let progressAlertTitle = self.notificationLocalize.editingHomeProgressViewTitle
        let finishProgressAlertTitle = self.notificationLocalize.finishEditingHomeProgressViewTitle
        self.progressUtils.displayIndeterminateProgeress(title: progressAlertTitle, view: self.view)
        let removedObjectObservable = self.objectVM.clearObjectSelected {
            self.deleteSelectedObjects()
        }
        let removedSceneObservable = self.objectVM.clearScenesSelected{
            self.deleteSelectedScenes()
        }
        
        _ = Observable.combineLatest(removedObjectObservable, removedSceneObservable){ (obs1, obs2) -> Bool in
            return obs1 && obs2
        }.subscribe { (finished) in
            if(finished.element!){
                self.stopCellsShake()
                self.isCellsShaking = !self.isCellsShaking
                self.progressUtils.dismiss()
                self.progressUtils.displayCheckMark(title: finishProgressAlertTitle, view: self.view)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.progressUtils.dismiss()
                }
            }
        }
    }
    
    private func deleteSelectedObjects(){
        self.homeObjects = self.homeObjects.filter { (object) -> Bool in
            return !self.objectsToRemove.contains(object)
        }
        self.objectsToRemove.removeAll()
    }
    
    private func deleteSelectedScenes(){
        self.homeScenes = self.homeScenes.filter({ (scene) -> Bool in
            return !self.scenesToRemove.contains(scene)
        })
        self.scenesToRemove.removeAll()
    }

    // To move to VM
    func saveScene(scene: SceneDto) {
        self.notificationUtils.showFloatingNotificationBanner(title: self.notificationLocalize.successfullyAddedNotificationTitle, subtitle: self.notificationLocalize.successfullyAddedNotificationSubtitle, position: .top, style: .success)
        self.homeScenes.append(scene)
    }
    
    // To move to VM
    func updateScene(scene: SceneDto) {
        guard let index = self.homeScenes.firstIndex(of: scene) else{
            return
        }
        self.homeScenes.insert(scene, at: index)
        self.homeScenes.remove(at: index + 1)
    }
    
    // - MARK: Observers
    private func bindClickToButtons(){
        setAddSceneButtonBinding()
        setUserSettingButtonBinding()
        setTrashButtonBinding()
    }
    
    private func setUpObservers(){
        self.setObjectStreamObserver()
        self.setScenesStreamObserver()
        self.setEditModeObserver()
        self.editingTableViewObserver()
    }
}
