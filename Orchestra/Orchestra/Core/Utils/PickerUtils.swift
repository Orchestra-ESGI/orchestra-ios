//
//  PickerUtils.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/06/2021.
//

import Foundation
import UIKit
import SnapKit

class PickerViewPresenter: UITextField, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private lazy var doneToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        let toolBarTitleValue = self.pickerViewToolBarTitle
        let toolBarTitle = ToolBarTitleItem(text: toolBarTitleValue,
                                            font: .systemFont(ofSize: 20),
                                            color: .white)

        let items = [toolBarTitle, flexSpace, doneButton]
        toolbar.items = items
        toolbar.sizeToFit()

        return toolbar
    }()

    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()

    var pickerSecondColumnItems: [[String]] = []
    var pickerThirdColumnItems: [String] = []
    var pickerFourthColumnItems: [String] = []
    
    var onePickerViewDidSelectItem: ((Any) -> Void)?

    private var selectedItem: String?
    private var selectedItemIndex: Int = 0
    private var selectedActionStateIndex: Int = 0
    private var selectedActionOperatorIndex: Int = 0
    private var selectedActionTypeIndex: Int = 0
    
    private var selectedSecondColumnItem: String?
    private var selectedSecondColumnItemIndex: Int?
    
    private var columns = 0
    private var filterColumns = 1
    
    private var devices: [[String: Any]] = []
    private var devicesName: [String] = [] // first column
    
    private let typeActions = ["temperature", "humidity"] // Second column
    private let operators = ["gt", "lt"] // Third column
    
    private var actions: [String] = [] // the most right column
    
    var pickerViewToolBarTitle = ""
    
    init(_ columns: Int, items: Any, closePickerCompletion: @escaping ((Any) -> Void), toolBarTitle: String) {
        super.init(frame: .zero)
        if(columns > 0){
            self.columns = columns
            self.filterColumns = self.columns
            
            if let itemDictionnary = items as? [[String: Any]]{
                self.devices = itemDictionnary
                let allKeys = itemDictionnary.map { item in
                    return item.keys.first!
                }
                
                self.devicesName.append(contentsOf: allKeys)
                if(columns > 1){
                    var actionsName: [String] = []
                    var counter = 0
                    for item in itemDictionnary{
                        let itemValues = item[self.devicesName[counter]] as! [String: Any]
                        let states = itemValues["states"] as? [String] ?? []
                        actionsName.append(contentsOf: states)
                        self.pickerSecondColumnItems.insert(actionsName, at: counter)
                        actionsName.removeAll()
                        counter += 1
                    }
                }
                self.actions = self.pickerSecondColumnItems[0]
            } else if let itemArray = items as? [String]{
                for item in itemArray{
                    self.devicesName.append(item)
                }
            }
            if(devicesName.count > 0){
                self.selectedItemIndex = 0
            }
            if(actions.count > 0){
                self.selectedSecondColumnItemIndex = 0
            }
            self.onePickerViewDidSelectItem = closePickerCompletion
            
            self.pickerViewToolBarTitle = toolBarTitle
            setupView()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        inputView = pickerView
        inputAccessoryView = doneToolbar
    }

    @objc private func doneButtonTapped() {
        if(self.filterColumns == 1){
            self.onePickerViewDidSelectItem!(selectedItemIndex)
        }else{
            var data: [String: Any] = [
                "device_index": self.selectedItemIndex,
                "action_index": self.selectedSecondColumnItemIndex ?? 0,
            ]
            if(self.filterColumns > 2){
                data["operator"] = self.operators[selectedActionOperatorIndex]
                data["state"] = self.actions[selectedSecondColumnItemIndex ?? 0]
                data["type"] = typeActions[selectedActionStateIndex]
            }
            self.onePickerViewDidSelectItem!(data)
        }
        resignFirstResponder()
    }

    func showPicker() {
        becomeFirstResponder()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if(self.columns == 1){
            return 1
        }
        let firstDeviceName = (selectedItem != nil ? selectedItem : devicesName[0]) ?? devicesName[0]
        let deviceIndex = selectedItemIndex
        let deviceDictionnary = self.devices[deviceIndex][firstDeviceName] as? [String: Any] ?? [:]
        if deviceDictionnary["type"] != nil{
            self.filterColumns = 4
        }else{
            self.filterColumns = 2
        }
        return self.filterColumns
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 0){
            return self.devicesName.count
        }else if(component == 1 && self.filterColumns > 2){
            // This case is triggered only if there is Temperature or Humidity in trigger devices
            return self.typeActions.count
        }else if(component == 2 && self.filterColumns > 2){
            // This case is triggered only if there is Temperature or Humidity in trigger devices
            return self.operators.count
        }else if(component == self.self.filterColumns - 1){
            return self.actions.count
        }
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(component == 0){
            return NSLocalizedString(devicesName[row] , comment: "")
        }else if(component == 1 && self.filterColumns > 2){
            // This case is triggered only if there is Temperature or Humidity in trigger devices
            return NSLocalizedString(self.typeActions[row], comment: "")
        }else if(component == 2 && self.filterColumns > 2){
            // This case is triggered only if there is Temperature or Humidity in trigger devices
            return NSLocalizedString(self.operators[row], comment: "")
        }else if(component == self.filterColumns - 1){
            return NSLocalizedString(self.actions[row], comment: "")
        }
        
        return NSLocalizedString("-" , comment: "")
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component == 0){
            selectedItem = devicesName[row]
            selectedItemIndex = row
            if(self.filterColumns > 1){
                let deviceDictionnary = self.devices[row][selectedItem!] as? [String: Any] ?? [:]
                if deviceDictionnary["type"] != nil{
                    // device has a type, its either temperature of humidity
                    if(self.columns > 2){
                        self.filterColumns = 4
                        pickerView.reloadAllComponents()
                    }
                }else{
                    self.filterColumns = 2
                    pickerView.reloadAllComponents()
                }
            }
            if(self.columns > 1){
                self.actions = pickerSecondColumnItems[row]
                pickerView.reloadComponent(self.filterColumns - 1)
            }
        }else if(component == 1 && self.filterColumns > 2){
            // This case is triggered only if there is Temperature or Humidity in trigger devices
            self.selectedActionStateIndex = row
        }else if(component == 2 && self.filterColumns > 2){
            // This case is triggered only if there is Temperature or Humidity in trigger devices
            self.selectedActionOperatorIndex = row
        }else if(component == self.filterColumns - 1){
            selectedSecondColumnItem = NSLocalizedString(self.actions[row], comment: "")
            self.selectedSecondColumnItemIndex = row
        }else{
            selectedItem = devicesName[row]
            selectedItemIndex = row
        }
    }
}

enum PickerType {
    case OneColumn
    case TwoColumn
    case ThreeColumn
}

class ToolBarTitleItem: UIBarButtonItem {

    init(text: String, font: UIFont, color: UIColor) {
        let label =  UILabel(frame: UIScreen.main.bounds)
        label.text = text
        label.sizeToFit()
        label.font = font
        label.textColor = color
        label.textAlignment = .center
        super.init()
        customView = label
    }
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
}
