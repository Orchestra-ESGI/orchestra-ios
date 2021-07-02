//
//  PickerUtils.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/06/2021.
//

import Foundation
import UIKit
import SnapKit

class PickerUtils{
    static let shared = PickerUtils()
    
    func showPickerView(with components: Int, items: [Any], okAction: @escaping ((Void) -> Void)){
        
    }
    
}



class PickerViewPresenter: UITextField, UIPickerViewDataSource, UIPickerViewDelegate {
    let labelLocalization = ScreensLabelLocalizableUtils.shared
    
    private lazy var doneToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        let toolBarTitleValue = self.labelLocalization.deviceUpdateScreenPickerViewTitle
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

    var itemNames: [String] = []
    var pickerSecondColumnItems: [[String]] = []
    var pickerThirdColumnItems: [String] = []
    
    var onePickerViewDidSelectItem: ((Any) -> Void)?

    private var selectedItem: String?
    private var selectedItemIndex: Int?
    
    private var selectedSecondColumnItem: String?
    private var selectedSecondColumnItemIndex: Int?
    
    private var columns = 1
    
    private var actionValues: [String] = []
    private var actions: [String] = []

    init(_ columns: Int, items: Any, closePickerCompletion: @escaping ((Any) -> Void)) {
        super.init(frame: .zero)
        self.columns = columns
        
        if let itemDictionnary = items as? [[String: Any]]{
            let allKeys = itemDictionnary.map { item in
                return item.keys.first!
            }
            
            self.itemNames.append(contentsOf: allKeys)
            if(columns > 1){
                var actionsName: [String] = []
                var counter = 0
                for item in itemDictionnary{
                    actionsName.append(contentsOf: item.values.first as? [String] ?? [])
                    self.pickerSecondColumnItems.insert(actionsName, at: counter)
                    actionsName.removeAll()
                    counter += 1
                }
                
//                _ = itemDictionnary.compactMap { value -> String? in
//                    if let dictionnary = value as? [String: Any]{
//                        for item in dictionnary.values.first as? [String] ?? []{
//                            if(!actionsName.contains(item)){
//                                actionsName.append(item)
//                            }
//                        }
//                    }
//                    return nil
//                }
            }
            self.actions = self.pickerSecondColumnItems[0]
        } else if let itemArray = items as? [String]{
            for item in itemArray{
                self.itemNames.append(item)
            }
        }
        if(itemNames.count > 0){
            self.selectedItemIndex = 0
        }
        if(actions.count > 0){
            self.selectedSecondColumnItemIndex = 0
        }
        self.onePickerViewDidSelectItem = closePickerCompletion
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        inputView = pickerView
        inputAccessoryView = doneToolbar
    }

    @objc private func doneButtonTapped() {
        if(columns == 1){
            self.onePickerViewDidSelectItem!(selectedItemIndex)
        }else{
            let data = [
                "device_index": self.selectedItemIndex,
                "action_index": self.selectedSecondColumnItemIndex
            ]
            self.onePickerViewDidSelectItem!(data)
        }
        resignFirstResponder()
    }

    func showPicker() {
        becomeFirstResponder()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.columns
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return self.itemNames.count
        case 1:
//            let actionAtComponent = pickerSecondColumnItems[component]
//            if(pickerSecondColumnItems.count > 0){
//                self.selectedSecondColumnItemIndex = 0
//            }
            return self.actions.count
        default:
            if(itemNames.count > 0){
                self.selectedItemIndex = 0
            }
            return itemNames.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return NSLocalizedString(itemNames[row] , comment: "")
        case 1:
            return NSLocalizedString(self.actions[row], comment: "")
        default:
            return NSLocalizedString(itemNames[row] , comment: "")
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedItem = itemNames[row]
            selectedItemIndex = row
            if(self.columns > 1){
                self.actions = pickerSecondColumnItems[row]
                pickerView.reloadComponent(1)
            }
            print("Device selected: \(selectedItem), device position: \(selectedItemIndex)")
        case 1:
            selectedSecondColumnItem = NSLocalizedString(self.actions[row], comment: "")
            self.selectedSecondColumnItemIndex = row
            print("Action selected: \(selectedSecondColumnItem), action position: \(selectedSecondColumnItemIndex)")
        default:
            selectedItem = itemNames[row]
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
