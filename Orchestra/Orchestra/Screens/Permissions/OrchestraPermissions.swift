//
//  OrchestraPermissions.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 05/05/2021.
//

import Foundation
import SPPermissions

class OrchestraPermissions{
    private var category: Int = 2
    private var cell: SPPermissionTableViewCell?
    
    private let labelLocalize = ScreensLabelLocalizableUtils()
    
    init(category permissionId: Int, _ cell: SPPermissionTableViewCell) {
        self.category = permissionId
        self.cell = cell
    }
    
    func setPermissionCell() -> SPPermissionTableViewCell {
        var cell: SPPermissionTableViewCell?
        switch self.category {
        case 1:
            //cell = self.setLibraryPermissionCell()
            break
        case 9:
            cell =  self.setLocationPermissionCell()
        case 13:
            cell =  self.setBluetoothPermissionCell()
        case 2:
            cell =  self.setNotificationPermissionCell()
        default:
            break
        }
        return cell!
    }
    
    func setLocationPermissionCell() -> SPPermissionTableViewCell {
        
        self.cell!.permissionTitleLabel.text = self.labelLocalize.permissionsLocationAlertTitle
        self.cell!.permissionDescriptionLabel.text = self.labelLocalize.permissionsLocationAlertDescription
        self.cell!.button.allowTitle = self.labelLocalize.permissionAlertAllowButtonText
        self.cell!.button.allowedTitle = self.labelLocalize.permissionAlertAllowedButtonText

        // Colors
        self.cell!.iconView.color = .systemBlue
        self.cell!.button.allowedBackgroundColor = .systemBlue
        self.cell!.button.allowTitleColor = .systemBlue

        // If you want set custom image.
        let locationIcon = UIImage(systemName: "location.fill")!
        locationIcon.withTintColor(.blue)
        self.cell!.set(locationIcon)
        return self.cell!
    }
    
    func setBluetoothPermissionCell() -> SPPermissionTableViewCell {
        
        self.cell!.permissionTitleLabel.text = self.labelLocalize.permissionsBluetoothAlertTitle
        self.cell!.permissionDescriptionLabel.text = self.labelLocalize.permissionsBluetoothAlertDescription
        self.cell!.button.allowTitle = self.labelLocalize.permissionAlertAllowButtonText
        self.cell!.button.allowedTitle = self.labelLocalize.permissionAlertAllowedButtonText

        // Colors
        self.cell!.iconView.color = .systemBlue
        self.cell!.button.allowedBackgroundColor = .systemBlue
        self.cell!.button.allowTitleColor = .systemBlue

        // If you want set custom image.
        let bluetoothIcon = UIImage(named: "bluetooth")!
        bluetoothIcon.withTintColor(.blue)
        self.cell!.set(bluetoothIcon)
        return self.cell!
    }
    
    func setLibraryPermissionCell() -> SPPermissionTableViewCell {
        self.cell!.permissionTitleLabel.text = "Photos"
        self.cell!.permissionDescriptionLabel.text = "Nous l'utiliserons pour localiser votre domicile sur un plan"
        self.cell!.button.allowTitle = self.labelLocalize.permissionAlertAllowButtonText
        self.cell!.button.allowedTitle = self.labelLocalize.permissionAlertAllowedButtonText

        // Colors
        self.cell!.iconView.color = .systemBlue
        self.cell!.button.allowedBackgroundColor = .systemBlue
        self.cell!.button.allowTitleColor = .systemBlue

        // If you want set custom image.
        //cell.set(UIImage(systemName: "photo.fill.on.rectangle.fill")!)
        return self.cell!
    }
    
    func setNotificationPermissionCell() -> SPPermissionTableViewCell {
        
        self.cell!.permissionTitleLabel.text = self.labelLocalize.permissionsNotificationAlertTitle
        self.cell!.permissionDescriptionLabel.text = self.labelLocalize.permissionsLocationAlertDescription
        self.cell!.button.allowTitle = self.labelLocalize.permissionAlertAllowButtonText
        self.cell!.button.allowedTitle = self.labelLocalize.permissionAlertAllowedButtonText

        // Colors
        self.cell!.iconView.color = .systemBlue
        self.cell!.button.allowedBackgroundColor = .systemBlue
        self.cell!.button.allowTitleColor = .systemBlue

        // If you want set custom image.
        let notificationIcon = UIImage(systemName: "bell.fill")!
        notificationIcon.withTintColor(.blue)
        self.cell!.set(notificationIcon)
        
        return self.cell!
    }
}
