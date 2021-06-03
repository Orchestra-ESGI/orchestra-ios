//
//  SearchDeviceViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 03/06/2021.
//

import UIKit

class SearchDeviceViewController: UIViewController {

    var retryAppBarButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpTopBar()
    }

    private func setUpTopBar(){
        self.title = "Recherche"
        retryAppBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.counterclockwise"), style: .plain, target: self, action: #selector(self.retrySearch))
        self.retryAppBarButton?.isEnabled = false
        self.retryAppBarButton?.tintColor = .clear
        self.navigationItem.rightBarButtonItem = retryAppBarButton
    }
    
    @objc func retrySearch(){
        print("retry search")
    }
}
