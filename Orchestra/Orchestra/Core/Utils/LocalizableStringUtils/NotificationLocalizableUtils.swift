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
    let signupCompleteCheckmarkTitle = NSLocalizedString("signup.progress.finished.title", comment: "")
    let signupProgressCheckmarkTitle = NSLocalizedString("signup.progress.title", comment: "")
    
    // 400
    let badRequestCallNotificationTitle = NSLocalizedString("badRequest.notification.title", comment: "")
    let badRequestCallNotificationSubitle = NSLocalizedString("badRequest.notification.subitle", comment: "")
    
    // 401
    let unauthorizedCallNotificationTitle = NSLocalizedString("unauthorized.notification.title", comment: "")
    let unauthorizedCallNotificationSubitle = NSLocalizedString("unauthorized.notification.subitle", comment: "")
    
    // 403
    let forbiddenCallNotificationTitle = NSLocalizedString("forbidden.notification.title", comment: "")
    let forbiddenCallNotificationSubitle = NSLocalizedString("forbidden.notification.subitle", comment: "")
    
    // 404
    let unknownEndpointCallNotificationTitle = NSLocalizedString("unknown.notification.title", comment: "")
    let unknownEndpointCallNotificationSubitle = NSLocalizedString("unknown.notification.subitle", comment: "")
    
    // 404
    let conflictEndpointCallNotificationTitle = NSLocalizedString("conflict.notification.title", comment: "")
    let conflictEndpointCallNotificationSubitle = NSLocalizedString("conflict.notification.subitle", comment: "")
    
    // 500 & 503
    let serverErrorCallNotificationTitle = NSLocalizedString("server.error.notification.title", comment: "")
    let serverErrorCallNotificationSubitle = NSLocalizedString("server.error.notification.subitle", comment: "")
    
    let homeLoadingErrorNotificationTitle = NSLocalizedString("home.loading.error.notification.title", comment: "")
    let homeLoadingErrorNotificationSubtitle = NSLocalizedString("home.loading.error.notification.subitle", comment: "")
    
    let deleteDeviceErrorNotificationTitle = NSLocalizedString("device.delete.error.notification.title", comment: "")
    let deleteDeviceErrorNotificationSubtitle = NSLocalizedString("device.delete.error.notification.subitle", comment: "")
    
    let saveSceneErrorNotificationTitle = NSLocalizedString("device.save.error.notification.title", comment: "")
    let saveSceneErrorNotificationSubtitle = NSLocalizedString("device.save.error.notification.subtitle", comment: "")
    
    // - MARK: Progress notifications
    let undeterminedProgressViewTitle = NSLocalizedString("progress.notification.undetermined.title", comment: "")
    let configFinishedProgressViewTitle = NSLocalizedString("progress.notification.config.finished.title", comment: "")
    let editingHomeProgressViewTitle = NSLocalizedString("home.edit.progress.title.text", comment: "")
    let finishEditingHomeProgressViewTitle = NSLocalizedString("home.finish.edit.progress.title.text", comment: "")
    let checkMarkSuccessTitle = NSLocalizedString("default.success", comment: "")
    
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
    
    let deviceFormInvalidFormNotificationTitle = NSLocalizedString("device.form.invalid.form.notification.title", comment: "")
    let deviceFormInvalidFormNotificationSubtitle = NSLocalizedString("device.form.invalid.form.notification.subtitle", comment: "")
        
    let sceneCancelAlertTitle = NSLocalizedString("scene.vc.cancel.alert.title", comment: "")
    let sceneCancelAlertMessage = NSLocalizedString("scene.vc.cancel.alert.message", comment: "")
    let sceneCancelAlertCancelButton = NSLocalizedString("scene.vc.cancel.alert.cancel.button", comment: "")
    let sceneCancelAlertContinueButton = NSLocalizedString("scene.vc.cancel.alert.continue.button", comment: "")
    
    let sceneNoActionAlertTitle = NSLocalizedString("scene.vc.noaction.alert.title", comment: "")
    let sceneNoActionAlertMessage = NSLocalizedString("scene.vc.noaction.alert.message", comment: "")
    let sceneNoActionAlertCancelButton = NSLocalizedString("scene.vc.noaction.alert.cancel.button", comment: "")
    
    init() {
        
    }
}
