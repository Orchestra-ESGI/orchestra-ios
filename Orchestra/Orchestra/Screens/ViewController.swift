//
//  ViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 23/03/2021.
//

import UIKit
import RxCocoa
import RxSwift


class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let userVM = UsersViewModel()
    let progressUtils = ProgressUtils.shared
    let notificationLocalizable = NotificationLocalizableUtils.shared
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressUtils
            .displayIndeterminateProgeress(title: notificationLocalizable.undeterminedProgressViewTitle, view: self.view)
        
        
    }


}

