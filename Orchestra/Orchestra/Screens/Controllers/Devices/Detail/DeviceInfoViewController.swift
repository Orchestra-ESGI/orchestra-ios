//
//  DeviceInfoViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 07/04/2021.
//

import UIKit
import RxCocoa
import RxSwift
import Floaty
import ColorSlider

class DeviceInfoViewController: UIViewController {
    
    // MARK: - UI
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var tableViewTitleLabel: UILabel!
    @IBOutlet weak var caracteristicsTableView: UITableView!
    
    @IBOutlet weak var dynamicViewContainer: UIView!
    
    
    // MARK: - Utils
    let localizerUtils = ScreensLabelLocalizableUtils.shared
    let localizeLabels = ScreensLabelLocalizableUtils.shared
    let colorUtils = ColorUtils.shared
    
    // MARK: - Local data
    var deviceData: HubAccessoryConfigurationDto?
    var disposeBag = DisposeBag()
    let favClicStream = PublishSubject<String>()
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<HeaderItem, ListItem>!
    var objectInfoKeyValue: [String: String] = [:]
    var objectInfoNames: [String] = []
    var deviceVM: DeviceViewModel?
    
    var actionToSend: [String: Any] = [:]
    var devicesActionsValues: [String: Any] = [:]
    
    var favButton: UIBarButtonItem?
    var okButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.actionToSend["friendly_name"] = self.deviceData!.friendlyName
        self.deviceVM = DeviceViewModel(navigationCtrl: self.navigationController!)
        // MARK: - TODO Put everything inside Scroll view
        self.setUpUI()
        self.setUpData()
        self.setUpClickObservers()
        
        self.insertSlierComponent(forType: .BrightnessSlider, xPos: CGFloat(15), yPos: CGFloat(20))
        self.insertColorComponent(yPos: CGFloat(100))
        self.insertSlierComponent(forType: .ColorTempSlider, xPos: CGFloat(15), yPos: CGFloat(220))
        
