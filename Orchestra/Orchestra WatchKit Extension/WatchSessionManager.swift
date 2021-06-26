//
//  WatchSessionManager.swift
//  Orchestra WatchKit Extension
//
//  Created by Ramzy Kermad on 26/06/2021.
//

import WatchKit
import Foundation
import WatchConnectivity

class WatchSessionManager {
    static let shared = WatchSessionManager()
    var sessionConnectivity: WCSession?
    
    private init(){
        if WCSession.isSupported(){
            let session = WCSession.default
            self.sessionConnectivity = session
        }
    }
}
