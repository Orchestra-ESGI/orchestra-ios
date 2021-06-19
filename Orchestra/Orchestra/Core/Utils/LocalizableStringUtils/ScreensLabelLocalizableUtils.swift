//
//  ScreenLabels.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 04/04/2021.
//

import Foundation


class ScreensLabelLocalizableUtils{
    static let shared = ScreensLabelLocalizableUtils()
    
    // - MARK: Permissions
    let permissionsAlertTitle = NSLocalizedString("permissions.alert.title", comment: "")
    let permissionsAlertHeaderTitle = NSLocalizedString("permissions.alert.header.title", comment: "")
    
    let permissionsNotificationAlertTitle = NSLocalizedString("permissions.notification.alert.title", comment: "")
    let permissionsNotificationAlertDescription = NSLocalizedString("permissions.notification.alert.description", comment: "")
    
    let permissionsLocationAlertTitle = NSLocalizedString("permissions.location.alert.title", comment: "")
    let permissionsLocationAlertDescription = NSLocalizedString("permissions.location.alert.description", comment: "")
    
    let permissionAlertFooterTitle = NSLocalizedString("permission.alert.footer.title", comment: "")
    
    let permissionAlertAllowButtonText = NSLocalizedString("permission.button.allow.text", comment: "")
    let permissionAlertAllowedButtonText = NSLocalizedString("permission.button.allowed.text", comment: "")
    
    // - MARK: Pager Labels and texts
    let pagerSlide1LabelText = NSLocalizedString("pager.slide.1.label.text", comment: "")
    let pagerSlide2LabelText = NSLocalizedString("pager.slide.2.label.text", comment: "")
    let pagerSlide3LabelText = NSLocalizedString("pager.slide.3.label.text", comment: "")
    let pagerSlide4LabelText = NSLocalizedString("pager.slide.4.label.text", comment: "")
    let pagerSlide5LabelText = NSLocalizedString("pager.slide.1.label.text", comment: "")
    
    let pageSlide1TitleLabelText = NSLocalizedString("pager.slide.1.title.label.text", comment: "")
    let pageSlide2TitleLabelText = NSLocalizedString("pager.slide.2.title.label.text", comment: "")
    let pageSlide3TitleLabelText = NSLocalizedString("pager.slide.3.title.label.text", comment: "")
    let pageSlide4TitleLabelText = NSLocalizedString("pager.slide.4.title.label.text", comment: "")
    let pageSlide5TitleLabelText = NSLocalizedString("pager.slide.5.title.label.text", comment: "")
    
    // - MARK: Login Labels and texts
    let loginBigText = NSLocalizedString("login.vc.welcome.text", comment: "")
    let loginEmailLabelText = NSLocalizedString("login.vc.email.label.text", comment: "")
    let loginEmailLabelHint = NSLocalizedString("login.vc.email.label.hint", comment: "")
    let loginPasswordLabelText = NSLocalizedString("login.vc.password.label.text", comment: "")
    let loginPasswordForgotButtonText = NSLocalizedString("login.vc.password.forgot.buttonn.text", comment: "")
    let loginConnexionButtonText = NSLocalizedString("login.vc.connexion.button.text", comment: "")
    let loginSigupbButtonText = NSLocalizedString("login.vc.signup.button.text", comment: "")
    let noAccountLabelText = NSLocalizedString("login.vc.no.account.label.text", comment: "")


    // - MARK: Signup Labels and texts
    let signupVcTitle = NSLocalizedString("signup.vc.title", comment: "")
    let sigupVcAppbarSendFormButtonTitle = NSLocalizedString("signup.vc.appbar.send.form", comment: "")
    let signupWelcomText = NSLocalizedString(NSLocalizedString("signup.vc.welcome.text", comment: ""), comment: "")
    let signupVcEmailLabelText = NSLocalizedString("signup.vc.email.label.text", comment: "")
    let signupVcPasswordLabelText = NSLocalizedString("signup.vc.password.label.text", comment: "")
    let signupVcPasswordVerificationLabelText = NSLocalizedString("signup.vc.password.second.label.text", comment: "")
    let signnupVcNameLabelText = NSLocalizedString("signup.vc.name.label.text", comment: "")
    
