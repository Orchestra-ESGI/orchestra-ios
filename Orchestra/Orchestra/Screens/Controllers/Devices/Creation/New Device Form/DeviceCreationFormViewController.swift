//
//  DeviceCreationFormViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 02/06/2021.
//

import UIKit
import RxCocoa
import RxSwift
import ObjectMapper

class DeviceCreationFormViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - UI
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var deviceNameTextField: UITextField!
    
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var roomNameTextField: UITextField!
    
    @IBOutlet weak var deviceBackgroundColorsCollectionView: UICollectionView!
    
    @IBOutlet weak var addDeviceToFavLabel: UILabel!
    @IBOutlet weak var favDeviceSwitch: UISwitch!
    
    var validateFormAppBarBtn: UIBarButtonItem?
    var saveDeviceDelegate: SendDeviceProtocol?
    
    // MARK: - Local data
    var deviceFavState = false
    var accessoryType: String = ""
    var accessoryDocUrl: String = ""
    var deviceBackgrounds: [UIColor] = []
    var selectedColor = 0
    let disposebag = DisposeBag()
    var isDeviceDocumented = false // Depending on the field 'documentation' in the conf
    let deviceViewModel = DeviceViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTopBar()
        self.setUpTextFields()
        self.setUpclickObservers()
        self.setColorsCollectionView()
        let homeViewController = self.navigationController?.viewControllers[0] as? HomeViewController
        self.saveDeviceDelegate = homeViewController
    }
    
    private func setTopBar(){
        self.setTitle()
        
        validateFormAppBarBtn = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: nil)
        validateFormAppBarBtn?.isEnabled = true
        self.navigationItem.rightBarButtonItem = validateFormAppBarBtn
        
    }
    
    private func setUpclickObservers(){
        _ = self.validateFormAppBarBtn!.rx.tap.bind{
            if(self.isDeviceDocumented){
                let deviceConfVC = DevicePhysicalConfigurationVC()
                deviceConfVC.deviceDocumentationUrl = self.accessoryDocUrl
                self.navigationController?.pushViewController(deviceConfVC, animated: true)
            }else{
                let searchVC = SearchDeviceViewController()
                self.navigationController?.pushViewController(searchVC, animated: true)
            }
//            self.saveDeviceDelegate?.save(device: self.createDevice())
//            for _ in 1...2{
//                self.navigationController?.viewControllers.remove(at: 1)
//            }
//            self.navigationController?.popViewController(animated: true)
        }.disposed(by: self.disposebag)
    }
    
    private func setUpStreamsObserver(){
        _ = self.deviceViewModel
            .deviceFormCompleted
            .subscribe { isValid in
                if isValid {
                    self.validateFormAppBarBtn?.isEnabled = true
                }else{
                    self.validateFormAppBarBtn?.isEnabled = false
                }
            } onError: { err in
                print("Form not valid, cannot submit it")
            }
    }
    
    private func setColorsCollectionView(){
        self.deviceBackgroundColorsCollectionView.delegate = self
        self.deviceBackgroundColorsCollectionView.dataSource = self
        self.deviceBackgroundColorsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "COLOR_CELL")
        self.generatesBackGroundColor()
        self.deviceBackgroundColorsCollectionView.reloadData()
    }
    
    private func setTitle(){
        var controllerTitle = "Ajouter "
        switch self.accessoryType {
        case "lightbulb":
            controllerTitle += "une lampe"
        case "statelessProgrammableSwitch":
            controllerTitle += "un boutton"
        case "occupancySensor":
            controllerTitle += "un détecteur"
        default:
            controllerTitle += ""
        }
        self.title = controllerTitle
    }
    
    private func setUpTextFields(){
        self.deviceNameTextField.delegate = self
        self.roomNameTextField.delegate = self
    }

    @IBAction func shuffleColors(_ sender: Any) {
        self.deviceBackgrounds.removeAll()
        self.generatesBackGroundColor()
        self.deviceBackgroundColorsCollectionView.reloadData()
    }
    
    @IBAction func switchFavState(_ sender: Any) {
        self.deviceFavState = ((sender as? UISwitch)?.isOn)!
    }
    
    private func generatesBackGroundColor(){
        ColorUtils.shared.generatesBackGroundColor(colorArray: &self.deviceBackgrounds, size: 6)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField === self.deviceNameTextField){
            textField.resignFirstResponder()
            self.roomNameTextField.becomeFirstResponder()
        } else{
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    // Never call this func before checking all the form
    private func createDevice() -> HubAccessoryConfigurationDto{
        let newDeviceMap: [String: Any] = [
            "type": self.accessoryType,
            "name": self.deviceNameTextField.text!,
            "roomName": self.roomNameTextField.text!,
            "backgroundColor": self.deviceBackgrounds[selectedColor].toHexString(),
            "manufacturer": "",
            "model": "",
            "isOn": false,
            "isFav": self.deviceFavState,
            "isReachable": false,
            "version": "",
            "actions": [],
            "friendlyName": ""
        ]
        
        return Mapper<HubAccessoryConfigurationDto>().map(JSON: newDeviceMap)!
    }
}


protocol SendDeviceProtocol {
    func save(device: HubAccessoryConfigurationDto)
}
