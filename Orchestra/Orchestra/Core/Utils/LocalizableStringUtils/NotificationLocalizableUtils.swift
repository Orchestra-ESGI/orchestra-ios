//
//  NotificationLocalizableUtils.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 01/04/2021.
//

import Foundation

public class NotificationLocalizableUtils {
    static let shared = NotificationLocalizableUtils()
    
    // - MARK: Login Notifications
    let unreachableNotificationTitle = NSLocalizedString("login.notification.unreachable.title", comment: "")
    let unreachableNotificationSubtitle = NSLocalizedString("login.notification.unreachable.subtitle", comment: "")
    
    let okNotificationTitle = NSLocalizedString("login.notification.ok.title", comment: "")
    let okNotificationSubtitle = NSLocalizedString("login.notification.ok.subtitle", comment: "")
    
    let koNotificationTitle = NSLocalizedString("login.notification.ko.title", comment: "")
    let koNotificationSubtitle = NSLocalizedString("login.notification.ko.subtitle", comment: "")
    
    let koApiNotificationTitle = NSLocalizedString("login.notification.koapi.title", comment: "")
    let koApiNotificationSubtitle = NSLocalizedString("login.notification.koapi.subtitle", comment: "")
    
    let loginCredentialsWrongNotificationTitle = NSLocalizedString("login.notification.credantials.wrong.title", comment: "")
    let loginCredentialsWrongNotificationSubtitle = NSLocalizedString("login.notification.credantials.wrong.subtitle", comment: "")
    
    let loginWelcomeNotificatiionTitle = NSLocalizedString("login.welcome.notification.title", comment: "")
    let loginWelcomeNotificationSubtitle = NSLocalizedString("login.welcome.notification.subtitle", comment: "")
    let loginCompleteCheckmarkTitle = NSLocalizedString("login.complete.checkmark.title", comment: "")
    
    
    // - MARK: Progress notifications
    let undeterminedProgressViewTitle = NSLocalizedString("progress.notification.undetermined.title", comment: "")
    let configFinishedProgressViewTitle = NSLocalizedString("progress.notification.config.finished.title", comment: "")
    let editingHomeProgressViewTitle = NSLocalizedString("home.edit.progress.title.text", comment: "")
    let finishEditingHomeProgressViewTitle = NSLocalizedString("home.finish.edit.progress.title.text", comment: "")
    
    // - MARK: Signup Notifications
    
    
    // - MARK: Scenes Notifications
    let successfullyAddedNotificationTitle = NSLocalizedString("new.scene.successfully.created.title", comment: "")
    let successfullyAddedNotificationSubtitle = NSLocalizedString("new.scene.successfully.created.subtitle", comment: "")
    
    let unsuccessfullyAddedNotificationTitle = NSLocalizedString("new.scene.unsuccessfully.created.title", comment: "")
    let unsuccessfullyAddedNotificationSubtitle = NSLocalizedString("new.scene.unsuccessfully.created.subtitle", comment: "")
    
    let removeDataAlertTitle = NSLocalizedString("home.vc.remove.alert.title", comment: "")
    let removeDataAlertSubtitle = NSLocalizedString("home.vc.remove.alert.subtitle", comment: "")
    let removeDataAlertCancelButtonText = NSLocalizedString("home.vc.remove.alert.cancel.button.text", comment: "")
    let removeDataAlertDeleteButtonText = NSLocalizedString("home.vc.remove.alert.delete.button.text", comment: "")
        
    
    init() {
        
    }
}
