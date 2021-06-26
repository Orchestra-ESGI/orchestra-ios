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
    var dynamicColorContainerLabel: UILabel?
    var dynamicColorContainerSlider: ColorSlider?
    var dynamicTemperatureContainerLabel: UILabel?
    var dynamicTemperatureContainerSlider: UISlider?
    
    var favButton: UIBarButtonItem?
    var okButton: UIBarButtonItem?
    var setupWarningButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.actionToSend["friendly_name"] = self.deviceData!.friendlyName
        self.deviceVM = DeviceViewModel(navigationCtrl: self.navigationController!)
        // MARK: - TODO Put everything inside Scroll view
        self.setUpUI()
        self.addDynamicComponents()
        self.setUpData()
        self.setUpClickObservers()
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            print("Current state is Color")
            self.dynamicColorContainerLabel?.isHidden = false
            self.dynamicTemperatureContainerLabel?.isHidden = true
            
            self.dynamicColorContainerSlider?.isHidden = false
            self.dynamicColorContainerSlider?.isEnabled = true
            
            self.dynamicTemperatureContainerSlider?.isHidden = true
            self.dynamicTemperatureContainerSlider?.isEnabled = false
        }else{
            print("Current state is Temp")
            self.dynamicColorContainerLabel?.isHidden = true
            self.dynamicTemperatureContainerLabel?.isHidden = false
            
            self.dynamicColorContainerSlider?.isHidden = true
            self.dynamicColorContainerSlider?.isEnabled = false
            
            self.dynamicTemperatureContainerSlider?.isHidden = false
            self.dynamicTemperatureContainerSlider?.isEnabled = true
        }
    }
    
    @objc func onOnffToggled(_ sender: UISegmentedControl){
        if(sender.selectedSegmentIndex == 0){
            self.deviceData?.actions?.state = "on"
        }else{
            self.deviceData?.actions?.state = "off"
        }
        self.updateDeviceActions()
    }

    private func setUpUI(){
        self.setUpNavBar()
        self.setUpTableView()
        self.setUpLabels()
    }
    
    @objc func sliderDidChange(_ sender: UISlider){
        if( sender.tag == 0){
            self.deviceData?.actions?.brightness?.currentState = Int(sender.value)
        }else{
            self.deviceData?.actions?.colorTemp?.currentState = Int(sender.value)
        }
        self.updateDeviceActions()
    }
    
    @objc func changedColor(_ slider: ColorSlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .ended:
                self.deviceData?.actions?.color?.currentState = slider.color.toHexString()
                self.updateDeviceActions()
            default:
                break
            }
        }
    }
    
    private func updateDeviceActions(){
        switch self.deviceData?.type {
        case .LightBulb:
            devicesActionsValues["brightness"] = self.deviceData!.actions!.brightness!.currentState
            devicesActionsValues["state"] = self.deviceData!.actions!.state
            
            if let temperatureSlider = self.dynamicTemperatureContainerSlider, !temperatureSlider.isHidden{
                devicesActionsValues["color_temp"] = self.deviceData!.actions!.colorTemp!.currentState
            }
            
            if let colorSlider = self.dynamicColorContainerSlider, !colorSlider.isHidden{
                devicesActionsValues["color"] = ["hex": self.deviceData!.actions!.color!.currentState]
            }
            break
        case .Switch:
            devicesActionsValues["state"] = self.deviceData!.actions!.state
            break
        default:
            break
        }
        
        actionToSend["actions"] = devicesActionsValues
        self.deviceVM?.sendDeviceAction(body: actionToSend)
    }
    
    private func setUpNavBar(){
        let warningIcon = UIImage(systemName: "exclamationmark.triangle.fill")
        
        let okButtonText = self.localizerUtils.objectInfoOkButtonLabelText
        
        okButton = UIBarButtonItem(title: okButtonText , style: .plain, target: self, action: nil)
        
        if(deviceData?.type == .Unknown){
            setupWarningButton = UIBarButtonItem(image: warningIcon, style: .plain, target: self, action: nil)
            setupWarningButton?.tintColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
            self.navigationItem.leftBarButtonItem = setupWarningButton
        }
        
        self.navigationItem.rightBarButtonItem = okButton!
        
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
        
        self.okButton?
            .rx
            .tap.bind{
                self.dismiss(animated: true, completion: nil)
        }.disposed(by: self.disposeBag)
        
        self.setupWarningButton?
            .rx
            .tap.bind{
                let alert = UIAlertController(title: "Configuration demandée!", message: "Pour pouvoir utiliser pleinement cet appraeil, une configuration supplémentaire est obligatoire. Si cette configuration n'est pas faite, l'objet ne peut pas fonctionner! ", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Plus tard", style: .cancel, handler: { action in
                })
                
                let goAction = UIAlertAction(title: "Allons-y", style: .default, handler: { action in
                    let configVc = NewDevicePairingViewController()
                    configVc.device = self.deviceData
                    self.navigationController?.pushViewController(configVc, animated: true)
                })
                
                alert.addAction(goAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true)
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
