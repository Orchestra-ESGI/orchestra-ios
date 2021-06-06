//
//  HomeViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 04/04/2021.
//

import UIKit
import RxSwift
import RxCocoa
import Floaty
import FittedSheets

class HomeViewController: UIViewController, UIGestureRecognizerDelegate,
                          SendBackDataProtocol, SendDeviceProtocol {
    
    // - MARK: UI
    @IBOutlet weak var collectionView: UICollectionView!
    var addSceneAppbarButon: UIBarButtonItem?
    var cancelButton: UIBarButtonItem?
    var trashButton: UIBarButtonItem?
    var userSettingsAppbarButton: UIBarButtonItem?
    
    // - MARK: Utils
    let notificationUtils = NotificationsUtils.shared
    let notificationLocalize = NotificationLocalizableUtils.shared
    let screenLabelLocalize = ScreensLabelLocalizableUtils.shared
    let progressUtils = ProgressUtils.shared
    let colorUtils = ColorUtils.shared
    
    
    // - MARK: Data
    var userLoggedInData: UserDto?
    var isCellsShaking = false
    var objectVM = HomeViewModel()
    var objectsToRemove: [HubAccessoryConfigurationDto] = []
    var scenesToRemove: [SceneDto] = []

    var hubDevices: [HubAccessoryConfigurationDto] = [] {
        didSet {
            //self.collectionView.reloadData()
        }
    }
    var homeScenes: [SceneDto] = [] {
        didSet {
            //self.collectionView.reloadData()
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
        self.progressUtils.displayIndeterminateProgeress(title: "Chargement de votre domicile...", view: (UIApplication.shared.windows[0].rootViewController?.view)!)
        let hubConfObservable = self.objectVM.homeService.getAllDevices() //self.objectVM.hubConfigWs.getCurrentAccessoriesConfig()
        let allScenesObservable = self.objectVM.fakeScenesWS.getAllScenes(for: "")
        
        _ = Observable.combineLatest(hubConfObservable, allScenesObservable){ (obs1, obs2) -> Bool in
            return obs1 && obs2
        }.subscribe { (finished) in
            if(finished.element!){
                self.hubDevices.sort { (object1, object2) in
                    return object1.isFav! && !object2.isFav!
                }
                self.collectionView.reloadData()
                self.progressUtils.dismiss()
                self.progressUtils.displayCheckMark(title: "Domicile chargé !", view: (UIApplication.shared.windows[0].rootViewController?.view)!)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.progressUtils.dismiss()
                }
            }
        }
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)

        if parent != nil && self.navigationItem.titleView == nil {
            //setClickableTitle()
        }
    }    

    @objc func showHousesnBottomSheet() {
        let housesBottomSheet = UserHousesBottomSheetTableViewController()
        let options = SheetOptions(
            useInlineMode: true
        )
        let sheetController = SheetViewController(controller: housesBottomSheet, sizes: [.percent(0.4), .percent(0.6)], options: options)
        sheetController.allowGestureThroughOverlay = true

        // animate in
        sheetController.animateIn(to: view, in: self)
    }
    
    // MARK: Internal functions
    func showInfoDetailAboutHubAccessory(for indexPath: IndexPath){
        // Object clicked on
        // Show more about the object
        let objectVC =  DeviceInfoViewController()
        objectVC.deviceData = self.hubDevices[indexPath.row]
        _ = objectVC.favClicStream
            .subscribe(onNext: { (friendlyName) in
            let objectToUpdate = self.hubDevices.compactMap { (object) in
                return object.friendlyName == friendlyName ? object : nil
            }
            objectToUpdate[0].isFav = !objectToUpdate[0].isFav!
            // Sort objects to show fav at the top
            self.hubDevices.sort { (object1, object2) in
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
        self.hubDevices = self.hubDevices.filter { (object) -> Bool in
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
    
    func save(device: HubAccessoryConfigurationDto) {
        self.hubDevices.append(device)
        self.hubDevices.sort { (object1, object2) in
            return object1.isFav! && !object2.isFav!
        }
        self.collectionView.reloadData()
    }

    // - MARK: Observers
    private func bindClickToButtons(){
        setAddSceneOrDeviceButtonBinding()
        setUserSettingButtonBinding()
        setTrashButtonBinding()
    }
    
    private func setUpObservers(){
        self.observeAllDevices()
        self.setObjectStreamObserver()
        self.setScenesStreamObserver()
        self.setEditModeObserver()
        self.editingTableViewObserver()
    }
}


extension UIButton {
    func addLeftIcon(image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)

        let length = CGFloat(15)
        titleEdgeInsets.left += length

        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: self.titleLabel!.leftAnchor, constant: -20),
            imageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: 18),
            imageView.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
