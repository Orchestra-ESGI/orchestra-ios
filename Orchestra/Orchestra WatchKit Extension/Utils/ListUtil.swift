//
//  ListUtil.swift
//  Orchestra WatchKit Extension
//
//  Created by Ramzy Kermad on 23/05/2021.
//

import WatchKit
import Foundation
import WatchConnectivity

class ListUtil{
    static let shared = ListUtil()
    
    func setUpList<T: RootRowController> (wkTable: WKInterfaceTable, modelList: [Any], rowId: String, type: T.Type, delegate: LaunchSceneDelegate? = nil) {
        wkTable.setNumberOfRows(modelList.count, withRowType: rowId)
        for i in 0 ..< modelList.count {
            let controller = wkTable.rowController(at: i) as! T
            controller.refresh(object: modelList[i])
            
            if(T.self == SceneRow.self){
                let sceneRow = controller as? SceneRow
                sceneRow?.delegate = delegate
            }
        }
    }
}
