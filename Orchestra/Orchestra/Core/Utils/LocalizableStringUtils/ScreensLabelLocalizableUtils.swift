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
    
    let permissionsCameraAlertTitle = NSLocalizedString("permissions.camera.alert.title", comment: "")
    let permissionsCameraAlertDescription = NSLocalizedString("permissions.camera.alert.description", comment: "")
    
    let permissionsCameraErrorAlertTitle = NSLocalizedString("permission.camera.alert.error.title", comment: "")
    let permissionsCameraErrorAlertDescription = NSLocalizedString("permission.camera.alert.error.description", comment: "")
    
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
    let signupVcButtonText = NSLocalizedString("signup.vc.button.text", comment: "")
    
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
    let sceneInfoDesciptionLabel = NSLocalizedString("scene.info.descritpion.label", comment: "")
    let sceneInfoActionListTitleLabel = NSLocalizedString("scene.info.action.list.title.label", comment: "")
    
    // - MARK: New scene Labels & text
    let newSceneVcTitle = NSLocalizedString("new.scene.vc.title", comment: "")
    let updateSceneVcTitle = NSLocalizedString("update.scene.vc.title", comment: "")
    
    let sceneFormNameLabel = NSLocalizedString("scene.form.name.label.text", comment: "")
    let sceneFormNameTf = NSLocalizedString("scene.form.name.tf.textt", comment: "")
    let sceneFormBackgroundColorLabel = NSLocalizedString("scene.form.bg.color.label.text", comment: "")
    let sceneFormDescriptionLabel = NSLocalizedString("scene.form.description.label.text", comment: "")
    let sceneFormDescriptionTf = NSLocalizedString("scene.form.description.tf.text", comment: "")
    let addActionButtonnText = NSLocalizedString("scene.form.add.action.button", comment: "")
    let newSceneCustomAlertCloseButtonTitle = NSLocalizedString("new.scene.close.custom.view.button.title", comment: "")
    let newSceneDeviceCustomViewTitle = NSLocalizedString("new.scene.device.custom.view.title", comment: "")
    let newSceneActionCustomViewTitle = NSLocalizedString("new.scene.action.custom.view.title", comment: "")
    
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
    let configDeviceVcTitle = NSLocalizedString("config.device.controller.title", comment: "")
    
    // - MARK: Signup Local Network Auth
    let localNetworkAuthAlertTitle = NSLocalizedString("signup.local.network.auth.alert.title", comment: "")
    let localNetworkAuthAlertMessage = NSLocalizedString("signup.local.network.auth.alert.message", comment: "")
    let localNetworkAuthAlertActionTitle = NSLocalizedString("signup.local.network.auth.alert.action.title.label", comment: "")
    
    // - MARK: Signup Information email sent Alert
    let signupEmailSentAlertTitle = NSLocalizedString("signup.local.email.sent.alert.title", comment: "")
    let signupEmailSentAlertMessage = NSLocalizedString("signup.local.email.sent.alert.message", comment: "")
    let signupEmailSentAlertAction = NSLocalizedString("signup.local.email.sent.alert.action", comment: "")
    
    // - MARK: Configuration Reset Alert
    let resetDeviceAlertTitle = NSLocalizedString("reset.device.alert.title", comment: "")
    let resetDeviceAlertMessage = NSLocalizedString("reset.device.alert.message", comment: "")
    let resetDeviceAlertActionTitle = NSLocalizedString("reset.device.alert.main.action.title", comment: "")
    
    // - MARK: Login Local Network Auth
    let loginLocalNetworkAuthAlertTitle = NSLocalizedString("login.local.network.auth.alert.title", comment: "")
    
    // - MARK: Home Loading Home Alert
    let homeScreenProgressAlertTitle = NSLocalizedString("home.screen.progress.alert.title", comment: "")
    let homeScreenProgressFinishedAlertTitle = NSLocalizedString("home.screen.progress.finished.alert.title", comment: "")
    
    // - MARK: Device Available Screen
    let deviceAvailableScreenTitle = NSLocalizedString("device.available.screen.title", comment: "")
    
    // - MARK: New Scene actions for scene
    let loadingDeviceForSceneProgressAlertTitle = NSLocalizedString("device.for.new.scene.progress.title", comment: "")
    let addActionOnDeviceNewSceneButtonTitle = NSLocalizedString("scene.new.action.for.device.button.title", comment: "")
    let newSceneSuccessCreationAlertTitle = NSLocalizedString("new.scene.saved.successfully.alert.title", comment: "")
    
    let deviceActionStateOn = NSLocalizedString("device.action.state.on", comment: "")
    let deviceActionStateOff = NSLocalizedString("device.action.state.off", comment: "")
    let deviceActionStateToggle = NSLocalizedString("device.action.state.toggle", comment: "")
    let deviceActionBrightness100 = NSLocalizedString("device.action.brightness.100", comment: "")
    let deviceActionBrightness75 = NSLocalizedString("device.action.brightness.75", comment: "")
    let deviceActionBrightness50 = NSLocalizedString("device.action.brightness.50", comment: "")
    let deviceActionBrightness25 = NSLocalizedString("device.action.brightness.25", comment: "")
    let deviceActionColor = NSLocalizedString("device.action.color", comment: "")
    let deviceActionTemp100 = NSLocalizedString("device.action.color_temp.100", comment: "")
    let deviceActionTemp75 = NSLocalizedString("device.action.color_temp.75", comment: "")
    let deviceActionTemp50 = NSLocalizedString("device.action.color_temp.50", comment: "")
    let deviceActionTemp25 = NSLocalizedString("device.action.color_temp.25", comment: "")
    
    
    // - MARK: Device Deatil Screen Actions
    let deviceActionBrightnessActionName = NSLocalizedString("device.actions.brightness.label.title", comment: "")
    let deviceActionColorActionName = NSLocalizedString("device.actions.color.label.title", comment: "")
    let deviceActionTemperatureActionName = NSLocalizedString("device.actions.temperature.label.title", comment: "")
    let deviceActionOnActionName = NSLocalizedString("device.actions.on.label.title", comment: "")
    let deviceActionOffActionName = NSLocalizedString("device.actions.off.label.title", comment: "")
    let deviceActionNoActionName = NSLocalizedString("device.actions.noaction.label.title", comment: "")
    
    let deviceConfigurationNeededAlertTitle = NSLocalizedString("device.detail.configuration.needed.alert.title", comment: "")
    let deviceConfigurationNeededAlertMessage = NSLocalizedString("device.detail.configuration.needed.alert.message", comment: "")
    let deviceConfigurationNeededAlertCancelAction = NSLocalizedString("device.detail.configuration.needed.alert.cancel.action", comment: "")
    let deviceConfigurationNeededAlertGoAction = NSLocalizedString("device.detail.configuration.needed.alert.go.action", comment: "")
    
    // - MARK: Configuration Error
    let configurationCallErrorAlertTitle = NSLocalizedString("configuration.error.alert.title", comment: "")
    let configurationCallErrorAlertMessage = NSLocalizedString("configuration.error.alert.message", comment: "")
    
    let noResponseFromServerActionTitle = NSLocalizedString("no.response.server.action.title", comment: "")
    
    // - MARK: Device Form
    let deviceFormVcTitle = NSLocalizedString("device.form.screen.title", comment: "")
    let deviceFormVcUpdateTitle = NSLocalizedString("device.form.screen.update.title", comment: "")
    let deviceFormVcDeviceName = NSLocalizedString("device.form.screen.device.name.label", comment: "")
    let deviceFormVcRoomName = NSLocalizedString("device.form.screen.device.room.name.label", comment: "")
    
    // - MARK: Configuration Tutorial Screen
    let configurationScreenTitle = NSLocalizedString("configuration.screen.title", comment: "")
    let configurationScreenContinueButton = NSLocalizedString("configuration.screen.nav.bar.continue.right.button", comment: "")
    let configurationScreenHeaderText = NSLocalizedString("configuration.screen.header.text", comment: "")
    let configurationScreenStep1Text = NSLocalizedString("configuration.screen.step.1.text", comment: "")
    let configurationScreenStep2Text = NSLocalizedString("configuration.screen.step.2.text", comment: "")
    let configurationScreenStep3Text = NSLocalizedString("configuration.screen.step.3.text", comment: "")
    
    let configurationScreenAlertTitle = NSLocalizedString("configuration.screen.alert.title", comment: "")
    let configurationScreenAlertMessage = NSLocalizedString("configuration.screen.alert.message", comment: "")
    let configurationScreenAlertActionTitle = NSLocalizedString("configuration.screen.alert.action.title", comment: "")
    
    // - MARK: Unknown device detail
    let unknownDeviceLabel = NSLocalizedString("unknown.device.label", comment: "")
    let unknownDeviceButtonTitle = NSLocalizedString("unknown.device.label.button.title", comment: "")
    
    // - MARK: Device Update Screen
    let deviceUpdateScreenPickerViewTitle = NSLocalizedString("device.update.screen.pickerview.title", comment: "")
    
    let deviceUpdatePickerViewLivingRoom = NSLocalizedString("Living room", comment: "")
    let deviceUpdatePickerViewLobby = NSLocalizedString("Lobby", comment: "")
    let deviceUpdatePickerViewBedroom = NSLocalizedString("Bedroom", comment: "")
    let deviceUpdatePickerViewKitchen = NSLocalizedString("Kitchen", comment: "")
    let deviceUpdatePickerViewBathroom = NSLocalizedString("Bathroom", comment: "")
    let deviceUpdatePickerViewGarage = NSLocalizedString("Garage", comment: "")
}
