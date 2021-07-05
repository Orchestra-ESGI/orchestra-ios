//
//  WatchLabelLocalizableUtils.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 26/06/2021.
//

import Foundation

class WatchLabelLocalizableUtils{
    static let shared = WatchLabelLocalizableUtils()
    
    // - MARK: Watch Home Screen
    let homeScreenMyScenesLabelTitle = NSLocalizedString("watch.home.screen.myscenes", comment: "")
    let homeScreenMyDevicesLabelTitle = NSLocalizedString("watch.home.screen.mydevices", comment: "")
    
    // - MARK: Watch Scenes Screen
    let myScenesScreenTitle = NSLocalizedString("watch.myscenes.screen.title", comment: "")
    let myScenesScreenLoaderLabelTitle = NSLocalizedString("watch.myscenes.loader.label.title", comment: "")
    
    // - MARK: Watch Devices Screen
    let myDevicesScreenTitle = NSLocalizedString("watch.mydevices.screen.title", comment: "")
    let myDevicesScreenLoaderLabelTitle = NSLocalizedString("watch.mydevices.loader.label.title", comment: "")
    
    // - MARK: Watch Device Actions Screen
    let deviceDetailTitle = NSLocalizedString("watch.deviceaction.title", comment: "")
    let deviceSelectActionLabelTitle = NSLocalizedString("watch.deviceaction.hint.label.title", comment: "")
    let deviceNoActionLabelTitle = NSLocalizedString("watch.deviceaction.empty.label.title", comment: "")
    
    
    // - MARK: Watch Device Actions Name
    let deviceActionTurnOn = NSLocalizedString("watch.deviceaction.turn.on", comment: "")
    let deviceActionTurnOff = NSLocalizedString("watch.deviceaction.turn.off", comment: "")
    let deviceActionBlink = NSLocalizedString("watch.deviceaction.blink", comment: "")
    let deviceActionBrightness100 = NSLocalizedString("watch.deviceaction.brightness.100", comment: "")
    let deviceActionBrightness75 = NSLocalizedString("watch.deviceaction.brightness.75", comment: "")
    let deviceActionBrightness50 = NSLocalizedString("watch.deviceaction.brightness.50", comment: "")
    let deviceActionBrightness25 = NSLocalizedString("watch.deviceaction.brightness.25", comment: "")
    
    
    // - MARK: Watch Empty Label
    let emptyScenesLabel = NSLocalizedString("watch.myscenes.empty.label.title", comment: "")
    let emptyDevicesLabel = NSLocalizedString("watch.mydevices.empty.label.title", comment: "")
}
