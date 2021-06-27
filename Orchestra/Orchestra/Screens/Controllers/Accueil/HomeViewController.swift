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
import WatchConnectivity

class HomeViewController: UIViewController, UIGestureRecognizerDelegate,
                          SendBackDataProtocol, SendDeviceProtocol {
    
    // - MARK: UI
    @IBOutlet weak var collectionView: UICollectionView!
    var addSceneAppbarButon: UIBarButtonItem?
    var cancelButton: UIBarButtonItem?
    var trashButton: UIBarButtonItem?
    var userSettingsAppbarButton: UIBarButtonItem?
    var refreshHome: UIBarButtonItem?
    
    // - MARK: Utils
    let notificationUtils = NotificationsUtils.shared
    let notificationLocalize = NotificationLocalizableUtils.shared
    let screenLabelLocalize = ScreensLabelLocalizableUtils.shared
    let progressUtils = ProgressUtils.shared
    let colorUtils = ColorUtils.shared
    let alertUtils = AlertUtils.shared
    
    
    // - MARK: Data
    let disposeBag = DisposeBag()
    var userLoggedInData: UserDto?
    var isCellsShaking = false
    
    var homeVM: HomeViewModel?
    
    var objectsToRemove: [HubAccessoryConfigurationDto] = []
    var scenesToRemove: [SceneDto] = []

    var hubDevices: [HubAccessoryConfigurationDto] = []
    var homeScenes: [SceneDto] = []

    let isSchakingStream = PublishSubject<Bool>()
    let elementsToRemoveStream = PublishSubject<Bool>()
    let refreshControl = UIRefreshControl()
    
    var sessionConnectivity: WCSession?
    var dataToTranferToWatch: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(self.navigationController?.viewControllers.count ?? 0 > 1){
            self.clearControllerStack()
        }
        self.manageWatchConnection()
        self.navigationController?.navigationBar.isHidden = false
        self.homeVM = HomeViewModel(navCtrl: self.navigationController!)
        // Setup UI
        self.setUpTopBar()
        self.setUpCollectionView()
        // Binding click with buttons
        self.bindClickToButtons()
        self.setUpObservers()
        // Fetch data
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)

        self.collectionView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    private func clearControllerStack(){
        
        for _ in 0..<(self.navigationController?.viewControllers.count)! - 1{
            self.self.navigationController?.viewControllers.remove(at: 0)
        }
    }
    
    @objc func didPullToRefresh() {
        print("refreshed")
        self.loadData()
    }
    
    private func manageWatchConnection(){
        if WCSession.isSupported(){
            let session = WCSession.default
            session.delegate = self
            if(session.activationState == .notActivated){
                session.activate()
            }
            self.sessionConnectivity = session
        }
    }
    
    func playAllActionsOf(for index: IndexPath){
        self.startSceneActions(for: index)
    }
    
    func syncWatchScenes(){
        guard WCSession.default.isReachable else{
            return
        }

        WCSession.default.sendMessage(dataToTranferToWatch) { (reply) in
            print("responseHandler: \(reply)")
        } errorHandler: { (err) in
            print("errorHandler: \(err)")
        }
        dataToTranferToWatch.removeAll()
    }
    
    func parseScenesForWatch(){
        var sceneCount = 0
        for scene in self.homeScenes {
            let sceneKey = (sceneCount).description
            self.dataToTranferToWatch[sceneKey] = scene.mapSceneToString(position: sceneCount + 1)
            
            print(scene)
            sceneCount += 1
        }
    }
    
    func parseDevicesForWatch(){
        var deviceCount = 0
        for device in self.hubDevices {
            let deviceKey = (deviceCount).description
            self.dataToTranferToWatch[deviceKey] = device.mapDeviceToString(position: deviceCount + 1)
            
            print(device)
            deviceCount += 1
        }
    }
    
    func loadData(){
        let loadingString = self.screenLabelLocalize.homeScreenProgressAlertTitle
        self.progressUtils.displayIndeterminateProgeress(title: loadingString, view: (UIApplication.shared.windows[0].rootViewController?.view)!)
        self.homeVM!.loadAllDevicesAndScenes { successLoad in
            self.refreshHome(successLoad)
            self.refreshControl.endRefreshing()
        }
    }
    
    private func refreshHome(_ loadSuccessfull: Bool){
        self.progressUtils.dismiss()
        self.collectionView.reloadData()
        
        if let watchConnectivity = self.sessionConnectivity,
           watchConnectivity.isWatchAppInstalled,
           watchConnectivity.isPaired,
           watchConnectivity.isReachable{
            self.parseDevicesForWatch()
            self.parseScenesForWatch()
            self.syncWatchScenes()
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.collectionView.alpha = 1
        })
        if(loadSuccessfull){
            let view = (UIApplication.shared.windows[0].rootViewController?.view)!
            let loadingFinishedString = self.screenLabelLocalize.homeScreenProgressAlertTitle
            self.progressUtils.displayCheckMark(title: loadingFinishedString, view: view)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.progressUtils.dismiss()
            }
        }else{
            let errorNotificationTitle = self.notificationLocalize.homeLoadingErrorNotificationTitle
            let errorNotificationSubtitle = self.notificationLocalize.homeLoadingErrorNotificationSubtitle
            self.notificationUtils.showFloatingNotificationBanner(title: errorNotificationTitle,
                                                                  subtitle: errorNotificationSubtitle,
                                                                  position: .top,
                                                                  style: .danger)
        }
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)

        if parent != nil && self.navigationItem.titleView == nil {
            //setClickableTitle()
        }
    }    