        NSLayoutConstraint.activate([
            // OK
            self.dynamicViewContainer.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

    private func setUpUI(){
        self.setUpNavBar()
        self.setUpFAB()
        self.setUpTableView()
        self.setUpLabels()
    }
    
    @objc func sliderDidChange(_ sender: UISlider){
        if( sender.tag == 0){
            print("Brightness slider value changed to value: \(sender.value)")
            self.deviceData?.actions?.brightness?.currentState = Int(sender.value)
        }else{
            print("Color temp slider value changed to value: \(sender.value)")
            self.deviceData?.actions?.colorTemp?.currentState = Int(sender.value)
        }
        self.updateDeviceActions()
    }
    
    @objc func changedColor(_ slider: ColorSlider) {
        var color = slider.color
        self.deviceData?.actions?.color?.currentState = color.toHexString()
        self.updateDeviceActions()
    }
    
    private func updateDeviceActions(){
        devicesActionsValues["brightness"] = self.deviceData!.actions!.brightness!.currentState
        if(self.deviceData!.actions!.colorTemp!.currentState != 0){
            devicesActionsValues["color_temp"] = self.deviceData!.actions!.colorTemp!.currentState
        }else{
            devicesActionsValues["color"] = ["hex": self.deviceData!.actions!.color!.currentState]
        }
        actionToSend["actions"] = devicesActionsValues
        self.deviceVM?.sendDeviceAction(body: actionToSend)
    }
    
    private func setUpNavBar(){
        let isObjectFavourite = self.deviceData?.isFav
        let favIcon = isObjectFavourite ?? false ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        let okButtonText = self.localizerUtils.objectInfoOkButtonLabelText
        
        okButton = UIBarButtonItem(title: okButtonText , style: .plain, target: self, action: nil)
        favButton = UIBarButtonItem(image: favIcon, style: .plain, target: self, action: nil)
        
        self.navigationItem.rightBarButtonItems = [okButton!, favButton!]
        guard let objectName = self.deviceData?.name else {
            return
        }
        
        self.navigationItem.title = objectName
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : self.colorUtils.hexStringToUIColor(hex: (self.deviceData?.backgroundColor)!)]
    }
    
    
    private func setUpTableView(){
        self.caracteristicsTableView.delegate = self
        self.caracteristicsTableView.dataSource = self
        self.caracteristicsTableView.layer.masksToBounds = true
        self.caracteristicsTableView.register(UINib(nibName: "ObjectInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "CHAR_CELL")
        self.caracteristicsTableView.tableFooterView = UIView()
        
        self.tableViewContainer.layer.cornerRadius = 12.0
        self.tableViewContainer.layer.masksToBounds = true
    }
    
    private func setUpFAB(){
        
        let floatingActionButton = Floaty()
        floatingActionButton.buttonImage = UIImage(systemName: "play.fill")
        floatingActionButton.size = CGFloat(60.0)
        floatingActionButton.plusColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        floatingActionButton.buttonColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        // These 2 lines trigger the handler of the first item without opening the floaty items menu
        floatingActionButton.handleFirstItemDirectly = true
        floatingActionButton.addItem(title: "") { (flb) in
            guard let isOn = self.deviceData?.isOn else{
                return
            }
            floatingActionButton.buttonColor = !isOn ? #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) : #colorLiteral(red: 0.8078431487, green: 0.03080267302, blue: 0.112645736, alpha: 1)
            floatingActionButton.buttonImage = !isOn ? UIImage(systemName: "play.fill") : UIImage(systemName: "stop.fill")
            
            self.deviceData?.isOn = !isOn
        }
        
        self.view.addSubview(floatingActionButton)
    }
    
    private func setUpLabels(){
        self.locationLabel.text = self.deviceData?.roomName
        self.locationTitleLabel.text = self.localizeLabels.objectRoomNameTitleLabelText
        self.tableViewTitleLabel.text = self.localizeLabels.objectCaracteristicsTitleLabelText
    }
    
    private func setUpData(){
        let manufacturerLabel = self.localizerUtils.objectInfoManufacturerLabelText
        
        // MARK: - Remove from localize files
        //let serialNumberLabel = self.localizerUtils.objectInfoSerialNumberLabelText
        //let versionLabel = self.localizerUtils.objectInfoVersionLabelText
        let modeleLabel = self.localizerUtils.objectInfoModeleLabelText
        let reachabilityLabel = self.localizerUtils.objectCellReachabilityLabelText
        let reachableStatus = (self.deviceData?.isReachable ?? false) ?
                                self.localizerUtils.objectCellReachabilityStatusOkLabelText :
                                self.localizerUtils.objectCellReachabilityStatusKoLabelText
        
        self.objectInfoNames = [manufacturerLabel,
                                modeleLabel, reachabilityLabel]
        
        self.objectInfoKeyValue[manufacturerLabel] = self.deviceData?.manufacturer
        self.objectInfoKeyValue[modeleLabel] = self.deviceData?.model
        self.objectInfoKeyValue[reachabilityLabel] = reachableStatus
    }
    
    private func setUpClickObservers(){
        
        self.favButton?
            .rx
            .tap.bind{
                guard let isFav = self.deviceData?.isFav else{
                    return
                }
                
                let isFavIcon = !isFav ?
                    UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
                self.favButton?.image = isFavIcon
                self.favClicStream.onNext(self.deviceData?.friendlyName ?? "")
            }.disposed(by: self.disposeBag)
        
        self.okButton?
            .rx
            .tap.bind{
                self.dismiss(animated: true, completion: nil)
        }.disposed(by: self.disposeBag)

    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        super.traitCollectionDidChange(previousTraitCollection)
        self.caracteristicsTableView.reloadData()
    }
}


extension DeviceInfoViewController: UITableViewDelegate{
    
}

extension DeviceInfoViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CHAR_CELL") as? ObjectInfoTableViewCell
        let objectCurrentInfo = self.objectInfoNames[indexPath.row]
        
        cell?.objectInfoName.text = objectCurrentInfo
        cell?.objectInfoValue?.text = self.objectInfoKeyValue[objectCurrentInfo]
        if self.traitCollection.userInterfaceStyle == .dark {
            cell?.backgroundColor = .black
        }else{
            cell?.backgroundColor = .white
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

//        if (cell.responds(to: #selector(getter: UIView.tintColor))){
//            if tableView == self.caracteristicsTableView {
//                let cornerRadius: CGFloat = 12.0
//                if self.traitCollection.userInterfaceStyle == .dark {
//                    cell.backgroundColor = .black
//                }else{
//                    cell.backgroundColor = .white
//                }
//                let layer: CAShapeLayer = CAShapeLayer()
//                let path: CGMutablePath = CGMutablePath()
//                let bounds: CGRect = cell.bounds
//                bounds.insetBy(dx: 25.0, dy: 0.0)
//                var addLine: Bool = false
//
//                if indexPath.row == 0 && indexPath.row == ( tableView.numberOfRows(inSection: indexPath.section) - 1) {
//                    path.addRoundedRect(in: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
//
//                } else if indexPath.row == 0 {
//                    path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
//                    path.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.minY), tangent2End: CGPoint(x: bounds.midX, y: bounds.minY), radius: cornerRadius)
//                    path.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
//                    path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
//
//                } else if indexPath.row == (tableView.numberOfRows(inSection: indexPath.section) - 1) {
//                    path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
//                    path.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
//                    path.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
//                    path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
//
//                } else {
//                    path.addRect(bounds)
//                    addLine = true
//                }
//
//                layer.path = path
//                layer.fillColor = UIColor.white.withAlphaComponent(0.8).cgColor
//
//                if addLine {
//                    let lineLayer: CALayer = CALayer()
//                    let lineHeight: CGFloat = 1.0 / UIScreen.main.scale
//                    lineLayer.frame = CGRect(x: bounds.minX + 10.0, y: bounds.size.height - lineHeight, width: bounds.size.width, height: lineHeight)
//                    lineLayer.backgroundColor = tableView.separatorColor?.cgColor
//                    layer.addSublayer(lineLayer)
//                }
//
//                let testView: UIView = UIView(frame: bounds)
//                testView.layer.insertSublayer(layer, at: 0)
//                testView.backgroundColor = .clear
//                cell.backgroundView = testView
//            }
//        }
    }
    
}