    // - MARK: Home Labels & text
    let homeHeaderObjectsText = NSLocalizedString("home.collection.header.objects", comment: "")
    let homeHeaderScenesText = NSLocalizedString("home.collection.header.scenes", comment: "")
    let objectCellReachabilityStatusOkLabelText = NSLocalizedString("home.object.cell.reachability.status.ok.label.text", comment: "")
    let objectCellReachabilityStatusKoLabelText = NSLocalizedString("home.object.cell.reachability.status.ko.label.text", comment: "")
    let floatyButtonPairingButtonTitle = NSLocalizedString("floaty.pairing.item.title", comment: "")
    let floatyButtonShareButtonTitle = NSLocalizedString("floaty.share.item.title", comment: "")
    let floatyButtonRateButtonTitle = NSLocalizedString("floaty.pairing.rate.title", comment: "")
    
    // - MARK: Object info Labels & text
    let objectInfoOnOffButtonText = NSLocalizedString("object.info.onoff.button.text", comment: "")
    let objectInfoManufacturerLabelText = NSLocalizedString("object.info.manufacturer.label.text", comment: "")
    let objectInfoSerialNumberLabelText = NSLocalizedString("object.info.serial.label.text", comment: "")
    let objectInfoModeleLabelText = NSLocalizedString("object.info.model.label.text", comment: "")
    let objectInfoVersionLabelText = NSLocalizedString("object.info.version.label.text", comment: "")
    let objectCellReachabilityLabelText = NSLocalizedString("home.object.cell.reachability.label.text", comment: "")
    let objectInfoOkButtonLabelText = NSLocalizedString("object.info.ok.button.label.text", comment: "")
    let objectRoomNameTitleLabelText = NSLocalizedString("object.info.room.name.title.text", comment: "")
    let objectCaracteristicsTitleLabelText = NSLocalizedString("object.info.characteristics.title.text", comment: "")
    
    // - MARK: Scene info Labels & text
    let sceneInfoStartingSceneProgressAlertTitle = NSLocalizedString("scene.info.startnig.progress.alert.title", comment: "")
    
    // - MARK: New scene Labels & text
    let newSceneVcTitle = NSLocalizedString("new.scene.vc.title", comment: "")
    let updateSceneVcTitle = NSLocalizedString("update.scene.vc.title", comment: "")
    
    let sceneFormNameLabel = NSLocalizedString("scene.form.name.label.text", comment: "")
    let sceneFormNameTf = NSLocalizedString("scene.form.name.tf.textt", comment: "")
    let sceneFormBackgroundColorLabel = NSLocalizedString("scene.form.bg.color.label.text", comment: "")
    let sceneFormDescriptionLabel = NSLocalizedString("scene.form.description.label.text", comment: "")
    let sceneFormDescriptionTf = NSLocalizedString("scene.form.description.tf.text", comment: "")
    let addActionButtonnText = NSLocalizedString("scene.form.add.action.button", comment: "")
    
    
    // -  MARK: Pairing to hub Labels & text
    let hubPairingVcTitle = NSLocalizedString("hub.pairing.vc.topbar.title", comment: "")
    let hubPairingAlertInfoTitle = NSLocalizedString("hub.pairing.info.alert.title", comment: "")
    let hubPairingAlertInfoBodyText = NSLocalizedString("hub.pairing.info.alert.body.text", comment: "")
    let hubPairingAlertInfoOkButtonText = NSLocalizedString("hub.pairing.info.alert.ok.button.text", comment: "")
    
    let hubPairingProgressAlertTitle = NSLocalizedString("hub.pairing.progress.alert.title", comment: "")
    let hubPairingVcPairingCodeLabel = NSLocalizedString("hub.pairing.vc.code.label", comment: "")
    let hubPairingVcReachableHubLabel = NSLocalizedString("hub.pairing.vc.reachable.hub", comment: "")
    
    // - MARK: Home Screen BottomSheet
    let homeScreenBottomSheetTitle = NSLocalizedString("home.screen.bottom.sheet.title", comment: "")
    let homeScreenBottomSheetAddHouseButtonTitle = NSLocalizedString("home.screen.bottom.sheet.add.home.button", comment: "")
    
    // - MARK: Home Screen Nav Bar plus button alert
    let homePlusButtonAlertNewScene = NSLocalizedString("home.screen.new.scene.alert", comment: "")
    let homePlusButtonAlertNewDevice = NSLocalizedString("home.screen.new.device.alert", comment: "")
    let homePlusButtonAlertNewHouse = NSLocalizedString("home.screen.new.house.alert", comment: "")
    
    // - MARK: Add New Device Screen (supported types)
    let newDeviceVcTitle = NSLocalizedString("new.device.controller.title", comment: "")
}
