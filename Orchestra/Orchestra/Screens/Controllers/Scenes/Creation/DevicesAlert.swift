//
//  DevicesAlert.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 12/06/2021.
//

import UIKit

class DevicesAlert: UIView{
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeViewButton: UIButton!
    
    var deviceSelectedSection: Int?
    var delegate: CloseCustomViewProtocol?
    let labelLocalization = ScreensLabelLocalizableUtils.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("DevicesAlert", owner: self, options: nil)
        self.commonInit()
        self.localizeCustomView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(){
        self.alertView.layer.cornerRadius = 12
        self.parentView.frame = CGRect(x: 0,
                                       y: 0,
                                       width: UIScreen.main.bounds.width,
                                       height: UIScreen.main.bounds.height)
    }
    
    private func localizeCustomView(){
        let closeButtonString = self.labelLocalization.newSceneCustomAlertCloseButtonTitle
        
        self.closeViewButton.setTitle(closeButtonString, for: .normal)
    }
    
    @IBAction func Closealert(_ sender: Any) {
        self.delegate?.popOffView()
    }
}