//    Implement here whatever you want to add to menu that appears when top right + button is clicked
//    @objc func showHousesnBottomSheet() {
//      
//    }
    
    // MARK: Internal functions
    func showInfoDetailAboutHubAccessory(for indexPath: IndexPath){
        // Object clicked on
        // Show more about the object
        let objectVC =  DeviceInfoViewController()
        objectVC.deviceData = self.hubDevices[indexPath.row]
        _ = objectVC.favClicStream
            .subscribe(onNext: { (friendlyName) in
                _ = self.hubDevices.compactMap { (object) in
                return object.friendlyName == friendlyName ? object : nil
            }
            self.collectionView.reloadData()
        }, onError: { (err) in
            print("err")
        }).disposed(by: self.disposeBag)

        self.navigationController?.present(UINavigationController(rootViewController: objectVC), animated: true, completion: {
        })
    }
    
    func startSceneActions(for indexPath: IndexPath){
        // Scene clicked on
        // Start actionsn of the scene
        print("Strating actions...")
        self.homeVM?.sceneVm?.playScene(id: self.homeScenes[indexPath.row].id)
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
        let deviceInfoMap = self.hubDevices.map({ device  in
            return [device.friendlyName : device.name!]
        })
        sceneDetailVc.devices = deviceInfoMap
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
        
        let removedDeviceObservable = self.homeVM!.clearObjectSelected { observer in
            if(self.objectsToRemove.count > 0){
                let deviceRemovedFriendlyNames = self.objectsToRemove.map { device -> String in
                    return device.friendlyName
                }
                _ = self.homeVM?
                    .removeDevices(friendlyNames: deviceRemovedFriendlyNames)
                    .subscribe{ finished in
                    if(finished){
                        self.deleteSelectedObjects()
                        print("Device deleted")
                        observer.onNext(true)
                        if let watchConnectivity = self.sessionConnectivity,
                           watchConnectivity.isWatchAppInstalled,
                           watchConnectivity.isPaired,
                           watchConnectivity.isReachable{
                            self.parseDevicesForWatch()
                            self.syncWatchScenes()
                        }
                    }else{
                        observer.onNext(false)
                    }
                } onError: { err in
                    let deleteDeviceErreurTitle = self.notificationLocalize.deleteDeviceErrorNotificationTitle
                    let deleteDeviceErreurSubtitle = self.notificationLocalize.deleteDeviceErrorNotificationSubtitle
                    self.notificationUtils.showFloatingNotificationBanner(title: deleteDeviceErreurTitle,
                                                                          subtitle: deleteDeviceErreurSubtitle,
                                                                          position: .top,
                                                                          style: .danger)
                    print("Err when removing device")
                    observer.onNext(false)
                } onCompleted: {
                    print("onCompleted() called in setScenesStreamObserver()")
                    self.progressUtils.dismiss()
                    let alertMessage = self.screenLabelLocalize.localNetworkAuthAlertMessage
                    self.alertUtils.goToParamsAlert(message: alertMessage, for: self)
                }
            }else{
                observer.onNext(true)
            }
        }

        
        let removedSceneObservable = self.homeVM!.clearScenesSelected { observer in
            if(self.scenesToRemove.count > 0){
                let sceneRemovedids = self.scenesToRemove.map { scene -> String in
                    return scene.id
                }
                _ = self.homeVM!
                    .removeScenes(ids: sceneRemovedids)
                    .subscribe{ finished in
                    if(finished){
                        self.deleteSelectedScenes()
                        print("Scene deleted")
                        observer.onNext(true)
                        if let watchConnectivity = self.sessionConnectivity,
                           watchConnectivity.isWatchAppInstalled,
                           watchConnectivity.isPaired,
                           watchConnectivity.isReachable{
                            self.parseScenesForWatch()
                            self.syncWatchScenes()
                        }
                    }else{
                        observer.onNext(false)
                    }
                } onError: { err in
                    let errorDeletNotificationTitle = self.notificationLocalize.deleteDeviceErrorNotificationTitle
                    let errorDeletNotificationSubtitle = self.notificationLocalize.deleteDeviceErrorNotificationSubtitle
                    self.notificationUtils.showFloatingNotificationBanner(title: errorDeletNotificationTitle,
                                                                          subtitle: errorDeletNotificationSubtitle,
                                                                          position: .top, style: .danger)
                    print("Err when removing device")
                    observer.onNext(false)
                } onCompleted: {
                    print("onCompleted() called in setScenesStreamObserver()")
                    self.progressUtils.dismiss()
                    let alertMessage = self.screenLabelLocalize.localNetworkAuthAlertMessage
                    self.alertUtils.goToParamsAlert(message: alertMessage, for: self)
                }
            }else{
                observer.onNext(true)
            }
        }
        
        _ = Observable.combineLatest(removedDeviceObservable, removedSceneObservable){ (obs1, obs2) -> Bool in
            return obs1 && obs2
        }.subscribe { (finished) in
            self.isCellsShaking = !self.isCellsShaking
            self.progressUtils.dismiss()
            self.stopCellsShake()
            if(finished.element!){
                self.progressUtils.displayCheckMark(title: finishProgressAlertTitle, view: self.view)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.progressUtils.dismiss()
                }
            }else{
                let errorDeletNotificationTitle = self.notificationLocalize.deleteDeviceErrorNotificationTitle
                let errorDeletNotificationSubtitle = self.notificationLocalize.deleteDeviceErrorNotificationSubtitle
                self.notificationUtils.showFloatingNotificationBanner(title: errorDeletNotificationTitle,
                                                                      subtitle: errorDeletNotificationSubtitle,
                                                                      position: .top, style: .danger)
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
        self.collectionView.reloadData()
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
        self.collectionView.reloadData()
    }

    // - MARK: Observers
    private func bindClickToButtons(){
        setAddSceneOrDeviceButtonBinding()
        setUserSettingButtonBinding()
        setTrashButtonBinding()
        refreshButtonBinging()
    }
    
    private func setUpObservers(){
        self.observeAllDevices()
        //self.setObjectStreamObserver()
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
