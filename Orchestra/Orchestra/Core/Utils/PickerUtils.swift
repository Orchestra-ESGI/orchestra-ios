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

    var items: [RoomDto] = []
    var didSelectItem: ((RoomDto) -> Void)?

    private var selectedItem: RoomDto?

    init() {
        super.init(frame: .zero)
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
        if let selectedItem = selectedItem {
            didSelectItem?(selectedItem)
        }
        resignFirstResponder()
    }

    func showPicker() {
        becomeFirstResponder()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return NSLocalizedString(items[row].name ?? "", comment: "")
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedItem = items[row]
    }
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
